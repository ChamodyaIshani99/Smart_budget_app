import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/helpers.dart';
import '../../core/utils/recurrence.dart';
import '../../data/models/bill.dart';
import 'providers/bill_providers.dart';

class BillDetailScreen extends ConsumerWidget {
  final int billId;
  const BillDetailScreen({super.key, required this.billId});

  String _recurrenceText(Recurrence r) => switch (r) {
        Recurrence.none => 'One-time',
        Recurrence.monthly => 'Monthly',
        Recurrence.yearly => 'Yearly',
      };

  Future<void> _markPaid(
      BuildContext context, WidgetRef ref, Bill bill) async {
    final controller = TextEditingController(text: bill.amount.toString());
    final amount = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mark as paid'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Amount paid (${bill.currency})',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final v =
                  double.tryParse(controller.text.replaceAll(',', '').trim());
              if (v == null || v <= 0) return;
              Navigator.pop(ctx, v);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (amount == null) return;

    await ref.read(billsProvider.notifier).markPaid(bill, amount);
    if (!context.mounted) return;

    final oneTime = bill.recurrence == Recurrence.none;
    final next = nextDueDate(bill.dueDate, bill.recurrence, bill.anchorDay);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          oneTime ? 'Bill marked as paid' : 'Paid. Next due ${formatDate(next)}'),
    ));
    if (oneTime) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bill = ref
        .watch(billsProvider)
        .value
        ?.where((b) => b.id == billId)
        .firstOrNull;
    final categories = ref.watch(categoriesProvider).value ?? const [];

    if (bill == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final cat = categories.where((c) => c.id == bill.categoryId).firstOrNull;
    final overdue = bill.dueDate.isBefore(dateOnly(DateTime.now()));
    final payments = ref.watch(paymentsForBillProvider(billId));

    return Scaffold(
      appBar: AppBar(
        title: Text(bill.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/bills/edit', extra: bill),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatMoney(bill.amount, bill.currency),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dueStatusText(bill.dueDate),
                    style: TextStyle(
                      color: overdue ? Colors.red : Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(height: 28),
                  _row(Icons.event, 'Due date', formatDate(bill.dueDate)),
                  _row(Icons.category, 'Category', cat?.nameEn ?? '-'),
                  _row(Icons.repeat, 'Repeat', _recurrenceText(bill.recurrence)),
                  _row(Icons.notifications, 'Reminder',
                      bill.reminderDays == 0
                          ? 'On the due date'
                          : '${bill.reminderDays} day(s) before'),
                  if (bill.notes != null) _row(Icons.notes, 'Notes', bill.notes!),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: () => _markPaid(context, ref, bill),
              icon: const Icon(Icons.check_circle),
              label: const Text('Mark as paid'),
            ),
          ),
          const SizedBox(height: 24),
          Text('Payment history',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          payments.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
            data: (list) {
              if (list.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('No payments yet.'),
                );
              }
              return Column(
                children: [
                  for (final p in list)
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.check_circle,
                            color: Colors.green),
                        title: Text(formatMoney(p.amountPaid, p.currency)),
                        subtitle: Text(
                          'Paid ${formatDate(p.paidDate)} '
                          '• for ${formatDate(p.dueDateCovered)}',
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: Colors.grey)),
            const Spacer(),
            Flexible(
              child: Text(value,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
}