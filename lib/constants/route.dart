import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/view/category_detail.dart';
import 'package:spotify_clone/view/full_lyric_screen.dart';
import 'package:spotify_clone/view/home_screens.dart';
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
            pageBuilder: (context, state) => const MaterialPage(
              child: SearchScreens(),
            ),
          ),
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
          return MaterialPage(
            child: FullLyricScreens(
              musicPlayerProvider: args as MusicPlayerProvider,
            ),
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
    ],
  );
  static GoRouter get router => _router;
}
