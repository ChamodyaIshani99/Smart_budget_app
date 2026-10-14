import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/utils/helpers.dart';
import '../../data/repositories/report_repository.dart';
import '../bills/providers/bill_providers.dart';
import 'providers/report_providers.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenciesAsync = ref.watch(paymentCurrenciesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: currenciesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (currencies) {
          if (currencies.isEmpty) return const _EmptyReports();
          return _ReportBody(currencies: currencies);
        },
      ),
    );
  }
}

class _EmptyReports extends StatelessWidget {
  const _EmptyReports();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pie_chart_outline,
                size: 96, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text('No payments yet',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              'Mark a bill as paid and your spending charts will appear here.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportBody extends ConsumerWidget {
  final List<String> currencies;
  const _ReportBody({required this.currencies});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedMonthProvider);
    final selected = ref.watch(selectedCurrencyProvider);
    final defaultCurrency = ref.watch(defaultCurrencyProvider).value;

    final currency = currencies.contains(selected)
        ? selected!
        : (currencies.contains(defaultCurrency)
            ? defaultCurrency!
            : currencies.first);

    final args = (month: month, currency: currency);
    final cats = ref.watch(categoryTotalsProvider(args));
    final months = ref.watch(monthlyTotalsProvider(args));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        const _MonthSelector(),
        if (currencies.length > 1) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              for (final c in currencies)
                ChoiceChip(
                  label: Text(c),
                  selected: c == currency,
                  onSelected: (_) =>
                      ref.read(selectedCurrencyProvider.notifier).select(c),
                ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        Text('Spending by category',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: cats.when(
              loading: () => const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('Error: $e'),
              data: (items) {
                if (items.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'No $currency payments in '
                        '${DateFormat.yMMMM().format(month)}.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return _CategorySection(items: items, currency: currency);
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Last 6 months ($currency)',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 24, 16, 12),
            child: months.when(
              loading: () => const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('Error: $e'),
              data: (items) => _MonthlyBars(items: items, selected: month),
            ),
          ),
        ),
      ],
    );
  }
}

class _MonthSelector extends ConsumerWidget {
  const _MonthSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedMonthProvider);
    final now = DateTime.now();
    final isCurrent = month.year == now.year && month.month == now.month;
    final notifier = ref.read(selectedMonthProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => notifier.set(DateTime(month.year, month.month - 1)),
        ),
        SizedBox(
          width: 170,
          child: Text(
            DateFormat.yMMMM().format(month),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: isCurrent
              ? null
              : () => notifier.set(DateTime(month.year, month.month + 1)),
        ),
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  final List<CategoryTotal> items;
  final String currency;
  const _CategorySection({required this.items, required this.currency});

  @override
  Widget build(BuildContext context) {
    final total = items.fold<double>(0, (sum, e) => sum + e.total);

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 62,
                  sections: [
                    for (final i in items)
                      PieChartSectionData(
                        value: i.total,
                        color: Color(i.category.color),
                        radius: 38,
                        showTitle: false,
                      ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Total',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(
                    width: 100,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        formatMoney(total, currency),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        for (final i in items)
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: CircleAvatar(
              radius: 18,
              backgroundColor: Color(i.category.color).withValues(alpha: 0.15),
              child: Icon(categoryIcon(i.category.icon),
                  size: 18, color: Color(i.category.color)),
            ),
            title: Text(i.category.nameEn),
            subtitle: Text(
              '${i.count} payment${i.count == 1 ? '' : 's'} • '
              '${(i.total / total * 100).toStringAsFixed(0)}%',
            ),
            trailing: Text(
              formatMoney(i.total, currency),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}

class _MonthlyBars extends StatelessWidget {
  final List<MonthTotal> items;
  final DateTime selected;
  const _MonthlyBars({required this.items, required this.selected});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxValue =
        items.fold<double>(0, (m, e) => e.total > m ? e.total : m);

    bool isSelected(DateTime m) =>
        m.year == selected.year && m.month == selected.month;

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          maxY: maxValue == 0 ? 1 : maxValue * 1.2,
          alignment: BarChartAlignment.spaceAround,
          gridData: FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (value, meta) {
                  if (value == meta.max) return const SizedBox.shrink();
                  return Text(
                    NumberFormat.compact().format(value),
                    style: const TextStyle(fontSize: 11),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= items.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      DateFormat.MMM().format(items[i].month),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected(items[i].month)
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < items.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: items[i].total,
                    width: 22,
                    color: isSelected(items[i].month)
                        ? scheme.primary
                        : scheme.primary.withValues(alpha: 0.35),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(6)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}