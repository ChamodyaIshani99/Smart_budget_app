import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/l10n_ext.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/services/notification_service.dart';
import '../../data/database/debug_seed.dart';
import '../bills/providers/bill_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _service = NotificationService.instance;
  TimeOfDay _time = const TimeOfDay(hour: 9, minute: 0);
  bool _enabled = true;
  int _pending = 0;
  String _currency = 'LKR';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = await _service.areEnabled();
    final pending = await _service.pendingCount();
    if (!mounted) return;
    setState(() {
      _time = TimeOfDay(
        hour: prefs.getInt(AppConstants.prefReminderHour) ?? 9,
        minute: prefs.getInt(AppConstants.prefReminderMinute) ?? 0,
      );
      _currency = prefs.getString(AppConstants.prefDefaultCurrency) ?? 'LKR';
      _enabled = enabled;
      _pending = pending;
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.prefReminderHour, picked.hour);
    await prefs.setInt(AppConstants.prefReminderMinute, picked.minute);
    await _service.rescheduleAll();
    await _load();
  }

  Future<void> _setCurrency(String c) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefDefaultCurrency, c);
    ref.invalidate(defaultCurrencyProvider);
    setState(() => _currency = c);
  }

  Future<void> _setLanguage(String code) async {
    await ref.read(localeProvider.notifier).setLanguage(code);
    await _load();
  }

  Future<void> _askPermission() async {
    await _service.requestPermission();
    await _load();
  }

  Future<void> _testNow() async {
    await _service.requestPermission();
    await _service.showTestNow();
    await _load();
  }

  Future<void> _testScheduled() async {
    await _service.requestPermission();
    await _service.scheduleTestInOneMinute();
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.scheduledSnack)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSettings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.language, style: titleStyle),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'en', label: Text('English')),
              ButtonSegment(value: 'si', label: Text('සිංහල')),
            ],
            selected: {lang},
            onSelectionChanged: (s) => _setLanguage(s.first),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.payments_outlined),
              title: Text(l10n.defaultCurrency),
              trailing: DropdownButton<String>(
                value: _currency,
                underline: const SizedBox.shrink(),
                items: AppConstants.currencies
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => _setCurrency(v!),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(l10n.reminders, style: titleStyle),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: Text(l10n.reminderTime),
                  subtitle: Text(l10n.reminderTimeHint),
                  trailing: Text(_time.format(context),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  onTap: _pickTime,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    _enabled
                        ? Icons.notifications_active
                        : Icons.notifications_off,
                    color: _enabled ? Colors.green : Colors.red,
                  ),
                  title: Text(
                      _enabled ? l10n.notificationsOn : l10n.notificationsOff),
                  subtitle: _enabled ? null : Text(l10n.notificationsOffHint),
                  trailing: _enabled
                      ? null
                      : TextButton(
                          onPressed: _askPermission,
                          child: Text(l10n.allow)),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(l10n.scheduledReminders),
                  trailing: Text('$_pending',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(l10n.testSection, style: titleStyle),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _testNow,
            icon: const Icon(Icons.notifications),
            label: Text(l10n.sendTestNow),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _testScheduled,
            icon: const Icon(Icons.timer),
            label: Text(l10n.scheduleTest),
          ),
          const SizedBox(height: 24),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.batteryTip),
            ),
          ),
          if (kDebugMode) ...[
            const SizedBox(height: 24),
            Text('Developer (debug builds only)', style: titleStyle),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                await DebugSeed.addSamplePayments();
                ref.invalidate(billsProvider);
              },
              icon: const Icon(Icons.science),
              label: const Text('Add sample payments'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                await DebugSeed.removeSamples();
                ref.invalidate(billsProvider);
              },
              icon: const Icon(Icons.delete_sweep),
              label: const Text('Remove sample data'),
            ),
          ],
        ],
      ),
    );
  }
}