import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/model/lyric.dart';
import 'package:spotify_clone/model/music.dart';
import 'package:spotify_clone/services/color_generator.dart';
import 'package:spotify_clone/services/lyric.dart';
import 'package:spotify_clone/services/spotify.dart';
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
      }

      /// kalo antriannya kosong, reset semua state
      if (_queue.isEmpty) {
        _currentPosition = Duration.zero;
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

        _isPlaying = false;
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

  Artist? _currentArtist;

  Artist? get currentArtist => _currentArtist;

  final List<Track> _queue = [];

  /// getter for the queue but exclude the current track
  List<Track> get queue => _queue.isEmpty ? [] : _queue.sublist(1);

  final List<Track> _prevQueue = [];

  Lyric? _lyric;

  Lyric? get lyric => _lyric;

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  bool _canPrev = false;

  bool get canPrev => _canPrev;

  bool _canNext = false;

  bool get canNext => _canNext;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // TODO nanti ini dibuat dokumentasinya ya
  bool _currentTrackIsLiked = false;

  bool get currentTrackIsLiked => _currentTrackIsLiked;

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
  void addToQueue(Track track, [int? index]) {
    _audioPlayer.stop();
    if (index != null) {
      _queue.insert(index, track);
    } else {
      _queue.clear();
      _queue.add(track);
      _currentTrack = _queue.first;
    }
    if (_queue.length > 1) {
      _canNext = true;
    }
    notifyListeners();
  }

  /// Removes the track at the specified [index] from the queue.
  /// After removing the track, the first track in the queue becomes the current track.
  /// Calling this method will notify all listeners of the change.
  /// Parameters:
  /// - [index]: The position of the track to remove from the queue.
  void setToFirst(int currentIndex) {
    _audioPlayer.stop();
    _queue.removeRange(0, currentIndex + 1);
    _currentTrack = _queue.first;
    _audioPlayer.stop();
    notifyListeners();
  }

  /// function ini digunakan untuk menambahkan lagu dari playlist ke queue
  /// semua list lagu sebelum index akan dimasukan ke prevQueue
  /// semua list lagu setelah index akan dimasukan ke queue
  void addFromPlaylist(List<Track> tracks, int index) {
    assert(index >= 0 && index < tracks.length, "Index out of bounds");

    // Determine navigation capabilities
    _canPrev = index > 0;
    _canNext = queue.isNotEmpty || index < tracks.length - 1;

    // Stop the current playback
    _audioPlayer.stop();

    // Update the previous queue
    _prevQueue
      ..clear()
      ..addAll(tracks.sublist(0, index));

    // Update the current queue
    _queue
      ..clear()
      ..addAll(tracks.sublist(index));

    // Set the current track
    _currentTrack = _queue.isNotEmpty ? _queue.first : null;

    // Notify listeners about the changes
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

  // TODO ini dijelasin ya diganti dengan Future.wait biar lebih cepat
  Future<void> play() async {
    if (_queue.isEmpty || _currentTrack == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Start fetching multiple data concurrently
      final musicFuture = Youtube.getVideo(
        songName: _currentTrack!.name ?? "",
        artistName: _currentTrack!.artists!.first.name ?? "",
      );

      final artistFuture = _getCurrentArtist();

      final colorFuture = ColorGenerator.getImagePalette(
        NetworkImage(_currentTrack!.album!.images!.first.url ?? ""),
      );

      final lyricFuture = LyricService.getLyric(_currentTrack?.id ?? "");

      // Wait for all the futures to complete
      final results = await Future.wait([
        musicFuture,
        artistFuture,
        colorFuture,
        lyricFuture,
      ]);

      // Extract the results
      final Music music = results[0] as Music;
      _totalDuration = music.duration!;
      _currentTrackColor = results[2] as Color? ?? Colors.grey;
      _lyric = results[3] as Lyric?;

      _checkIfTrackIsLiked();
      await _audioPlayer.play(UrlSource(music.url));
      _isPlaying = true;
    } catch (e) {
      _errorMessage = "This song cannot be played";
      _isPlaying = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
      _audioPlayer.stop();
      _prevQueue.add(_queue.first);
      _queue.removeAt(0);
      _currentTrack = _queue.first;
      _canPrev = true;
      _lyric = null;
      await play();
      if (_queue.length == 1) {
        _canNext = false;
      }
      notifyListeners();
    }
  }

  Future<void> prev() async {
    if (_prevQueue.isNotEmpty) {
      _audioPlayer.stop();
      _queue.insert(0, _prevQueue.last);
      _prevQueue.removeLast();
      _lyric = null;
      if (_prevQueue.isEmpty) {
        _canPrev = false;
      }
      _currentTrack = _queue.first;
      _canNext = true;
      await play();
      notifyListeners();
    }
  }

  // TODO ini nanti dijelaskan ya
  void _checkIfTrackIsLiked() async {
    _currentTrackIsLiked =
        await SpotifyService.checkTrackSaved(_currentTrack?.id ?? "");
    notifyListeners();
  }

  void swap(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    // Perform the swap
    final item = _queue.removeAt(oldIndex + 1);
    _queue.insert(newIndex + 1, item);

    notifyListeners();
  }

  Future<void> _getCurrentArtist() async {
    _currentArtist =
        await SpotifyService.getArtist(_currentTrack?.artists?.first.id ?? "");
  }

  // TODO nanti ini dibuat dokumentasinya ya
  Future<void> saveTrack(String trackId) async {
    await SpotifyService.addSongToSavedTracks(trackId);
    _currentTrackIsLiked = true;
    notifyListeners();
  }
}
