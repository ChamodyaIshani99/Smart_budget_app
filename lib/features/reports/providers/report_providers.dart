import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/report_repository.dart';
import '../../bills/providers/bill_providers.dart';

final reportRepositoryProvider =
    Provider<ReportRepository>((ref) => ReportRepository());

/// The month shown on the Reports tab (always the 1st of the month).
class SelectedMonthNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final n = DateTime.now();
    return DateTime(n.year, n.month);
  }

  void set(DateTime month) => state = DateTime(month.year, month.month);
}

final selectedMonthProvider =
    NotifierProvider<SelectedMonthNotifier, DateTime>(SelectedMonthNotifier.new);

/// null means "pick automatically" (default currency, else the first one).
class SelectedCurrencyNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String currency) => state = currency;
}

final selectedCurrencyProvider =
    NotifierProvider<SelectedCurrencyNotifier, String?>(
        SelectedCurrencyNotifier.new);

typedef MonthCurrency = ({DateTime month, String currency});

// These watch billsProvider so reports refresh after payments change.

final paymentCurrenciesProvider = FutureProvider<List<String>>((ref) {
  ref.watch(billsProvider);
  return ref.read(reportRepositoryProvider).currencies();
});

final categoryTotalsProvider =
    FutureProvider.family<List<CategoryTotal>, MonthCurrency>((ref, a) {
  ref.watch(billsProvider);
  return ref.read(reportRepositoryProvider).categoryTotals(a.month, a.currency);
});

final monthlyTotalsProvider =
    FutureProvider.family<List<MonthTotal>, MonthCurrency>((ref, a) {
  ref.watch(billsProvider);
  return ref.read(reportRepositoryProvider).monthlyTotals(a.month, a.currency);
});