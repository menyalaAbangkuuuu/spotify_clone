import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart' as Spotify;
import 'package:spotify_clone/providers/category_provider.dart';
import 'package:spotify_clone/view/category_detail.dart';

class CategoryTiles extends StatelessWidget {
  const CategoryTiles({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    if (categoryProvider.categories == null ||
        categoryProvider.categories!.isEmpty) {
      return const Center(child: Text('Loading categories...'));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemCount: categoryProvider.categories?.length,
      itemBuilder: (context, index) {
        Spotify.Category? category = categoryProvider.categories?[index];

        return GestureDetector(
          onTap: () {
            context.pushNamed(
              CategoryDetailScreen.routeName,
              pathParameters: {
                'id': category?.id ?? "",
                'categoryName': category?.name ?? ""
              },
            );
          },
          child: GridTile(
              child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: NetworkImage(category?.icons?.first.url ?? ''),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6), BlendMode.darken)),
            ),
            child: Center(
              child: Text(
                category?.name ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ),
          )),
        );
      },
    );
  }
}
