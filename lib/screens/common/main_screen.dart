import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/screens/home/home_screen.dart';
import 'package:spotify_clone/screens/search/search_screen.dart';
import 'package:spotify_clone/screens/search/widget/search_appbar.dart';
import 'package:spotify_clone/widget/custom_drawer.dart';
import 'package:spotify_clone/widget/mini_player.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
        context.go(MyHomePage.routeName);
        break;
      case 1:
        context.go(SearchScreens.routeName);
        break;
      case 2:
        context.go('/library');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Column(
        children: [
          Expanded(child: widget.screen),
          const MiniPlayer(),
        ],
      ),
      drawer: const CustomDrawer(),
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
