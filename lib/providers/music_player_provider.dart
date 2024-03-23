import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/model/music.dart';
import 'package:spotify_clone/services/color_generator.dart';
import 'package:spotify_clone/services/youtube.dart';

class MusicPlayerProvider extends ChangeNotifier {
  MusicPlayerProvider() {
    _audioPlayer.onPositionChanged.listen((Duration duration) {
      _currentPosition = duration;
      notifyListeners();
    });
  }

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  final AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayer get audioPlayer => _audioPlayer;

  Track? _currentTrack;
  Track? get currentTrack => _currentTrack;

  Color _currentTrackColor = Colors.grey;
  Color get currentTrackColor => _currentTrackColor;

  Duration _currentPosition = Duration.zero;
  Duration get currentPosition => _currentPosition;

  Duration _totalDuration = Duration.zero;
  Duration get totalDuration => _totalDuration;

  void resume() {
    _isPlaying = true;
    _audioPlayer.resume();
    notifyListeners();
  }

  void play(Track track) async {
    _currentTrack = track;
    Music music = await Youtube.getVideo(
        songName: track.name!, artistName: track.artists!.first.name!);

    _totalDuration = track.duration!;

    _currentTrackColor = await ColorGenerator.getImagePalette(
            NetworkImage(track.album!.images!.first.url!)) ??
        Colors.grey;
    _audioPlayer.play(UrlSource(music.url));
    _isPlaying = true;
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    _audioPlayer.pause();
    notifyListeners();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
    notifyListeners();
  }
}
