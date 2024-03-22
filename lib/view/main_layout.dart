import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/view/home_screens.dart';
import 'package:spotify_clone/view/search_screens.dart';
import 'package:spotify_clone/view/widget/music_player.dart';
import 'package:spotify_clone/view/widget/search_screen_app_bar.dart';

class MainLayout extends StatefulWidget {
  static const id = 'main_layout';
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentPageIndex = 0;

  final _pages = <Widget>[const MyHomePage(), const SearchScreens()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SearchScreenAppBar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: currentPageIndex,
              children: _pages,
            ),
          ),
          const MusicPlayer(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
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
            label: 'search',
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.library_music, color: Colors.white),
            icon: Icon(Icons.library_music_outlined,
                color: Colors.white.withOpacity(0.6)),
            label: 'library',
          ),
        ],
      ),
    );
  }
}
