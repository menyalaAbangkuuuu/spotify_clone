import 'package:flutter/material.dart';
import 'package:spotify_clone/view/widget/music_player.dart';
import 'package:spotify_clone/view/widget/search_screen_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/view/widget/bottom_nav_bar.dart';

class PlaylistDetailScreen extends StatelessWidget {
  static const routeName = '/playlist_detail';

  final String playlistId;
  final String playlistName;
  final int currentPageIndex;
  final Function(int) onItemTapped;

  const PlaylistDetailScreen({
    Key? key,
    required this.playlistId,
    required this.playlistName,
    required this.currentPageIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SearchScreenAppBar(
          showSearchText: currentPageIndex == 1,
        ),
      ),
      body: Center(
        child: Text('Playlist Detail Screen for $playlistName'),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentPageIndex,
        onItemSelected: onItemTapped,
      ),
    );
  }
}
