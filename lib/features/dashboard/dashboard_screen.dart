import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/l10n_ext.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/helpers.dart';
import '../../core/widgets/ui_kit.dart';
import '../bills/providers/bill_providers.dart';
import '../bills/widgets/bill_card.dart';
import 'dashboard_data.dart';
import 'greeting_header.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final billsAsync = ref.watch(billsProvider);
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final paid =
        ref.watch(paidThisMonthProvider).value ?? const <String, double>{};
    final catById = {for (final c in categories) c.id!: c};

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0), 
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

          final d = DashboardData.from(bills, DateTime.now());

          Widget cardFor(int i, bill) => FadeSlideIn(
                index: i,
                child: BillCard(
                  bill: bill,
                  category: catById[bill.categoryId],
                  onTap: () => context.push('/bills/detail/${bill.id}'),
                ),
              );

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
            children: [
              FadeSlideIn(
                child: GreetingHeader(
                  overdueCount: d.overdue.length,
                  upcomingCount: d.upcoming.length,
                ),
              ),
              
              FadeSlideIn(
                child: _HeroCard(
                  toPay: d.toPayThisMonth,
                  overdue: d.overdueTotals,
                  paid: paid,
                ),
              ),
              if (d.overdue.isNotEmpty) ...[
                SectionTitle(l10n.overdue, d.overdue.length),
                for (var i = 0; i < d.overdue.length; i++)
                  cardFor(i, d.overdue[i]),
              ],
              SectionTitle(l10n.upcomingNext30, d.upcoming.length),
              if (d.upcoming.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(l10n.nothingDue30),
                )
              else
                for (var i = 0; i < d.upcoming.length; i++)
                  cardFor(i, d.upcoming[i]),
            ],
          );
        },
      ),
    );
  }
}

List<MapEntry<String, double>> _sorted(Map<String, double> m) =>
    m.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

class _HeroCard extends StatelessWidget {
  final Map<String, double> toPay;
  final Map<String, double> overdue;
  final Map<String, double> paid;

  const _HeroCard({
    required this.toPay,
    required this.overdue,
    required this.paid,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final entries = _sorted(toPay);

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient(context),
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppColors.heroShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            const Positioned(
                right: -40, top: -40, child: _Bubble(size: 150, alpha: 0.10)),
            const Positioned(
                right: 30, bottom: -60, child: _Bubble(size: 120, alpha: 0.07)),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.toPayThisMonth,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (entries.isEmpty)
                    const Text('-',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold))
                  else
                    for (var i = 0; i < entries.length; i++)
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          formatMoney(entries[i].value, entries[i].key),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: i == 0 ? 34 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _MiniStat(
                          icon: Icons.error_outline,
                          label: l10n.overdue,
                          totals: overdue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MiniStat(
                          icon: Icons.check_circle_outline,
                          label: l10n.paidThisMonth,
                          totals: paid,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final double size;
  final double alpha;
  const _Bubble({required this.size, required this.alpha});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final Map<String, double> totals;

  const _MiniStat({
    required this.icon,
    required this.label,
    required this.totals,
  });

  @override
  Widget build(BuildContext context) {
    final entries = _sorted(totals);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.85)),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (entries.isEmpty)
            const Text('-',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold))
          else
            for (final e in entries)
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  formatMoney(e.value, e.key),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}