import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/model/lyric.dart';
import 'package:spotify_clone/model/music.dart';
import 'package:spotify_clone/services/color_generator.dart';
import 'package:spotify_clone/services/lyric.dart';
import 'package:spotify_clone/services/youtube.dart';

/// A provider class that provides the music player state
/// and the audio player instance

class MusicPlayerProvider extends ChangeNotifier {
  /// Constructor for the MusicPlayerProvider
  MusicPlayerProvider() {
    /// Listen to the audio player events
    _audioPlayer.onPositionChanged.listen((Duration duration) async {
      if (duration != _totalDuration) {
        _currentPosition = duration;
        notifyListeners();
      }

      /// kalo antriannya kosong, reset semua state
      if (_queue.isEmpty) {
        _currentPosition = Duration.zero;
        _totalDuration = Duration.zero;
        notifyListeners();
      }
      if (_audioPlayer.state == PlayerState.completed && _queue.isNotEmpty) {
        _queue.removeAt(0);
        await play();
      }
    });

    /// Listen to the audio player events
    _audioPlayer.onPlayerComplete.listen((event) async {
      /// kalo antriannya lebih dari 1, lanjut ke lagu berikutnya
      if (_queue.length > 1) {
        await next();
        notifyListeners();
      } else {
        await _audioPlayer.stop();
        _currentPosition = Duration.zero;
        notifyListeners();
      }
    });
  }

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  final AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayer get audioPlayer => _audioPlayer;

  /// The current track that is being played
  Track? _currentTrack;
  Track? get currentTrack => _currentTrack;

  /// The color of the current track
  Color _currentTrackColor = Colors.grey;
  Color get currentTrackColor => _currentTrackColor;

  Duration _currentPosition = Duration.zero;
  Duration get currentPosition => _currentPosition;

  Duration _totalDuration = Duration.zero;
  Duration get totalDuration => _totalDuration;

  final List<Track> _queue = [];

  /// getter for the queue but exclude the current track
  List<Track> get queue => _queue.isEmpty ? [] : _queue.sublist(1);

  Lyric? _lyric;
  Lyric? get lyric => _lyric;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  /// resume the audio player
  void resume() {
    _isPlaying = true;
    _audioPlayer.resume();
    notifyListeners();
  }

  /// Adds a [Track] to the queue either at a specified [index] or at the end if no index is provided.
  ///
  /// If an [index] is specified, the track is inserted at that position in the queue.
  /// If no [index] is given, the queue is cleared, and the track is added as the only item.
  /// After modifying the queue, the first track in the queue becomes the current track.
  ///
  /// Calling this method will notify all listeners of the change.
  ///
  /// Parameters:
  /// - [track]: The `Track` object to add to the queue.
  /// - [index]: The position at which to insert the track. If null, the queue is cleared and the track is added at the end.
  void addToQueue(Track track, int? index) {
    if (index != null) {
      _queue.insert(index, track);
    } else {
      _queue.clear();
      _queue.add(track);
      _currentTrack = _queue.first;
    }
    notifyListeners();
  }

  /// Removes the track at the specified [index] from the queue.
  /// After removing the track, the first track in the queue becomes the current track.
  /// Calling this method will notify all listeners of the change.
  /// Parameters:
  /// - [index]: The position of the track to remove from the queue.
  void setToFirst(int currentIndex) {
    _queue.removeRange(0, currentIndex + 1);
    _currentTrack = _queue.first;
    _audioPlayer.stop();
    notifyListeners();
  }

  /// hanya untuk menghapus error message
  void clearError() {
    _errorMessage = "";
    notifyListeners();
  }

  /// Plays the current track in the queue.
  /// If the queue is empty, this method does nothing.
  /// If the current track is null, this method does nothing.

  Future<void> play() async {
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

  /// Pauses the audio player.
  void pause() {
    _isPlaying = false;
    _audioPlayer.pause();
    notifyListeners();
  }

  /// Seeks to the specified [position] in the audio player.
  /// After seeking, the audio player resumes playing.
  /// Calling this method will notify all listeners of the change.
  /// Parameters:
  /// - [position]: The position to seek to in the audio player.
  void seek(Duration position) {
    _audioPlayer.seek(position);
    resume();
    notifyListeners();
  }

  /// Plays the previous track in the queue.
  /// If the queue is empty, this method does nothing.
  /// If the current track is the first track in the queue, this method does nothing.
  /// After playing the previous track, the first track in the queue becomes the current track.
  /// Calling this method will notify all listeners of the change.
  Future<void> next() async {
    if (_queue.isNotEmpty) {
      _queue.removeAt(0);
      await play();
      notifyListeners();
    }
  }
}
