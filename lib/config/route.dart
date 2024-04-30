import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/view/category_detail.dart';
import 'package:spotify_clone/screens/lyric/full_lyric_screen.dart';
import 'package:spotify_clone/screens/home/home_screen.dart';
import 'package:spotify_clone/screens/common/main_screen.dart';
import 'package:spotify_clone/screens/music_detail/music_detail_screen.dart';
import 'package:spotify_clone/view/playlist_screen.dart';
import 'package:spotify_clone/view/queue_list_screen.dart';
import 'package:spotify_clone/screens/search_music/search_music_screens.dart';
import 'package:spotify_clone/screens/search/search_screen.dart';
import 'package:spotify_clone/view/library_screens.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: MyHomePage.routeName,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScreen(
          screen: child,
        ),
        routes: [
          GoRoute(
            path: MyHomePage.routeName,
            pageBuilder: (context, state) => const MaterialPage(
              child: MyHomePage(),
            ),
          ),
          GoRoute(
            path: SearchScreens.routeName,
            pageBuilder: (context, state) => const MaterialPage(
              child: SearchScreens(),
            ),
          ),
          GoRoute(
            path: SearchMusicScreen.routeName,
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: SearchMusicScreen(),
              );
            },
          ),
          GoRoute(
            path: '${CategoryDetailScreen.routeName}/:id/:categoryName',
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
        ],
      ),
      GoRoute(
        path: SearchMusicScreen.routeName,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SearchMusicScreen(),
          );
        },
      ),
      GoRoute(
        path: FullLyricScreens.id,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: FullLyricScreens(),
          );
        },
      ),
      GoRoute(
        path: MusicDetailScreen.routeName,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: MusicDetailScreen(),
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
