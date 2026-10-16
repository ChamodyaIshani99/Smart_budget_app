import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/l10n_ext.dart';
import '../../core/utils/helpers.dart';
import '../../core/utils/recurrence.dart';
import '../../data/models/bill.dart';
import '../../l10n/app_localizations.dart';
import 'providers/bill_providers.dart';

class BillDetailScreen extends ConsumerWidget {
  final int billId;
  const BillDetailScreen({super.key, required this.billId});

  String _recurrenceText(AppLocalizations l10n, Recurrence r) => switch (r) {
        Recurrence.none => l10n.oneTime,
        Recurrence.monthly => l10n.monthly,
        Recurrence.yearly => l10n.yearly,
      };

  Future<void> _markPaid(
      BuildContext context, WidgetRef ref, Bill bill) async {
    final controller = TextEditingController(text: bill.amount.toString());
    final amount = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.markAsPaid),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: context.l10n.amountPaidLabel(bill.currency),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final v =
                  double.tryParse(controller.text.replaceAll(',', '').trim());
              if (v == null || v <= 0) return;
              Navigator.pop(ctx, v);
            },
            child: Text(context.l10n.confirm),
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
      content: Text(oneTime
          ? context.l10n.billMarkedPaid
          : context.l10n.paidNextDue(formatDate(next))),
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
                    dueStatusText(context.l10n, bill.dueDate),
                    style: TextStyle(
                      color: overdue ? Colors.red : Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(height: 28),
                  _row(Icons.event, context.l10n.dueDate,
                      formatDate(bill.dueDate)),
                  _row(Icons.category, context.l10n.category,
                      cat?.nameFor(context.langCode) ?? '-'),
                  _row(Icons.repeat, context.l10n.repeat,
                      _recurrenceText(context.l10n, bill.recurrence)),
                  _row(Icons.notifications, context.l10n.reminder,
                      bill.reminderDays == 0
                          ? context.l10n.onTheDueDate
                          : context.l10n.daysBefore(bill.reminderDays)),
                  if (bill.notes != null)
                    _row(Icons.notes, context.l10n.notes, bill.notes!),
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
              label: Text(context.l10n.markAsPaid),
            ),
          ),
          const SizedBox(height: 24),
          Text(context.l10n.paymentHistory,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          payments.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
            data: (list) {
              if (list.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(context.l10n.noPaymentsTitle),
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
                        subtitle: Text(context.l10n.paidOnFor(
                          formatDate(p.paidDate),
                          formatDate(p.dueDateCovered),
                        )),
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