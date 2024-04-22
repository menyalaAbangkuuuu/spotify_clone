import 'package:flutter/material.dart';

class SearchScreenAppBar extends StatelessWidget {
  final bool showSearchText;
  final bool showSearchIcon;

  const SearchScreenAppBar({
    Key? key,
    this.showSearchText = true,
    this.showSearchIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: Row(
        children: <Widget>[
          if (showSearchIcon)
            Icon(Icons.search, color: Colors.white),
          SizedBox(
            width: 10,
          ),
          if (showSearchText)
            Text(
              'Search',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
            )
        ],
      ),
    );
  }
}
