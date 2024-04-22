import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/view/category_detail.dart';
import 'package:spotify_clone/view/full_lyric_screen.dart';
import 'package:spotify_clone/view/home_screens.dart';
import 'package:spotify_clone/view/main_screens.dart';
import 'package:spotify_clone/view/music_detail_screens.dart';
import 'package:spotify_clone/view/playlist_detail_screen.dart';
import 'package:spotify_clone/view/playlist_screen.dart';
import 'package:spotify_clone/view/queue_list_screen.dart';
import 'package:spotify_clone/view/search_music_screens.dart';
import 'package:spotify_clone/view/search_screens.dart';
import 'package:spotify_clone/view/library_screens.dart';

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
              var begin = const Offset(0.0, 1.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

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
        path: '/category/:id/:categoryName',
        name: CategoryDetailScreen.routeName,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          final categoryName = state.pathParameters['categoryName']!;
          return MaterialPage(
            child: CategoryDetailScreen(
              id: id,
              categoryName: categoryName,
            ),
          );
        },
      ),
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
        path: Library.id,
        pageBuilder: (context, state) {
          return const MaterialPage<void>(
            child: Library(),
          );
        },
      ),
      GoRoute(
        path: PlaylistScreen.routeName,
        pageBuilder: (context, state) {
          return const MaterialPage<void>(
            child: PlaylistScreen(),
          );
        },
      ),
    ],
  );
  static GoRouter get router => _router;
}
