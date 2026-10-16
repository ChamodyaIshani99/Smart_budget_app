import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/l10n_ext.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/services/notification_service.dart';
import '../bills/providers/bill_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _pageCount = 3;
  final _controller = PageController();
  int _page = 0;
  String _currency = 'LKR';

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefOnboardingDone, true);
    await prefs.setString(AppConstants.prefDefaultCurrency, _currency);
    ref.invalidate(defaultCurrencyProvider);
    await NotificationService.instance.requestPermission();
    if (mounted) context.go('/home');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lastPage = _page == _pageCount - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _preferencesPage(),
                  _introPage(l10n.onboardingTitle1, l10n.onboardingBody1,
                      Icons.notifications_active),
                  _introPage(l10n.onboardingTitle2, l10n.onboardingBody2,
                      Icons.pie_chart),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pageCount,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.all(4),
                  width: _page == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _page == i
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    if (lastPage) {
                      _finish();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(lastPage ? l10n.getStarted : l10n.next),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _introPage(String title, String body, IconData icon) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 120, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 32),
            Text(title,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(body, textAlign: TextAlign.center),
          ],
        ),
      );

  Widget _preferencesPage() {
    final l10n = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(l10n.onboardingPrefsTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'en', label: Text('English')),
              ButtonSegment(value: 'si', label: Text('සිංහල')),
            ],
            selected: {lang},
            onSelectionChanged: (s) =>
                ref.read(localeProvider.notifier).setLanguage(s.first),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            initialValue: _currency,
            decoration: InputDecoration(labelText: l10n.defaultCurrency),
            items: AppConstants.currencies
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _currency = v!),
          ),
        ],
      ),
    );
  }
}