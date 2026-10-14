import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/bill.dart';
import '../../../data/models/category.dart';
import '../../../data/repositories/bill_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/models/payment.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../core/services/notification_service.dart';

final billRepositoryProvider = Provider<BillRepository>((ref) => BillRepository());

final categoryRepositoryProvider =
    Provider<CategoryRepository>((ref) => CategoryRepository());

final categoriesProvider = FutureProvider<List<Category>>((ref) {
  return ref.read(categoryRepositoryProvider).getAll();
});

final defaultCurrencyProvider = FutureProvider<String>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(AppConstants.prefDefaultCurrency) ?? 'LKR';
});

final paymentRepositoryProvider =
    Provider<PaymentRepository>((ref) => PaymentRepository());

final paymentsForBillProvider =
    FutureProvider.family<List<Payment>, int>((ref, billId) {
  return ref.read(paymentRepositoryProvider).getForBill(billId);
});

final paidThisMonthProvider = FutureProvider<Map<String, double>>((ref) {
  ref.watch(billsProvider); // refresh whenever bills change (e.g. after paying)
  return ref.read(paymentRepositoryProvider).totalsForMonth(DateTime.now());
});

class BillsNotifier extends AsyncNotifier<List<Bill>> {
  BillRepository get _repo => ref.read(billRepositoryProvider);

  @override
  Future<List<Bill>> build() => _repo.getAll();

  Future<void> _reload() async {
    state = AsyncData(await _repo.getAll());
    await NotificationService.instance.rescheduleAll();
  }

  Future<void> addBill(Bill bill) async {
    await _repo.insert(bill);
    await _reload();
  }

  Future<void> updateBill(Bill bill) async {
    await _repo.update(bill);
    await _reload();
  }

  Future<void> deleteBill(int id) async {
    await _repo.delete(id);
    await _reload();
  }

    Future<void> markPaid(Bill bill, double amountPaid) async {
    await ref.read(paymentRepositoryProvider).markAsPaid(bill, amountPaid);
    ref.invalidate(paymentsForBillProvider(bill.id!));
    await _reload();
  }
}

final billsProvider =
    AsyncNotifierProvider<BillsNotifier, List<Bill>>(BillsNotifier.new);