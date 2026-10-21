import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/l10n_ext.dart';
import '../../core/services/notification_service.dart';
import '../../core/theme/app_colors.dart';
import '../../data/database/database_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _intro;
  late final AnimationController _pulse;
  late final Animation<double> _bg;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _titleFade;
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _titleSlide;

  @override
  void initState() {
    super.initState();

    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    );
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    CurvedAnimation interval(double a, double b, Curve curve) =>
        CurvedAnimation(parent: _intro, curve: Interval(a, b, curve: curve));

    _bg = interval(0.0, 0.35, Curves.easeOut);
    _logoFade = interval(0.10, 0.35, Curves.easeIn);
    _logoScale = Tween<double>(begin: 0.4, end: 1.0)
        .animate(interval(0.10, 0.65, Curves.elasticOut));
    _titleFade = interval(0.50, 0.80, Curves.easeOut);
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(_titleFade);
    _taglineFade = interval(0.70, 1.0, Curves.easeOut);

    _intro.forward();
    _pulse.repeat();
    _init();
  }

  Future<void> _init() async {
    final prefsFuture = SharedPreferences.getInstance();
    // Open the database while the animation plays (minimum 2.4 seconds).
    await Future.wait([
      DatabaseHelper.instance.database,
      Future.delayed(const Duration(milliseconds: 2400)),
    ]);
    unawaited(NotificationService.instance.rescheduleAll());

    final prefs = await prefsFuture;
    final done = prefs.getBool(AppConstants.prefOnboardingDone) ?? false;
    if (!mounted) return;
    context.go(done ? '/home' : '/onboarding');
  }

  @override
  void dispose() {
    _intro.dispose();
    _pulse.dispose();
    super.dispose();
  }

  Widget _ring(double offset) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        final t = (_pulse.value + offset) % 1.0;
        return Opacity(
          opacity: (1 - t) * 0.4,
          child: Transform.scale(
            scale: 1 + t * 0.9,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white, // matches the native splash
        body: Stack(
          children: [
            // The gradient fades in over the white native splash.
            Positioned.fill(
              child: FadeTransition(
                opacity: _bg,
                child: DecoratedBox(
                  decoration:
                      BoxDecoration(gradient: AppColors.heroGradient(context)),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 280,
                    height: 280,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _ring(0.0),
                          _ring(0.5),
                          ScaleTransition(
                            scale: _logoScale,
                            child: Container(
                              width: 120,
                              height: 120,
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(34),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 30,
                                    offset: const Offset(0, 14),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeTransition(
                    opacity: _titleFade,
                    child: SlideTransition(
                      position: _titleSlide,
                      child: Text(
                        l10n.appName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeTransition(
                    opacity: _taglineFade,
                    child: Text(
                      l10n.onboardingTitle1,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 56,
              child: FadeTransition(
                opacity: _taglineFade,
                child: const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}