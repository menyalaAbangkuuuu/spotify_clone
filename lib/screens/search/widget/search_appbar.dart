import 'package:flutter/material.dart';

AppBar searchAppBar(BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: const Text(
      'Search',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: false,
    leading: const IconButton(
      icon: Icon(Icons.person),
      onPressed: null,
    ),
  );
}
