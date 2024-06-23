import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/screens/login/login_screen.dart';
import 'package:spotify_clone/services/spotify.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                FutureBuilder(
                  future: SpotifyService.getMe(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        leading: const CircularProgressIndicator(),
                        title: Text(
                          'Loading...',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return ListTile(
                        leading: const Icon(Icons.error),
                        title: Text(
                          'Error',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final user = snapshot.data;
                      final imageUrl = user?.images?.isNotEmpty == true
                          ? user!.images!.first.url
                          : 'https://jsonplaceholder.com';
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl!),
                        ),
                        title: Text(
                          user?.displayName ?? 'Guest',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      );
                    } else {
                      return ListTile(
                        leading: const Icon(Icons.error),
                        title: Text(
                          'Error',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      );
                    }
                  },
                ),
                Divider(
                  color: Colors.white.withOpacity(0.2),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                context.go(LoginScreen.routeName);
              },
              child: const Text('Log out',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
