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
    GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
    GoRoute(path: '/home', builder: (_, _) => const MainShell()),
    GoRoute(path: '/bills/add', builder: (_, _) => const AddEditBillScreen()),
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