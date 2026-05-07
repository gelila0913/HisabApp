import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/select_role.dart';
import '../../features/auth/presentation/screens/business_type.dart';
import '../../features/auth/presentation/screens/signup.dart';
import '../../features/auth/presentation/screens/login.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SelectRoleScreen(),
      ),

      GoRoute(
        path: '/business',
        builder: (context, state) => const BusinessTypeScreen(),
      ),

      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),

      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      
    ],
  );
}