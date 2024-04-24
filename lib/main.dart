import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/constants/route.dart';
import 'package:spotify_clone/providers/auth_provider.dart';
import 'package:spotify_clone/providers/category_provider.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/providers/music_provider.dart';
import 'package:spotify_clone/providers/search_music_provider.dart';
import 'package:spotify_clone/services/deep_links.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    DeepLinkService().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MusicProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => MusicPlayerProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: Builder(builder: (context) {
        DeepLinkService().onDeepLinkReceived = (uri) {
          Provider.of<AuthProvider>(context, listen: false).login(uri);
        };
        return MaterialApp.router(
          routerDelegate: AppRouter.router.routerDelegate,
          routeInformationParser: AppRouter.router.routeInformationParser,
          routeInformationProvider: AppRouter.router.routeInformationProvider,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: const ColorScheme.dark().copyWith(
                primary: Colors.black,
                background: Colors.black.withOpacity(0.6)),
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
        );
      }),
    );
  }
}
