import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/model/lyric.dart';
import 'package:spotify_clone/model/music.dart';
import 'package:spotify_clone/services/color_generator.dart';
import 'package:spotify_clone/services/lyric.dart';
import 'package:spotify_clone/services/youtube.dart';

class MusicPlayerProvider extends ChangeNotifier {
  MusicPlayerProvider() {
    _audioPlayer.onPlayerComplete.listen((event) {
      // When the audio finishes playing, update the state to reflect this.
      _isPlaying = false;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((Duration duration) {
      if (duration != _totalDuration) {
        _currentPosition = duration;
        notifyListeners();
      }
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

  final List<Track> _queue = [];
  List<Track> get queue => _queue;

  Lyric? _lyric;
  Lyric? get lyric => _lyric;

  void resume() {
    _isPlaying = true;
    _audioPlayer.resume();
    notifyListeners();
  }

  void addToQueue(Track track, int? index) {
    if (index != null) {
      _queue.insert(index, track);
    } else {
      _queue.add(track);
    }
    notifyListeners();
  }

  void play() async {
    _currentTrack = _queue.first;
    Music music = await Youtube.getVideo(
        songName: _currentTrack!.name!,
        artistName: _currentTrack!.artists!.first.name!);

    _totalDuration = music.duration!;

    _currentTrackColor = await ColorGenerator.getImagePalette(
            NetworkImage(_currentTrack!.album!.images!.first.url!)) ??
        Colors.grey;

    _lyric = await LyricService.getLyric(_currentTrack!.id!);

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
