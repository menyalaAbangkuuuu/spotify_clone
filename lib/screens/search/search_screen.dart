import 'package:flutter/material.dart';
import 'package:spotify_clone/screens/search/widget/categories_tile.dart';
import 'package:spotify_clone/screens/search/widget/search_appbar.dart';
import 'package:spotify_clone/screens/search/widget/search_button.dart';

class SearchScreens extends StatefulWidget {
  static const routeName = '/search';

  const SearchScreens({super.key});

  @override
  State<SearchScreens> createState() => _SearchScreensState();
}

class _SearchScreensState extends State<SearchScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: SearchAppbar(
            title: "search",
          )),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              searchButton(context),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Browse all',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
          ),
        ),
      ),
    );
  }
}
