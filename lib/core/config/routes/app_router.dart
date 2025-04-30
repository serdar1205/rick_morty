import 'package:go_router/go_router.dart';
import 'package:rick_morty/core/config/routes/routes_path.dart';
import 'package:rick_morty/core/config/routes/scaffold_with_nested_nav.dart';
import 'package:rick_morty/features/presentation/pages/favorites_page.dart';
import 'package:rick_morty/features/presentation/pages/main_page.dart';
import 'widget_keys_srt.dart';

final goRouter = GoRouter(
  initialLocation: AppRoutes.mainPage,
  navigatorKey: rootNavKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: shellNavKeyHome,
          routes: [
            GoRoute(
              path: AppRoutes.mainPage,
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                  child: MainPage(),
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: shellNavKeyFavorites,
          routes: [
            GoRoute(
              path: AppRoutes.favoritesPage,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  child: FavoritesPage(),
                );
              },
            )
          ],
        ),
      ],
    ),
  ],
);
