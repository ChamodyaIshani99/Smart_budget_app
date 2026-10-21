import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/l10n_ext.dart';
import '../../core/theme/theme_provider.dart';
import '../../l10n/app_localizations.dart';

class GreetingHeader extends ConsumerWidget {
  final int overdueCount;
  final int upcomingCount;

  const GreetingHeader({
    super.key,
    required this.overdueCount,
    required this.upcomingCount,
  });

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return l10n.greetingMorning;
    if (hour >= 12 && hour < 17) return l10n.greetingAfternoon;
    return l10n.greetingEvening;
  }

  String _subtitle(AppLocalizations l10n) {
    if (overdueCount > 0) return l10n.greetingOverdue(overdueCount);
    if (upcomingCount > 0) return l10n.greetingUpcoming(upcomingCount);
    return l10n.greetingAllClear;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting(l10n),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  _subtitle(l10n),
                  style: TextStyle(
                    color: overdueCount > 0
                        ? scheme.error
                        : scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: () => ref
                .read(themeModeProvider.notifier)
                .set(isDark ? ThemeMode.light : ThemeMode.dark),
            icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          ),
        ],
      ),
    );
  }
}