import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';

class SliderItemMusic extends StatefulWidget {
  final Track track;
  const SliderItemMusic({required this.track, super.key});

  @override
  State<SliderItemMusic> createState() => _SliderItemMusicState();
}

class _SliderItemMusicState extends State<SliderItemMusic> {
  bool _isAdded = false;

  void _onPressed() {
    setState(() {
      _isAdded = !_isAdded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      autoClose: false,
      onPressed: (context) {
        _onPressed();
        Provider.of<MusicPlayerProvider>(context, listen: false).addToQueue(
            widget.track,
            Provider.of<MusicPlayerProvider>(context, listen: false)
                    .queue
                    .length +
                1);
        Slidable.of(context)?.close(duration: const Duration(seconds: 1));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0.4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                _isAdded ? 'Added to queue' : 'Removed from queue',
              ),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      backgroundColor: _isAdded ? Colors.green : Colors.grey,
      foregroundColor: Colors.white,
      icon: _isAdded ? Icons.playlist_add_check : Icons.playlist_add,
    );
  }
}
