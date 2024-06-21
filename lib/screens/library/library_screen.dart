import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/services/spotify.dart';

class LibraryScreen extends StatefulWidget {
  static const String routeName = '/library';

  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    var currentUser = await SpotifyService.getMe();
    print(currentUser);
    setState(() {
      user = currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Text(user?.email ?? 'Guest'),
            ),
            ElevatedButton(
                onPressed: () => SpotifyService.authenticate(),
                child: const Text('Authenticate'))
          ],
        ),
      ),
    );
  }
}
