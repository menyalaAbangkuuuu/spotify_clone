import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => context.go(MyHomePage.routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/icon/icon-removebg-preview.png',
          width: 140,
        ),
      ),
    );
  }
}
