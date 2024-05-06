import 'package:flutter/material.dart';

class SearchScreenAppBar extends StatelessWidget {
  final bool showSearchText;
  final bool showMPText;

  const SearchScreenAppBar({
    Key? key,
    this.showSearchText = true,
    this.showMPText = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Colors.black,
              size: 20,
            ),
          ),
          SizedBox(width: 10),
          if (showSearchText)
            Text(
              'Search',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          if (showMPText)
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 31, 31, 31),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'Musik',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 31, 31, 31),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'Podcast',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
