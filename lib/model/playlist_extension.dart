import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/services/color_generator.dart';

extension PlaylistExtension on Playlist {
  Future<Color?> fetchBackgroundColor() async {
    // Assuming playlist has an image and you have a method to fetch a color based on an image
    return await ColorGenerator.getImagePalette(
        NetworkImage(images?.first.url ?? ""));
  }
}

class PlaylistWithBackground {
  final Playlist playlist;
  final Color? backgroundColor;

  PlaylistWithBackground(
      {required this.playlist, required this.backgroundColor});
}
