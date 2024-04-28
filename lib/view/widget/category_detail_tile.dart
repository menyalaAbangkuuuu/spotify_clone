import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

class CategoryDetailTile extends StatelessWidget {
  final Playlist playlist;

  const CategoryDetailTile({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return _buildTile();
  }

  Widget _buildTile() {
    return ListTileWidget(
      title: playlist.name ?? 'Default Name',
      onTap: () {},
    );
  }
}

class ListTileWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ListTileWidget({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }
}
