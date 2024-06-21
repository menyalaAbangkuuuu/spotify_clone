import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/screens/category_detail/category_detail.dart';
import 'package:spotify_clone/screens/common/splash_screen.dart';
import 'package:spotify_clone/screens/login/login_screen.dart';
import 'package:spotify_clone/screens/lyric/full_lyric_screen.dart';
import 'package:spotify_clone/screens/home/home_screen.dart';
import 'package:spotify_clone/screens/common/main_screen.dart';
import 'package:spotify_clone/screens/music_detail/music_detail_screen.dart';
import 'package:spotify_clone/screens/queue/queue_list_screen.dart';
import 'package:spotify_clone/screens/search_music/search_music_screens.dart';
import 'package:spotify_clone/screens/search/search_screen.dart';
import 'package:spotify_clone/screens/library/library_screen.dart';
import 'package:spotify_clone/services/spotify.dart';

import '../screens/playlist/playlist_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: SplashScreen.routeName,
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
            path: LibraryScreen.routeName,
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: LibraryScreen(),
              );
            },
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
        path: SplashScreen.routeName,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SplashScreen(),
          );
        },
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
          debugPrint(state.matchedLocation);
          return const MaterialPage<void>(
            child: LibraryScreen(),
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
      print(state.matchedLocation);
      if (state.matchedLocation == "/auth") {
        final uri = state.uri;

        SpotifyService.handleAuthorization(uri);

        return LibraryScreen.routeName; // Navigate to the appropriate page
      }

      final bool loggedIn = FirebaseAuth.instance.currentUser != null;
      final bool loggingIn = state.matchedLocation == LoginScreen.routeName;
      if (!loggedIn) return LoginScreen.routeName;
      if (loggingIn) return MyHomePage.routeName;

      return null;
    },
  );

  static GoRouter get router => _router;
}
