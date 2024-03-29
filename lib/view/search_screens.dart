import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/main.dart';
import 'package:spotify_clone/view/search_music_screens.dart';
import 'package:spotify_clone/view/widget/categories_tile.dart';

class SearchScreens extends StatefulWidget {
  static const id = '/search';
  const SearchScreens({super.key});

  @override
  State<SearchScreens> createState() => _SearchScreensState();
}

class _SearchScreensState extends State<SearchScreens> {
  @override
  void initState() {
    super.initState();
  }

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
            onPressed: () => context.push(SearchMusicScreens.id),
            child: Column(children: [
              Row(
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
              ),
            ])),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                'Browse all',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(child: CategoryTiles())
            ],
          ),
        ),
      ],
    );
  }
}
