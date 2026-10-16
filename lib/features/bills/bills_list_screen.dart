import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/l10n_ext.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/bill.dart';
import 'providers/bill_providers.dart';

class BillsListScreen extends ConsumerWidget {
  const BillsListScreen({super.key});

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.deleteBillTitle),
        content: Text(context.l10n.deleteBillBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billsAsync = ref.watch(billsProvider);
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final catById = {for (final c in categories) c.id!: c};
    final today = dateOnly(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.myBills)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/bills/add'),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.addBill),
      ),
      body: billsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (bills) {
          if (bills.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(context.l10n.noBillsBody,
                    textAlign: TextAlign.center),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
            itemCount: bills.length,
            itemBuilder: (context, i) {
              final bill = bills[i];
              final cat = catById[bill.categoryId];
              final overdue = bill.dueDate.isBefore(today);
              return _BillTile(
                bill: bill,
                categoryName: cat?.nameFor(context.langCode) ?? '',
                icon: categoryIcon(cat?.icon ?? 'more'),
                color: Color(cat?.color ?? 0xFF757575),
                overdue: overdue,
                onTap: () => context.push('/bills/detail/${bill.id}'),
                confirmDelete: () => _confirmDelete(context),
                onDeleted: () =>
                    ref.read(billsProvider.notifier).deleteBill(bill.id!),
              );
            },
          );
        },
      ),
    );
  }
}

class _BillTile extends StatelessWidget {
  final Bill bill;
  final String categoryName;
  final IconData icon;
  final Color color;
  final bool overdue;
  final VoidCallback onTap;
  final Future<bool> Function() confirmDelete;
  final VoidCallback onDeleted;

  const _BillTile({
    required this.bill,
    required this.categoryName,
    required this.icon,
    required this.color,
    required this.overdue,
    required this.onTap,
    required this.confirmDelete,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(bill.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) => confirmDelete(),
      onDismissed: (_) => onDeleted(),
      child: Card(
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, color: color),
          ),
          title: Text(bill.title,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(
            '${overdue ? context.l10n.overdueSince(formatDate(bill.dueDate)) : context.l10n.dueOn(formatDate(bill.dueDate))}'
            ' • $categoryName',
            style: TextStyle(color: overdue ? Colors.red : null),
          ),
          trailing: Text(
            formatMoney(bill.amount, bill.currency),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}