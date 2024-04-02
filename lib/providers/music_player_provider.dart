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
    _audioPlayer.onPositionChanged.listen((Duration duration) async {
      if (duration != _totalDuration) {
        _currentPosition = duration;
        notifyListeners();
      }
      if (_queue.isEmpty) {
        _currentPosition = Duration.zero;
        _totalDuration = Duration.zero;
        notifyListeners();
      }
      if (_audioPlayer.state == PlayerState.completed && _queue.isNotEmpty) {
        _queue.removeAt(0);
        await play();

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
  List<Track> get queue => _queue.isEmpty ? [] : _queue.sublist(1);

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

  void setToFirst(int currentIndex) {
    _queue.removeRange(0, currentIndex + 1);
    notifyListeners();
  }

  Future<void> play() async {
    _currentTrack = _queue.first;
    Music music = await Youtube.getVideo(
        songName: _currentTrack!.name!,
        artistName: _currentTrack!.artists!.first.name!);

    _totalDuration = music.duration!;

    _currentTrackColor = await ColorGenerator.getImagePalette(
            NetworkImage(_currentTrack!.album!.images!.first.url!)) ??
        Colors.grey;

    _lyric = await LyricService.getLyric(_currentTrack!.id!);

    await _audioPlayer.play(UrlSource(music.url));
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

  void next() async {
    if (_queue.isNotEmpty) {
      _queue.removeAt(0);
      await play();
      notifyListeners();
    }
  }
}
