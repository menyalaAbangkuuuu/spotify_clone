import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:provider/provider.dart';
import 'package:spotify_clone/constants/route.dart';
import 'package:spotify_clone/providers/category_provider.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/providers/music_provider.dart';
import 'package:spotify_clone/providers/search_music_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => MusicProvider()),
//         ChangeNotifierProvider(create: (context) => SearchProvider()),
//         ChangeNotifierProvider(create: (context) => MusicPlayerProvider()),
//         ChangeNotifierProvider(create: (context) => CategoryProvider())
//       ],
//       child: MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           // This is the theme of your application.
//           //
//           // TRY THIS: Try running your application with "flutter run". You'll see
//           // the application has a purple toolbar. Then, without quitting the app,
//           // try changing the seedColor in the colorScheme below to Colors.green
//           // and then invoke "hot reload" (save your changes or press the "hot
//           // reload" button in a Flutter-supported IDE, or press "r" if you used
//           // the command line to start the app).
//           //
//           // Notice that the counter didn't reset back to zero; the application
//           // state is not lost during the reload. To reset the state, use hot
//           // restart instead.
//           //
//           // This works for code too, not just values: Most code changes can be
//           // tested with just a hot reload.
//           colorScheme: const ColorScheme.dark().copyWith(
//               primary: Colors.black, background: Colors.black.withOpacity(0.6)),
//           navigationBarTheme: NavigationBarThemeData(
//             backgroundColor: Colors.black,
//             indicatorColor: Colors.transparent,
//             labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
//             labelTextStyle: MaterialStateProperty.resolveWith((state) {
//               if (state.contains(MaterialState.selected)) {
//                 return const TextStyle(color: Colors.white);
//               }
//               return TextStyle(color: Colors.white.withOpacity(0.6));
//             }),
//           ),
//           fontFamily: "Circular",
//           useMaterial3: true,
//         ),
//         navigatorKey: navigatorKey,
//         home: const MainLayout(),
//         onGenerateRoute: (RouteSettings settings) {
//           switch (settings.name) {
//             case MyHomePage.id:
//               return PageRouteBuilder(
//                 pageBuilder: (_, __, ___) => const MyHomePage(),
//                 transitionsBuilder: (_, animation, __, child) {
//                   return FadeTransition(opacity: animation, child: child);
//                 },
//               );
//             case SearchScreens.id:
//               return PageRouteBuilder(
//                 pageBuilder: (_, __, ___) => const SearchScreens(),
//                 transitionsBuilder: (_, animation, __, child) {
//                   return FadeTransition(opacity: animation, child: child);
//                 },
//               );
//             case SearchMusicScreens.id:
//               return PageRouteBuilder(
//                 pageBuilder: (_, __, ___) => const SearchMusicScreens(),
//                 transitionsBuilder: (_, animation, __, child) {
//                   return FadeTransition(opacity: animation, child: child);
//                 },
//               );
//             case MusicDetailScreens.id:
//               return PageRouteBuilder(
//                 pageBuilder: (_, __, ___) => const MusicDetailScreens(),
//                 transitionsBuilder:
//                     (context, animation, secondaryAnimation, child) {
//                   var begin = const Offset(0.0, 1.0);
//                   var end = Offset.zero;
//                   var curve = Curves.ease;
//
//                   var tween = Tween(begin: begin, end: end)
//                       .chain(CurveTween(curve: curve));
//                   var offsetAnimation = animation.drive(tween);
//
//                   return SlideTransition(
//                       position: offsetAnimation, child: child);
//                 },
//               );
//             case FullLyricScreens.id:
//               final args = settings.arguments as MusicPlayerProvider?;
//               return PageRouteBuilder(
//                 pageBuilder: (_, __, ___) => FullLyricScreens(
//                   musicPlayerProvider: args ?? MusicPlayerProvider(),
//                 ),
//                 transitionsBuilder:
//                     (context, animation, secondaryAnimation, child) {
//                   var begin = const Offset(0.0, 1.0);
//                   var end = Offset.zero;
//                   var curve = Curves.ease;
//
//                   var tween = Tween(begin: begin, end: end)
//                       .chain(CurveTween(curve: curve));
//                   var offsetAnimation = animation.drive(tween);
//
//                   return SlideTransition(
//                       position: offsetAnimation, child: child);
//                 },
//               );
//
//             default:
//               // Consider handling unknown routes
//               return null;
//           }
//         },
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MusicProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => MusicPlayerProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider())
      ],
      child: MaterialApp.router(
        routerDelegate: AppRouter.router.routerDelegate,
        routeInformationParser: AppRouter.router.routeInformationParser,
        routeInformationProvider: AppRouter.router.routeInformationProvider,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: const ColorScheme.dark().copyWith(
              primary: Colors.black, background: Colors.black.withOpacity(0.6)),
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
