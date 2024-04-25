import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart' hide Offset;
import 'package:spotify_clone/providers/auth_provider.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/services/spotify.dart';
import 'package:spotify_clone/view/category_detail.dart';
import 'package:spotify_clone/view/full_lyric_screen.dart';
import 'package:spotify_clone/view/home_screens.dart';
import 'package:spotify_clone/view/login_screen.dart';
import 'package:spotify_clone/view/main_screens.dart';
import 'package:spotify_clone/view/music_detail_screens.dart';
import 'package:spotify_clone/view/queue_list_screen.dart';
import 'package:spotify_clone/view/search_music_screens.dart';
import 'package:spotify_clone/view/search_screens.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: MyHomePage.id,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScreen(
          screen: child,
        ),
        routes: [
          GoRoute(
            path: MyHomePage.id,
            pageBuilder: (context, state) =>
                const MaterialPage(child: MyHomePage()),
          ),
          GoRoute(
              path: SearchScreens.id,
              pageBuilder: (context, state) => CustomTransitionPage(
                    child: const SearchScreens(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = const Offset(-1.0, 0.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 300),
                  )),
          GoRoute(
            path: SearchMusicScreens.id,
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: SearchMusicScreens(),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: SearchMusicScreens.id,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SearchMusicScreens(),
          );
        },
      ),
      GoRoute(
        path: FullLyricScreens.id,
        pageBuilder: (context, state) {
          final args = state.extra;
          return CustomTransitionPage(
            child: FullLyricScreens(
              musicPlayerProvider: args as MusicPlayerProvider,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const Offset begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              final tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              final offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 50),
          );
        },
      ),
      GoRoute(
        path: MusicDetailScreens.id,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: MusicDetailScreens(),
          );
        },
      ),
      GoRoute(
          path: '/category/:id',
          name: CategoryDetailScreen.routeName,
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return MaterialPage(
              child: CategoryDetailScreen(
                id: id,
              ),
            );
          }),
      GoRoute(
        path: QueueListScreen.routeName,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const QueueListScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // create fade transition
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
          );
        },
      ),
      GoRoute(
          path: LoginScreen.routeName,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: LoginScreen(),
            );
          }),
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      final User? user =
          Provider.of<AuthProvider>(context, listen: false).currentUser;

      // Check if user is not logged in and trying to access other than login screen
      if (user?.id == null && state.matchedLocation != LoginScreen.routeName) {
        return LoginScreen.routeName; // Redirect to login if not logged in
      }

      if (user?.id != null && state.matchedLocation == LoginScreen.routeName) {
        return MyHomePage.id;
      }

      // No redirection necessary
      return state.matchedLocation;
    },
  );
  static GoRouter get router => _router;
}
