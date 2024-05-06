import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart' as spotify;
import 'package:spotify_clone/providers/music_provider.dart';

class TopTracksWidget extends StatelessWidget {
  const TopTracksWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    // Access the MusicProvider
    final musicProvider = Provider.of<MusicProvider>(context);

    // Check if topTracks is null or empty to show a loading or empty message
    if (musicProvider.topTracks == null || musicProvider.topTracks!.isEmpty) {
      return const Center(child: Text('Loading top playlists...'));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vertical Track List
          
          GridView.builder(
            shrinkWrap: true, // Adjusts to the content size
            
            itemCount: musicProvider.topTracks!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              childAspectRatio: 2.9, // Ratio of width to height
            ),
            itemBuilder: (context, index) {
              // Get the current track
              spotify.PlaylistSimple track = musicProvider.topTracks![index];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3, // 30% of space => (100 - 70) / 100
                          child:
                              track.images != null && track.images!.isNotEmpty
                                  ? Image.network(
                                      track.images!.first.url ?? "",
                                      fit: BoxFit.cover,
                                    )
                                  : Container(),
                        ),
                        Expanded(
                          flex: 7, // 70% of space => (100 - 30) / 100
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(
                                  track.name ?? "",
                                  style: TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 20,),
          Container(
            color: Color.fromARGB(255, 75, 0, 88),
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              children: [
                // Image with width 15% of container width
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: Image.network(
                    'https://storage.googleapis.com/pr-newsroom-wp/1/2022/03/Screen-Shot-2022-03-02-at-12.24.01-PM.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'K-Pop ON! (온) Hub',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Spacer(), // Add space between text and icon
                // Three dots menu icon
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Horizontal Track List
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 20.0),
            child: Text(
              "New Releases for you",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 210, // Height of the horizontal list
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: musicProvider.topTracks!.length,
              itemBuilder: (context, index) {
                spotify.PlaylistSimple track = musicProvider.topTracks![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        child: track.images != null && track.images!.isNotEmpty
                            ? Image.network(
                                track.images!.first.url ?? "",
                                fit: BoxFit.cover,
                              )
                            : Container(),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: 100,
                        child: Text(
                          track.name ?? "",
                          style: TextStyle(
                              fontSize: 11,
                              color: const Color.fromARGB(255, 134, 134, 134)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


