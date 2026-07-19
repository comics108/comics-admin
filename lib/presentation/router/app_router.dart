import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/seasons_screen.dart';
import '../screens/episodes_screen.dart';
import '../screens/puzzles_screen.dart';
import '../screens/pieces_screen.dart';
import '../screens/quotes_screen.dart';
import '../screens/music_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/devices_screen.dart';
import '../widgets/main_layout.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoginRoute) {
        return '/login';
      }

      if (isAuthenticated && isLoginRoute) {
        return '/seasons';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: '/seasons',
            builder: (context, state) => const SeasonsScreen(),
          ),
          GoRoute(
            path: '/episodes',
            builder: (context, state) => const EpisodesScreen(),
          ),
          GoRoute(
            path: '/puzzles',
            builder: (context, state) => const PuzzlesScreen(),
          ),
          GoRoute(
            path: '/pieces',
            builder: (context, state) => const PiecesScreen(),
          ),
          GoRoute(
            path: '/quotes',
            builder: (context, state) => const QuotesScreen(),
          ),
          GoRoute(
            path: '/music',
            builder: (context, state) => const MusicScreen(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/devices',
            builder: (context, state) => const DevicesScreen(),
          ),
        ],
      ),
    ],
  );
});
