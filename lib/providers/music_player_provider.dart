import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/model/music.dart';
import 'package:spotify_clone/services/color_generator.dart';
import 'package:spotify_clone/services/youtube.dart';
import 'package:palette_generator/palette_generator.dart';

class MusicPlayerProvider extends ChangeNotifier {
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  final AudioPlayer _audioPlayer = AudioPlayer();

  Track? _currentTrack;
  Track? get currentTrack => _currentTrack;

  Color _currentTrackColor = Colors.grey;
  Color get currentTrackColor => _currentTrackColor;

  void resume() {
    _isPlaying = true;
    notifyListeners();
  }

  void play(Track track) async {
    _currentTrack = track;
    Music music = await Youtube.getVideo(
        songName: track.name!, artistName: track.artists!.first.name!);

    _currentTrackColor = await ColorGenerator.getImagePalette(
            NetworkImage(track.album!.images!.first.url!)) ??
        Colors.grey;
    print(music.url);
    _audioPlayer.play(UrlSource(music.url));
    _isPlaying = true;
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    notifyListeners();
  }
}
