import 'dart:ui' show Locale, PlatformDispatcher;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../services/notification_service.dart';

/// Overridden in main.dart with the real instance.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Override in main.dart'),
);

/// Saved language, else Sinhala if the phone is in Sinhala, else English.
String initialLanguage(SharedPreferences prefs) {
  final saved = prefs.getString(AppConstants.prefLanguage);
  if (saved != null) return saved;
  return PlatformDispatcher.instance.locale.languageCode == 'si' ? 'si' : 'en';
}

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => Locale(initialLanguage(ref.read(sharedPreferencesProvider)));

  Future<void> setLanguage(String code) async {
    await ref
        .read(sharedPreferencesProvider)
        .setString(AppConstants.prefLanguage, code);
    Intl.defaultLocale = code; // dates and numbers follow the language
    state = Locale(code);
    // Scheduled reminders contain text, so rebuild them in the new language.
    await NotificationService.instance.rescheduleAll();
  }
}

final localeProvider =
    NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);