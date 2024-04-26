import 'package:flutter/material.dart';

class SearchScreenAppBar extends StatelessWidget {
  const SearchScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: const Row(
        children: <Widget>[
          CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.black,
                size: 20,
              )),
          SizedBox(
            width: 10,
          ),
          Text(
            'Search',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          )
        ],
      ),
    );
  }
}
