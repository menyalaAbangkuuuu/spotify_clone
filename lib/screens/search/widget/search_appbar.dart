import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spotify_clone/providers/auth_provider.dart';
import 'package:spotify_clone/screens/common/main_screen.dart';

class SearchAppbar extends StatelessWidget {
  const SearchAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
              scaffoldKey.currentState?.openDrawer();
            },
            child:
                Consumer<AuthProvider>(builder: (context, userProvider, child) {
              if (userProvider.isLoading) {
                return const CircularProgressIndicator();
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
                  errorWidget: (context, url, error) => const SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: Icon(Icons.error),
                        ),
                      ));
            }),
          ),
          const SizedBox(width: 10),
          const Text(
            'Search',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      centerTitle: false,
    );
  }
}
