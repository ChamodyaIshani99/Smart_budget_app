import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('si'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Smart Budget'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get navBills;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Never miss a bill'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'Get reminders before every due date.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Track your spending'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'See where your money goes each month.'**
  String get onboardingBody2;

  /// No description provided for @onboardingPrefsTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferences'**
  String get onboardingPrefsTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @defaultCurrency.
  ///
  /// In en, this message translates to:
  /// **'Default currency'**
  String get defaultCurrency;

  /// No description provided for @myBills.
  ///
  /// In en, this message translates to:
  /// **'My Bills'**
  String get myBills;

  /// No description provided for @addBill.
  ///
  /// In en, this message translates to:
  /// **'Add bill'**
  String get addBill;

  /// No description provided for @editBill.
  ///
  /// In en, this message translates to:
  /// **'Edit bill'**
  String get editBill;

  /// No description provided for @noBillsBody.
  ///
  /// In en, this message translates to:
  /// **'No bills yet.\nTap the button below to add your first one.'**
  String get noBillsBody;

  /// No description provided for @deleteBillTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete bill?'**
  String get deleteBillTitle;

  /// No description provided for @deleteBillBody.
  ///
  /// In en, this message translates to:
  /// **'This will also remove its payment history.'**
  String get deleteBillBody;

  /// No description provided for @dueOn.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String dueOn(String date);

  /// No description provided for @overdueSince.
  ///
  /// In en, this message translates to:
  /// **'Overdue since {date}'**
  String overdueSince(String date);

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get dueToday;

  /// No description provided for @dueTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Due tomorrow'**
  String get dueTomorrow;

  /// No description provided for @dueInDays.
  ///
  /// In en, this message translates to:
  /// **'Due in {count} days'**
  String dueInDays(int count);

  /// No description provided for @overdueByDays.
  ///
  /// In en, this message translates to:
  /// **'Overdue by {count, plural, =1{1 day} other{{count} days}}'**
  String overdueByDays(int count);

  /// No description provided for @toPayThisMonth.
  ///
  /// In en, this message translates to:
  /// **'To pay this month'**
  String get toPayThisMonth;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @paidThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Paid this month'**
  String get paidThisMonth;

  /// No description provided for @upcomingNext30.
  ///
  /// In en, this message translates to:
  /// **'Upcoming (next 30 days)'**
  String get upcomingNext30;

  /// No description provided for @nothingDue30.
  ///
  /// In en, this message translates to:
  /// **'Nothing due in the next 30 days.'**
  String get nothingDue30;

  /// No description provided for @noBillsTitle.
  ///
  /// In en, this message translates to:
  /// **'No bills yet'**
  String get noBillsTitle;

  /// No description provided for @noBillsDashBody.
  ///
  /// In en, this message translates to:
  /// **'Add your first bill and we will remind you before it is due.'**
  String get noBillsDashBody;

  /// No description provided for @addFirstBill.
  ///
  /// In en, this message translates to:
  /// **'Add your first bill'**
  String get addFirstBill;

  /// No description provided for @billName.
  ///
  /// In en, this message translates to:
  /// **'Bill name'**
  String get billName;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get enterName;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterValidAmount;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get selectCategory;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get dueDate;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @oneTime.
  ///
  /// In en, this message translates to:
  /// **'One-time'**
  String get oneTime;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @remindMe.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get remindMe;

  /// No description provided for @onTheDueDate.
  ///
  /// In en, this message translates to:
  /// **'On the due date'**
  String get onTheDueDate;

  /// No description provided for @daysBefore.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day before} other{{count} days before}}'**
  String daysBefore(int count);

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @markAsPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as paid'**
  String get markAsPaid;

  /// No description provided for @amountPaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount paid ({currency})'**
  String amountPaidLabel(String currency);

  /// No description provided for @billMarkedPaid.
  ///
  /// In en, this message translates to:
  /// **'Bill marked as paid'**
  String get billMarkedPaid;

  /// No description provided for @paidNextDue.
  ///
  /// In en, this message translates to:
  /// **'Paid. Next due {date}'**
  String paidNextDue(String date);

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment history'**
  String get paymentHistory;

  /// No description provided for @noPaymentsTitle.
  ///
  /// In en, this message translates to:
  /// **'No payments yet'**
  String get noPaymentsTitle;

  /// No description provided for @paidOnFor.
  ///
  /// In en, this message translates to:
  /// **'Paid {paidDate} • for {dueDate}'**
  String paidOnFor(String paidDate, String dueDate);

  /// No description provided for @noPaymentsBody.
  ///
  /// In en, this message translates to:
  /// **'Mark a bill as paid and your spending charts will appear here.'**
  String get noPaymentsBody;

  /// No description provided for @spendingByCategory.
  ///
  /// In en, this message translates to:
  /// **'Spending by category'**
  String get spendingByCategory;

  /// No description provided for @noPaymentsInMonth.
  ///
  /// In en, this message translates to:
  /// **'No {currency} payments in {month}.'**
  String noPaymentsInMonth(String currency, String month);

  /// No description provided for @last6Months.
  ///
  /// In en, this message translates to:
  /// **'Last 6 months ({currency})'**
  String last6Months(String currency);

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @paymentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 payment} other{{count} payments}}'**
  String paymentsCount(int count);

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get reminderTime;

  /// No description provided for @reminderTimeHint.
  ///
  /// In en, this message translates to:
  /// **'Time of day reminders are sent'**
  String get reminderTimeHint;

  /// No description provided for @notificationsOn.
  ///
  /// In en, this message translates to:
  /// **'Notifications are on'**
  String get notificationsOn;

  /// No description provided for @notificationsOff.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off'**
  String get notificationsOff;

  /// No description provided for @notificationsOffHint.
  ///
  /// In en, this message translates to:
  /// **'If the dialog does not appear, enable them in phone Settings > Apps > Smart Budget > Notifications.'**
  String get notificationsOffHint;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @scheduledReminders.
  ///
  /// In en, this message translates to:
  /// **'Scheduled reminders'**
  String get scheduledReminders;

  /// No description provided for @testSection.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get testSection;

  /// No description provided for @sendTestNow.
  ///
  /// In en, this message translates to:
  /// **'Send test notification now'**
  String get sendTestNow;

  /// No description provided for @scheduleTest.
  ///
  /// In en, this message translates to:
  /// **'Schedule a test (about 1 minute)'**
  String get scheduleTest;

  /// No description provided for @scheduledSnack.
  ///
  /// In en, this message translates to:
  /// **'Scheduled. Close the app and wait about a minute.'**
  String get scheduledSnack;

  /// No description provided for @batteryTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: some phones (Huawei, Xiaomi, Oppo, Vivo, Samsung) stop background apps to save battery, which can delay reminders. If reminders do not arrive, allow Smart Budget to run in the background in your battery settings.'**
  String get batteryTip;

  /// No description provided for @notifUpcomingTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming bill: {title}'**
  String notifUpcomingTitle(String title);

  /// No description provided for @notifUpcomingBody.
  ///
  /// In en, this message translates to:
  /// **'{amount} is due in {count, plural, =1{1 day} other{{count} days}} ({date}).'**
  String notifUpcomingBody(String amount, int count, String date);

  /// No description provided for @notifDueTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Bill due today: {title}'**
  String notifDueTodayTitle(String title);

  /// No description provided for @notifDueTodayBody.
  ///
  /// In en, this message translates to:
  /// **'{amount} is due today.'**
  String notifDueTodayBody(String amount);

  /// No description provided for @notifOverdueTitle.
  ///
  /// In en, this message translates to:
  /// **'Overdue: {title}'**
  String notifOverdueTitle(String title);

  /// No description provided for @notifOverdueBody.
  ///
  /// In en, this message translates to:
  /// **'{amount} was due on {date}. Tap to mark it as paid.'**
  String notifOverdueBody(String amount, String date);

  /// No description provided for @testNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Test notification'**
  String get testNotifTitle;

  /// No description provided for @testNotifBody.
  ///
  /// In en, this message translates to:
  /// **'Notifications are working.'**
  String get testNotifBody;

  /// No description provided for @scheduledTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Scheduled test'**
  String get scheduledTestTitle;

  /// No description provided for @scheduledTestBody.
  ///
  /// In en, this message translates to:
  /// **'This reminder was scheduled one minute ago.'**
  String get scheduledTestBody;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @greetingOverdue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 bill needs your attention} other{{count} bills need your attention}}'**
  String greetingOverdue(int count);

  /// No description provided for @greetingUpcoming.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 bill due in the next 30 days} other{{count} bills due in the next 30 days}}'**
  String greetingUpcoming(int count);

  /// No description provided for @greetingAllClear.
  ///
  /// In en, this message translates to:
  /// **'You are all caught up'**
  String get greetingAllClear;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'si'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
