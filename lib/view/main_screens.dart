import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/view/category_detail.dart';
import 'package:spotify_clone/view/home_screens.dart';
import 'package:spotify_clone/view/search_screens.dart';
import 'package:spotify_clone/view/widget/music_player.dart';
import 'package:spotify_clone/view/widget/search_screen_app_bar.dart';

import '../main.dart';

class MainScreen extends StatefulWidget {
  final Widget screen;

  const MainScreen({super.key, required this.screen});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });

    switch (_currentPageIndex) {
      case 0:
        context.go(MyHomePage.id);
        break;
      case 1:
        context.go(SearchScreens.id);
        break;
      case 2:
        context.go('/library');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: SearchScreenAppBar(
          showSearchText: _currentPageIndex == 1,
        ),
      ),
      body: Column(
        children: [
          Expanded(child: widget.screen),
          const MusicPlayer(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPageIndex,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        onDestinationSelected: _onItemTapped,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(
              Icons.home_filled,
              color: Colors.white,
            ),
            icon:
                Icon(Icons.home_outlined, color: Colors.white.withOpacity(0.6)),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            icon: Icon(Icons.search, color: Colors.white.withOpacity(0.6)),
            label: 'Search',
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.library_music, color: Colors.white),
            icon: Icon(Icons.library_music_outlined,
                color: Colors.white.withOpacity(0.6)),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
