import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/l10n_ext.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/ui_kit.dart';
import 'providers/bill_providers.dart';
import 'widgets/bill_card.dart';

class BillsListScreen extends ConsumerWidget {
  const BillsListScreen({super.key});

  Future<bool> _confirmDelete(BuildContext context) async {
    final l10n = context.l10n;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteBillTitle),
        content: Text(l10n.deleteBillBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final billsAsync = ref.watch(billsProvider);
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final catById = {for (final c in categories) c.id!: c};

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myBills)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/bills/add'),
        icon: const Icon(Icons.add),
        label: Text(l10n.addBill),
      ),
      body: billsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (bills) {
          if (bills.isEmpty) {
            return EmptyState(
              icon: Icons.receipt_long,
              title: l10n.noBillsTitle,
              body: l10n.noBillsDashBody,
              buttonLabel: l10n.addFirstBill,
              onPressed: () => context.push('/bills/add'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
            itemCount: bills.length,
            itemBuilder: (context, i) {
              final bill = bills[i];
              return FadeSlideIn(
                index: i,
                child: Dismissible(
                  key: ValueKey(bill.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    child: const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                  confirmDismiss: (_) => _confirmDelete(context),
                  onDismissed: (_) =>
                      ref.read(billsProvider.notifier).deleteBill(bill.id!),
                  child: BillCard(
                    bill: bill,
                    category: catById[bill.categoryId],
                    onTap: () => context.push('/bills/detail/${bill.id}'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}