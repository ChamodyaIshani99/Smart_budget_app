// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Smart Budget';

  @override
  String get navHome => 'Home';

  @override
  String get navBills => 'Bills';

  @override
  String get navReports => 'Reports';

  @override
  String get navSettings => 'Settings';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get onboardingTitle1 => 'Never miss a bill';

  @override
  String get onboardingBody1 => 'Get reminders before every due date.';

  @override
  String get onboardingTitle2 => 'Track your spending';

  @override
  String get onboardingBody2 => 'See where your money goes each month.';

  @override
  String get onboardingPrefsTitle => 'Choose your preferences';

  @override
  String get language => 'Language';

  @override
  String get defaultCurrency => 'Default currency';

  @override
  String get myBills => 'My Bills';

  @override
  String get addBill => 'Add bill';

  @override
  String get editBill => 'Edit bill';

  @override
  String get noBillsBody =>
      'No bills yet.\nTap the button below to add your first one.';

  @override
  String get deleteBillTitle => 'Delete bill?';

  @override
  String get deleteBillBody => 'This will also remove its payment history.';

  @override
  String dueOn(String date) {
    return 'Due $date';
  }

  @override
  String overdueSince(String date) {
    return 'Overdue since $date';
  }

  @override
  String get dueToday => 'Due today';

  @override
  String get dueTomorrow => 'Due tomorrow';

  @override
  String dueInDays(int count) {
    return 'Due in $count days';
  }

  @override
  String overdueByDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return 'Overdue by $_temp0';
  }

  @override
  String get toPayThisMonth => 'To pay this month';

  @override
  String get overdue => 'Overdue';

  @override
  String get paidThisMonth => 'Paid this month';

  @override
  String get upcomingNext30 => 'Upcoming (next 30 days)';

  @override
  String get nothingDue30 => 'Nothing due in the next 30 days.';

  @override
  String get noBillsTitle => 'No bills yet';

  @override
  String get noBillsDashBody =>
      'Add your first bill and we will remind you before it is due.';

  @override
  String get addFirstBill => 'Add your first bill';

  @override
  String get billName => 'Bill name';

  @override
  String get enterName => 'Enter a name';

  @override
  String get amount => 'Amount';

  @override
  String get currency => 'Currency';

  @override
  String get enterValidAmount => 'Enter a valid amount';

  @override
  String get category => 'Category';

  @override
  String get selectCategory => 'Select a category';

  @override
  String get dueDate => 'Due date';

  @override
  String get repeat => 'Repeat';

  @override
  String get oneTime => 'One-time';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get remindMe => 'Remind me';

  @override
  String get onTheDueDate => 'On the due date';

  @override
  String daysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days before',
      one: '1 day before',
    );
    return '$_temp0';
  }

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get markAsPaid => 'Mark as paid';

  @override
  String amountPaidLabel(String currency) {
    return 'Amount paid ($currency)';
  }

  @override
  String get billMarkedPaid => 'Bill marked as paid';

  @override
  String paidNextDue(String date) {
    return 'Paid. Next due $date';
  }

  @override
  String get reminder => 'Reminder';

  @override
  String get notes => 'Notes';

  @override
  String get paymentHistory => 'Payment history';

  @override
  String get noPaymentsTitle => 'No payments yet';

  @override
  String paidOnFor(String paidDate, String dueDate) {
    return 'Paid $paidDate • for $dueDate';
  }

  @override
  String get noPaymentsBody =>
      'Mark a bill as paid and your spending charts will appear here.';

  @override
  String get spendingByCategory => 'Spending by category';

  @override
  String noPaymentsInMonth(String currency, String month) {
    return 'No $currency payments in $month.';
  }

  @override
  String last6Months(String currency) {
    return 'Last 6 months ($currency)';
  }

  @override
  String get total => 'Total';

  @override
  String paymentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count payments',
      one: '1 payment',
    );
    return '$_temp0';
  }

  @override
  String get reminders => 'Reminders';

  @override
  String get reminderTime => 'Reminder time';

  @override
  String get reminderTimeHint => 'Time of day reminders are sent';

  @override
  String get notificationsOn => 'Notifications are on';

  @override
  String get notificationsOff => 'Notifications are off';

  @override
  String get notificationsOffHint =>
      'If the dialog does not appear, enable them in phone Settings > Apps > Smart Budget > Notifications.';

  @override
  String get allow => 'Allow';

  @override
  String get scheduledReminders => 'Scheduled reminders';

  @override
  String get testSection => 'Test';

  @override
  String get sendTestNow => 'Send test notification now';

  @override
  String get scheduleTest => 'Schedule a test (about 1 minute)';

  @override
  String get scheduledSnack =>
      'Scheduled. Close the app and wait about a minute.';

  @override
  String get batteryTip =>
      'Tip: some phones (Huawei, Xiaomi, Oppo, Vivo, Samsung) stop background apps to save battery, which can delay reminders. If reminders do not arrive, allow Smart Budget to run in the background in your battery settings.';

  @override
  String notifUpcomingTitle(String title) {
    return 'Upcoming bill: $title';
  }

  @override
  String notifUpcomingBody(String amount, int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$amount is due in $_temp0 ($date).';
  }

  @override
  String notifDueTodayTitle(String title) {
    return 'Bill due today: $title';
  }

  @override
  String notifDueTodayBody(String amount) {
    return '$amount is due today.';
  }

  @override
  String notifOverdueTitle(String title) {
    return 'Overdue: $title';
  }

  @override
  String notifOverdueBody(String amount, String date) {
    return '$amount was due on $date. Tap to mark it as paid.';
  }

  @override
  String get testNotifTitle => 'Test notification';

  @override
  String get testNotifBody => 'Notifications are working.';

  @override
  String get scheduledTestTitle => 'Scheduled test';

  @override
  String get scheduledTestBody => 'This reminder was scheduled one minute ago.';
}
