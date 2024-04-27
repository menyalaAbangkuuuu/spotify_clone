import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/playlist_provider.dart';
import 'package:spotify_clone/view/playlist_screen.dart';
import 'package:spotify_clone/view/widget/bottom_nav_bar.dart';
import 'package:spotify_clone/view/main_screens.dart';

class CategoryDetailScreen extends StatelessWidget {
  static const routeName = '/category';

  final String id;
  final String categoryName;
  final int currentPageIndex;
  final Function(int) onItemTapped;

  const CategoryDetailScreen({
    Key? key,
    required this.id,
    required this.categoryName,
    required this.currentPageIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScreen(
      screen: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        categoryName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            Navigator.pushReplacementNamed(context, '/playlist');
          }
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Scaffold(
      body: Consumer<PlaylistProvider>(
        builder: (context, playlistProvider, _) {
          if (playlistProvider.playlists == null ||
              playlistProvider.playlists!.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: playlistProvider.playlists!.length,
            itemBuilder: (context, index) {
              final playlist = playlistProvider.playlists![index];
              return ListTile(
                title: Text(playlist.name ?? 'Unknown'),
                subtitle: Text(playlist.description ?? ''),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    PlaylistDetailScreen.routeName,
                    arguments: PlaylistDetailScreenArguments(
                      playlistId: playlist.id!,
                      playlistName: playlist.name ?? 'Unknown',
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
