import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/auth_provider.dart';
import 'package:spotify_clone/services/deep_links.dart';
import 'package:spotify_clone/services/spotify.dart';
import 'package:spotify_clone/view/home_screens.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DeepLinkService().onDeepLinkReceived = (uri) {
      Provider.of<AuthProvider>(context, listen: false).login(uri);
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(
            Provider.of<AuthProvider>(context).currentUser?.displayName ??
                'Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage("assets/icon/icon.png"),
              height: 50,
            ),
            const Text(
              "Millions of songs.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            const Text(
              "Free on Spotify.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(29, 185, 84, 1),
              ),
              onPressed: () {
                // login
                SpotifyService.login();
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
