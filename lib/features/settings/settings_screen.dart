import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Scheduled. Close the app and wait about a minute.'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Reminders', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text('Reminder time'),
                  subtitle: const Text('Time of day reminders are sent'),
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
                      _enabled ? 'Notifications are on' : 'Notifications are off'),
                  subtitle: _enabled
                      ? null
                      : const Text(
                          'If the dialog does not appear, enable them in phone '
                          'Settings > Apps > Smart Budget > Notifications.'),
                  trailing: _enabled
                      ? null
                      : TextButton(
                          onPressed: _askPermission, child: const Text('Allow')),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: const Text('Scheduled reminders'),
                  trailing: Text('$_pending',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Test', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _testNow,
            icon: const Icon(Icons.notifications),
            label: const Text('Send test notification now'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _testScheduled,
            icon: const Icon(Icons.timer),
            label: const Text('Schedule a test (about 1 minute)'),
          ),
          const SizedBox(height: 24),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Tip: some phones (Huawei, Xiaomi, Oppo, Vivo, Samsung) stop '
                'background apps to save battery, which can delay reminders. '
                'If reminders do not arrive, allow Smart Budget to run in the '
                'background in your phone\'s battery settings.',
              ),
            ),
          ),
            if (kDebugMode) ...[
            const SizedBox(height: 24),
            Text('Developer (debug builds only)',
                style: Theme.of(context).textTheme.titleMedium),
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