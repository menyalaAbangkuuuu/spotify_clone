import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/screens/category_detail/category_detail.dart';
import 'package:spotify_clone/screens/lyric/full_lyric_screen.dart';
import 'package:spotify_clone/screens/home/home_screen.dart';
import 'package:spotify_clone/screens/common/main_screen.dart';
import 'package:spotify_clone/screens/music_detail/music_detail_screen.dart';
import 'package:spotify_clone/screens/queue/queue_list_screen.dart';
import 'package:spotify_clone/screens/search_music/search_music_screens.dart';
import 'package:spotify_clone/screens/search/search_screen.dart';
import 'package:spotify_clone/screens/library/library_screens.dart';

import '../screens/playlist/playlist_screen.dart';

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
          GoRoute(
            path: '${PlaylistScreen.routeName}/:id',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return MaterialPage<void>(
                child: PlaylistScreen(
                  playlistId: id,
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
        path: QueueScreen.routeName,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const QueueScreen(),
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
        path: LibraryScreen.routeName,
        pageBuilder: (context, state) {
          return const MaterialPage<void>(
            child: LibraryScreen(),
          );
        },
      ),
    ],
  );

  static GoRouter get router => _router;
}
