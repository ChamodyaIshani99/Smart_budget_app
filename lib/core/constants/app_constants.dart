class AppConstants {
  static const String dbName = 'smart_budget.db';
  static const int dbVersion = 2;

  // shared_preferences keys
  static const String prefOnboardingDone = 'onboarding_done';
  static const String prefLanguage = 'language';
  static const String prefDefaultCurrency = 'default_currency';
  static const String prefReminderHour = 'reminder_hour';
  static const String prefReminderMinute = 'reminder_minute';
  static const String prefThemeMode = 'theme_mode';

  static const List<String> currencies = [
    'LKR', 'USD', 'EUR', 'GBP', 'INR', 'AUD', 'CAD', 'AED', 'SGD', 'JPY',
  ];
}