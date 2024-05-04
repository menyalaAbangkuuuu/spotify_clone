import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/screens/login/login_screen.dart';

AppBar searchAppBar(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;

  return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        'Search',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      leading: CircleAvatar(
        radius: 10,
        child: user?.photoURL != null
            ? ClipOval(
                child: Image.network(
                  user!.photoURL!,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(Icons.person),
      ));
}
