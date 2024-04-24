import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/auth_provider.dart';
import 'package:spotify_clone/services/spotify.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            Provider.of<AuthProvider>(context).currentUser?.displayName ??
                'Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // login
            SpotifyService.login();
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
