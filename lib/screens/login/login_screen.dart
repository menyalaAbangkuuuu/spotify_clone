import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/screens/home/home_screen.dart';
import 'package:spotify_clone/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
          onPressed: () async {
            final user = await AuthService.logInWithGoogle();
            if (user.user != null) {
              context.go(MyHomePage.routeName);
            }
          },
          child: Text('Login with google')),
    ));
  }
}
