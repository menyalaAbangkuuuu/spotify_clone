import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final _user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ListTile(
                  title: Text(
                    _user?.displayName ?? 'Guest',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  leading: CircleAvatar(
                    radius: 24,
                    child: _user?.photoURL != null
                        ? ClipOval(
                            child: Image.network(
                              _user!.photoURL!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.person),
                  ),
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
                FirebaseAuth.instance.signOut();
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
