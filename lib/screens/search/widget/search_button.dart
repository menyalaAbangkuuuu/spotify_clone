import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/screens/search_music/search_music_screens.dart';

ElevatedButton searchButton(BuildContext context) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
    onPressed: () => context.push(SearchMusicScreen.routeName),
    child: Column(
      children: [
        Row(
          children: <Widget>[
            Icon(
              Icons.search,
              color: Colors.black.withOpacity(0.8),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'What do you want to listen to?',
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
              ),
            )
          ],
        ),
      ],
    ),
  );
}
