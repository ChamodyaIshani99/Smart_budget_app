import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../data/models/bill.dart';
import '../../data/repositories/bill_repository.dart';
import '../constants/app_constants.dart';
import '../utils/helpers.dart';
import 'dart:ui' show Locale;
import '../../l10n/app_localizations.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _ready = false;

  /// Set in main.dart. Called when the user taps a notification.
  void Function(int billId)? onBillTapped;

  static const NotificationDetails _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'bill_reminders',
      'Bill reminders',
      channelDescription: 'Reminders before your bills are due',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  // ---------- setup ----------

  Future<void> init() async {
    if (_ready) return;

    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (e) {
      debugPrint('Could not detect timezone: $e');
    }

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
      ),
      onDidReceiveNotificationResponse: (response) {
        final billId = int.tryParse(response.payload ?? '');
        if (billId != null) onBillTapped?.call(billId);
      },
    );
    _ready = true;
  }
    Future<AppLocalizations> _l10n() async {
    final prefs = await SharedPreferences.getInstance();
    return lookupAppLocalizations(
        Locale(prefs.getString(AppConstants.prefLanguage) ?? 'en'));
  }

  // ---------- permission ----------

  Future<bool> areEnabled() async =>
      await _android?.areNotificationsEnabled() ?? true;

  /// Shows the Android 13+ permission dialog if needed.
  Future<bool> requestPermission() async =>
      await _android?.requestNotificationsPermission() ?? true;

  // ---------- scheduling ----------

    Future<void> rescheduleAll() async {
    try {
      if (!_ready) await init();

      final prefs = await SharedPreferences.getInstance();
      final hour = prefs.getInt(AppConstants.prefReminderHour) ?? 9;
      final minute = prefs.getInt(AppConstants.prefReminderMinute) ?? 0;
      final bills = await BillRepository().getAll();
      final l10n = await _l10n();

      await _plugin.cancelAll();
      for (final bill in bills) {
        await _scheduleForBill(bill, hour, minute, l10n);
      }
    } catch (e) {
      debugPrint('Reschedule failed: $e');
    }
  }

  Future<void> _scheduleForBill(
      Bill bill, int hour, int minute, AppLocalizations l10n) async {
    final billId = bill.id;
    if (billId == null) return;

    tz.TZDateTime at(int y, int m, int d) =>
        tz.TZDateTime(tz.local, y, m, d, hour, minute);

    final now = tz.TZDateTime.now(tz.local);
    final today = DateTime(now.year, now.month, now.day);
    final due = bill.dueDate;
    final money = formatMoney(bill.amount, bill.currency);

    // Overdue: one nudge at the next reminder time.
    if (dateOnly(due).isBefore(today)) {
      var next = at(now.year, now.month, now.day);
      if (!next.isAfter(now)) next = at(now.year, now.month, now.day + 1);
      await _schedule(
        id: billId * 3 + 2,
        billId: billId,
        title: l10n.notifOverdueTitle(bill.title),
        body: l10n.notifOverdueBody(money, formatDate(due)),
        when: next,
      );
      return;
    }

    // Advance reminder.
    if (bill.reminderDays > 0) {
      await _schedule(
        id: billId * 3,
        billId: billId,
        title: l10n.notifUpcomingTitle(bill.title),
        body: l10n.notifUpcomingBody(money, bill.reminderDays, formatDate(due)),
        when: at(due.year, due.month, due.day - bill.reminderDays),
      );
    }

    // Due-day reminder.
    await _schedule(
      id: billId * 3 + 1,
      billId: billId,
      title: l10n.notifDueTodayTitle(bill.title),
      body: l10n.notifDueTodayBody(money),
      when: at(due.year, due.month, due.day),
    );
  }

  Future<void> _schedule({
    required int id,
    required int billId,
    required String title,
    required String body,
    required tz.TZDateTime when,
  }) async {
    if (!when.isAfter(tz.TZDateTime.now(tz.local))) return; // already passed
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: when,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: '$billId',
    );
  }

  // ---------- helpers for the Settings screen ----------

  Future<int> pendingCount() async =>
      (await _plugin.pendingNotificationRequests()).length;

    Future<void> showTestNow() async {
    final l10n = await _l10n();
    await _plugin.show(
      id: 900001,
      title: l10n.testNotifTitle,
      body: l10n.testNotifBody,
      notificationDetails: _details,
    );
  }

  Future<void> scheduleTestInOneMinute() async {
    final l10n = await _l10n();
    await _plugin.zonedSchedule(
      id: 900002,
      title: l10n.scheduledTestTitle,
      body: l10n.scheduledTestBody,
      scheduledDate:
          tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1)),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}