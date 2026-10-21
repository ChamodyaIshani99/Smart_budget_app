// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class AppLocalizationsSi extends AppLocalizations {
  AppLocalizationsSi([String locale = 'si']) : super(locale);

  @override
  String get appName => 'Smart Budget';

  @override
  String get navHome => 'මුල් පිටුව';

  @override
  String get navBills => 'බිල්පත්';

  @override
  String get navReports => 'වාර්තා';

  @override
  String get navSettings => 'සැකසුම්';

  @override
  String get cancel => 'අවලංගු කරන්න';

  @override
  String get delete => 'මකන්න';

  @override
  String get confirm => 'තහවුරු කරන්න';

  @override
  String get next => 'ඊළඟ';

  @override
  String get getStarted => 'ආරම්භ කරන්න';

  @override
  String get onboardingTitle1 => 'බිල්පතක් කිසිදා අමතක නොකරන්න';

  @override
  String get onboardingBody1 => 'සෑම නියමිත දිනයකටම පෙර මතක් කිරීම් ලබා ගන්න.';

  @override
  String get onboardingTitle2 => 'ඔබේ වියදම් නිරීක්ෂණය කරන්න';

  @override
  String get onboardingBody2 =>
      'සෑම මාසයකම ඔබේ මුදල් වැය වන්නේ කුමක් සඳහාදැයි බලන්න.';

  @override
  String get onboardingPrefsTitle => 'ඔබේ මනාප තෝරන්න';

  @override
  String get language => 'භාෂාව';

  @override
  String get defaultCurrency => 'පෙරනිමි මුදල් වර්ගය';

  @override
  String get myBills => 'මගේ බිල්පත්';

  @override
  String get addBill => 'බිල්පතක් එක් කරන්න';

  @override
  String get editBill => 'බිල්පත සංස්කරණය කරන්න';

  @override
  String get noBillsBody =>
      'තවම බිල්පත් නැත.\nඔබේ පළමු බිල්පත එක් කිරීමට පහත බොත්තම ඔබන්න.';

  @override
  String get deleteBillTitle => 'බිල්පත මකන්නද?';

  @override
  String get deleteBillBody => 'මෙය එහි ගෙවීම් ඉතිහාසයද ඉවත් කරයි.';

  @override
  String dueOn(String date) {
    return 'නියමිත දිනය $date';
  }

  @override
  String overdueSince(String date) {
    return '$date සිට කල් ඉකුත්ව ඇත';
  }

  @override
  String get dueToday => 'අද ගෙවිය යුතුයි';

  @override
  String get dueTomorrow => 'හෙට ගෙවිය යුතුයි';

  @override
  String dueInDays(int count) {
    return 'දින $countකින් ගෙවිය යුතුයි';
  }

  @override
  String overdueByDays(int count) {
    return 'දින $countක් කල් ඉකුත්ව ඇත';
  }

  @override
  String get toPayThisMonth => 'මෙම මාසයේ ගෙවිය යුතු';

  @override
  String get overdue => 'කල් ඉකුත් වූ';

  @override
  String get paidThisMonth => 'මෙම මාසයේ ගෙවූ';

  @override
  String get upcomingNext30 => 'ඉදිරි බිල්පත් (දින 30ක් තුළ)';

  @override
  String get nothingDue30 => 'ඉදිරි දින 30 තුළ ගෙවීමට කිසිවක් නැත.';

  @override
  String get noBillsTitle => 'තවම බිල්පත් නැත';

  @override
  String get noBillsDashBody =>
      'ඔබේ පළමු බිල්පත එක් කරන්න, නියමිත දිනට පෙර අපි ඔබට මතක් කරන්නෙමු.';

  @override
  String get addFirstBill => 'ඔබේ පළමු බිල්පත එක් කරන්න';

  @override
  String get billName => 'බිල්පතේ නම';

  @override
  String get enterName => 'නමක් ඇතුළත් කරන්න';

  @override
  String get amount => 'මුදල';

  @override
  String get currency => 'මුදල් වර්ගය';

  @override
  String get enterValidAmount => 'වලංගු මුදලක් ඇතුළත් කරන්න';

  @override
  String get category => 'ප්‍රවර්ගය';

  @override
  String get selectCategory => 'ප්‍රවර්ගයක් තෝරන්න';

  @override
  String get dueDate => 'නියමිත දිනය';

  @override
  String get repeat => 'නැවත සිදුවීම';

  @override
  String get oneTime => 'එක් වරක්';

  @override
  String get monthly => 'මාසික';

  @override
  String get yearly => 'වාර්ෂික';

  @override
  String get remindMe => 'මට මතක් කරන්න';

  @override
  String get onTheDueDate => 'නියමිත දිනයේදී';

  @override
  String daysBefore(int count) {
    return 'දින $countකට පෙර';
  }

  @override
  String get notesOptional => 'සටහන් (අවශ්‍ය නම්)';

  @override
  String get saveChanges => 'වෙනස්කම් සුරකින්න';

  @override
  String get markAsPaid => 'ගෙවූ බව සලකුණු කරන්න';

  @override
  String amountPaidLabel(String currency) {
    return 'ගෙවූ මුදල ($currency)';
  }

  @override
  String get billMarkedPaid => 'බිල්පත ගෙවූ බව සලකුණු කළා';

  @override
  String paidNextDue(String date) {
    return 'ගෙවා ඇත. ඊළඟ නියමිත දිනය $date';
  }

  @override
  String get reminder => 'මතක් කිරීම';

  @override
  String get notes => 'සටහන්';

  @override
  String get paymentHistory => 'ගෙවීම් ඉතිහාසය';

  @override
  String get noPaymentsTitle => 'තවම ගෙවීම් නැත';

  @override
  String paidOnFor(String paidDate, String dueDate) {
    return '$paidDate ගෙවන ලදී • $dueDate සඳහා';
  }

  @override
  String get noPaymentsBody =>
      'බිල්පතක් ගෙවූ බව සලකුණු කළ විට ඔබේ වියදම් ප්‍රස්ථාර මෙහි දිස්වේ.';

  @override
  String get spendingByCategory => 'ප්‍රවර්ග අනුව වියදම';

  @override
  String noPaymentsInMonth(String currency, String month) {
    return '$month සඳහා $currency ගෙවීම් නැත.';
  }

  @override
  String last6Months(String currency) {
    return 'පසුගිය මාස 6 ($currency)';
  }

  @override
  String get total => 'එකතුව';

  @override
  String paymentsCount(int count) {
    return 'ගෙවීම් $count';
  }

  @override
  String get reminders => 'මතක් කිරීම්';

  @override
  String get reminderTime => 'මතක් කිරීමේ වේලාව';

  @override
  String get reminderTimeHint => 'මතක් කිරීම් යවන දිනයේ වේලාව';

  @override
  String get notificationsOn => 'දැනුම්දීම් සක්‍රියයි';

  @override
  String get notificationsOff => 'දැනුම්දීම් අක්‍රියයි';

  @override
  String get notificationsOffHint =>
      'සංවාද කොටුව නොපෙනේ නම්, දුරකථනයේ සැකසුම් > යෙදුම් > Smart Budget > දැනුම්දීම් තුළ ඒවා සක්‍රිය කරන්න.';

  @override
  String get allow => 'ඉඩ දෙන්න';

  @override
  String get scheduledReminders => 'උපලේඛනගත මතක් කිරීම්';

  @override
  String get testSection => 'පරීක්ෂණය';

  @override
  String get sendTestNow => 'දැන් පරීක්ෂණ දැනුම්දීමක් යවන්න';

  @override
  String get scheduleTest => 'පරීක්ෂණයක් උපලේඛනගත කරන්න (මිනිත්තුවක් පමණ)';

  @override
  String get scheduledSnack =>
      'උපලේඛනගත කළා. යෙදුම වසා මිනිත්තුවක් පමණ රැඳී සිටින්න.';

  @override
  String get batteryTip =>
      'උපදෙස: සමහර දුරකථන (Huawei, Xiaomi, Oppo, Vivo, Samsung) බැටරිය ඉතිරි කිරීමට පසුබිම් යෙදුම් නවත්වයි. එවිට මතක් කිරීම් ප්‍රමාද විය හැක. මතක් කිරීම් නොලැබේ නම්, බැටරි සැකසුම් තුළ Smart Budget පසුබිමේ ක්‍රියාත්මක වීමට ඉඩ දෙන්න.';

  @override
  String notifUpcomingTitle(String title) {
    return 'ඉදිරි බිල්පත: $title';
  }

  @override
  String notifUpcomingBody(String amount, int count, String date) {
    return 'ගෙවිය යුතු මුදල $amount. නියමිත දිනය $date (දින $countකින්).';
  }

  @override
  String notifDueTodayTitle(String title) {
    return 'අද ගෙවිය යුතු බිල්පත: $title';
  }

  @override
  String notifDueTodayBody(String amount) {
    return 'අද ගෙවිය යුතු මුදල $amount.';
  }

  @override
  String notifOverdueTitle(String title) {
    return 'කල් ඉකුත් වූ බිල්පත: $title';
  }

  @override
  String notifOverdueBody(String amount, String date) {
    return 'ගෙවිය යුතුව තිබූ මුදල $amount ($date). ගෙවූ බව සලකුණු කිරීමට ස්පර්ශ කරන්න.';
  }

  @override
  String get testNotifTitle => 'පරීක්ෂණ දැනුම්දීම';

  @override
  String get testNotifBody => 'දැනුම්දීම් නිවැරදිව ක්‍රියා කරයි.';

  @override
  String get scheduledTestTitle => 'උපලේඛනගත පරීක්ෂණය';

  @override
  String get scheduledTestBody =>
      'මෙම මතක් කිරීම මිනිත්තුවකට පෙර උපලේඛනගත කරන ලදී.';

  @override
  String get greetingMorning => 'සුභ උදෑසනක්';

  @override
  String get greetingAfternoon => 'සුභ දහවලක්';

  @override
  String get greetingEvening => 'සුභ සන්ධ්‍යාවක්';

  @override
  String greetingOverdue(int count) {
    return 'ඔබේ අවධානය අවශ්‍ය බිල්පත් $countක්';
  }

  @override
  String greetingUpcoming(int count) {
    return 'ඉදිරි දින 30 තුළ ගෙවිය යුතු බිල්පත් $countක්';
  }

  @override
  String get greetingAllClear => 'සියල්ල යාවත්කාලීනයි';

  @override
  String get appearance => 'පෙනුම';

  @override
  String get themeSystem => 'පද්ධතිය';

  @override
  String get themeLight => 'ආලෝක';

  @override
  String get themeDark => 'අඳුරු';
}
