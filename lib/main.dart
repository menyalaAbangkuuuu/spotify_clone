import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/config/route.dart';
import 'package:spotify_clone/providers/auth_provider.dart';
import 'package:spotify_clone/providers/category_provider.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/providers/music_provider.dart';
import 'package:spotify_clone/providers/search_music_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final GoRouter router = AppRouter.router;

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MusicProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => MusicPlayerProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider())
      ],
      child: MaterialApp.router(
        routerDelegate: AppRouter.router.routerDelegate,
        routeInformationParser: AppRouter.router.routeInformationParser,
        routeInformationProvider: AppRouter.router.routeInformationProvider,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: const ColorScheme.dark().copyWith(
            primary: Colors.green,
            background: Colors.black.withOpacity(0.6),
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
              TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            },
          ),
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: Colors.black,
            indicatorColor: Colors.transparent,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            labelTextStyle: MaterialStateProperty.resolveWith((state) {
              if (state.contains(MaterialState.selected)) {
                return const TextStyle(color: Colors.white);
              }
              return TextStyle(color: Colors.white.withOpacity(0.6));
            }),
          ),
          fontFamily: "Circular",
          useMaterial3: true,
        ),
      ),
    );
  }
}
