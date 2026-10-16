import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/l10n_ext.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/bill.dart';
import '../../data/models/category.dart';
import '../bills/providers/bill_providers.dart';
import 'dashboard_data.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billsAsync = ref.watch(billsProvider);
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final paid =
        ref.watch(paidThisMonthProvider).value ?? const <String, double>{};
    final catById = {for (final c in categories) c.id!: c};
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.appName)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/bills/add'),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.addBill),
      ),
      body: billsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (bills) {
          if (bills.isEmpty) return const _EmptyState();

          final d = DashboardData.from(bills, DateTime.now());

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              _SummaryCard(
                title: context.l10n.toPayThisMonth,
                totals: d.toPayThisMonth,
                background: scheme.primaryContainer,
                foreground: scheme.onPrimaryContainer,
                big: true,
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: context.l10n.overdue,
                      totals: d.overdueTotals,
                      background: d.overdue.isEmpty
                          ? scheme.surfaceContainerHighest
                          : scheme.errorContainer,
                      foreground: d.overdue.isEmpty
                          ? scheme.onSurface
                          : scheme.onErrorContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      title: context.l10n.paidThisMonth,
                      totals: paid,
                      background: scheme.tertiaryContainer,
                      foreground: scheme.onTertiaryContainer,
                    ),
                  ),
                ],
              ),
              if (d.overdue.isNotEmpty) ...[
                _SectionHeader(context.l10n.overdue, d.overdue.length),
                for (final b in d.overdue)
                  _DueTile(
                      bill: b, category: catById[b.categoryId], overdue: true),
              ],
              _SectionHeader(context.l10n.upcomingNext30, d.upcoming.length),
              if (d.upcoming.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(context.l10n.nothingDue30),
                )
              else
                for (final b in d.upcoming)
                  _DueTile(
                      bill: b, category: catById[b.categoryId], overdue: false),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long,
                size: 96, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(context.l10n.noBillsTitle,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              context.l10n.noBillsDashBody,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.push('/bills/add'),
              icon: const Icon(Icons.add),
              label: Text(context.l10n.addFirstBill),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final Map<String, double> totals;
  final Color background;
  final Color foreground;
  final bool big;

  const _SummaryCard({
    required this.title,
    required this.totals,
    required this.background,
    required this.foreground,
    this.big = false,
  });

  @override
  Widget build(BuildContext context) {
    final entries = totals.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final amountStyle = (big
            ? Theme.of(context).textTheme.headlineSmall
            : Theme.of(context).textTheme.titleMedium)
        ?.copyWith(fontWeight: FontWeight.bold, color: foreground);

    return Card(
      color: background,
      elevation: 0,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: foreground)),
              const SizedBox(height: 8),
              if (entries.isEmpty)
                Text('-', style: amountStyle)
              else
                for (final e in entries)
                  Text(formatMoney(e.value, e.key), style: amountStyle),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  const _SectionHeader(this.title, this.count);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 8),
      child: Row(
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(width: 8),
          Text('($count)', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _DueTile extends StatelessWidget {
  final Bill bill;
  final Category? category;
  final bool overdue;

  const _DueTile({
    required this.bill,
    required this.category,
    required this.overdue,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(category?.color ?? 0xFF757575);
    return Card(
      child: ListTile(
        onTap: () => context.push('/bills/detail/${bill.id}'),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(categoryIcon(category?.icon ?? 'more'), color: color),
        ),
        title: Text(bill.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${dueStatusText(context.l10n, bill.dueDate)} • ${formatDate(bill.dueDate)}',
          style: TextStyle(color: overdue ? Colors.red : null),
        ),
        trailing: Text(
          formatMoney(bill.amount, bill.currency),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}