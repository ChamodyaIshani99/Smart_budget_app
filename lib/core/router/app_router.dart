import 'package:go_router/go_router.dart';
import '../../data/models/bill.dart';
import '../../features/bills/add_edit_bill_screen.dart';
import '../../features/bills/bill_detail_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/splash/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/home', builder: (_, __) => const MainShell()),
    GoRoute(path: '/bills/add', builder: (_, __) => const AddEditBillScreen()),
    GoRoute(
      path: '/bills/edit',
      builder: (_, state) => AddEditBillScreen(bill: state.extra as Bill?),
    ),
    GoRoute(
      path: '/bills/detail/:id',
      builder: (_, state) => BillDetailScreen(
        billId: int.parse(state.pathParameters['id']!),
      ),
    ),
  ],
);