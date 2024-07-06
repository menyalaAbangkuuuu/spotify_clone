import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spotify_clone/providers/auth_provider.dart';
import 'package:spotify_clone/screens/common/main_screen.dart';
import 'package:spotify_clone/screens/playlist/playlist_screen.dart';
import 'package:spotify_clone/screens/savedSong/saved_song_screen.dart';
import 'package:spotify_clone/screens/search/search_screen.dart';
import 'package:spotify_clone/services/spotify.dart';

class LibraryScreen extends StatefulWidget {
  static const String routeName = '/library';

  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  // Function to show full-size bottom drawer
  // make controller for input

  final TextEditingController _playlistNameController = TextEditingController();

  void _showBottomDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 10,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.9,
          initialChildSize: 0.9,
          minChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Give your playlist a name',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _playlistNameController,
                          decoration: const InputDecoration(
                            hintText: 'Playlist Name',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_playlistNameController.text.isNotEmpty) {
                            SpotifyService.createPlaylist(
                              _playlistNameController.text,
                            );
                            context.pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Create',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Consumer<AuthProvider>(
                      builder: (context, userProvider, child) {
                    if (userProvider.isLoading) {
                      return const CircularProgressIndicator();
                    }
                    if (userProvider.user == null) {
                      return const Icon(Icons.error);
                    }

                    return CachedNetworkImage(
                      height: 36,
                      width: 36,
                      imageUrl: userProvider.user?.images?.first.url ?? "",
                      imageBuilder: (context, imageProvider) => Container(
                        width: 36.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.black.withOpacity(.5),
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.black.withOpacity(.6),
                          height: 50.0,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.music_note_outlined,
                          size: 100,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 20),
                const Text(
                  'Your Library',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(
                Icons.add,
                size: 36,
              ),
              onPressed: () => _showBottomDrawer(context),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: SpotifyService.getPlaylistFromUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.waveDots(
                  color: Colors.white,
                  size: 48,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              final playlistData = snapshot.data;
              return ListView.builder(
                itemCount: playlistData?.length,
                itemBuilder: (context, index) {
                  final playlist = playlistData?[index];
                  return ListTile(
                    leading: CachedNetworkImage(
                      height: 60,
                      width: 60,
                      imageUrl: playlist?.images?.first.url ?? "",
                      imageBuilder: (context, imageProvider) => Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.black.withOpacity(.5),
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.black.withOpacity(.6),
                          height: 60.0,
                        ),
                      ),
                      errorWidget: (context, url, error) => const SizedBox(
                        width: 60,
                        height: 60,
                        child: Center(
                          child: Icon(Icons.error),
                        ),
                      ),
                    ),
                    title: Text(playlist?.name ?? ""),
                    subtitle: Text(playlist?.description ?? 'No description'),
                    onTap: () {
                      // Navigate to playlist detail or play the playlist
                      if (playlist?.id == "liked-songs") {
                        context.push(SavedSongScreen.routeName);
                        return;
                      }
                      context.push(
                          '${PlaylistScreen.routeName}/${playlist?.id ?? ""}');
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No playlists found'),
              );
            }
          },
        ),
      ),
    );
  }
}
