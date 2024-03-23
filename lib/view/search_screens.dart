import 'package:flutter/material.dart';
import 'package:spotify_clone/main.dart';
import 'package:spotify_clone/view/search_music_screens.dart';

class SearchScreens extends StatefulWidget {
  static const id = 'search_screens';
  const SearchScreens({super.key});

  @override
  State<SearchScreens> createState() => _SearchScreensState();
}

class _SearchScreensState extends State<SearchScreens> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            onPressed: () =>
                navigatorKey.currentState?.pushNamed(SearchMusicScreens.id),
            child: Row(
              children: <Widget>[
                Icon(Icons.search, color: Colors.black.withOpacity(0.8)),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'What do you want to listen to?',
                  style: TextStyle(color: Colors.black.withOpacity(0.8)),
                )
              ],
            ))
      ],
    );
  }
}
