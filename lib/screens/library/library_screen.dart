import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  static const routeName = '/library';

  const LibraryScreen({super.key});


  //TODO: buat screen untuk library
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Text("ini adalah library"),
            ),
          ],
        ),
      ),
    );
  }
}
