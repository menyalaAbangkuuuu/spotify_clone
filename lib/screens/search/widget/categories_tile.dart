import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spotify/spotify.dart' as spotify;
import 'package:spotify_clone/providers/category_provider.dart';
import 'package:spotify_clone/view/category_detail.dart';

class CategoryTiles extends StatefulWidget {
  const CategoryTiles({super.key});

  @override
  State<CategoryTiles> createState() => _CategoryTilesState();
}

class _CategoryTilesState extends State<CategoryTiles> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        context.read<CategoryProvider>().canLoadMore == true) {
      context.read<CategoryProvider>().fetchMore(
          offset: context.read<CategoryProvider>().categories.length ~/ 8 * 9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, _) {
        if (categoryProvider.categories.isEmpty) {
          return const Center(child: Text('Loading categories...'));
        }
        return CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index >= categoryProvider.categories.length) {
                    return categoryProvider.canLoadMore
                        ? Center(
                            child: LoadingAnimationWidget.waveDots(
                                color: Colors.white.withOpacity(0.6), size: 48),
                          )
                        : const SizedBox.shrink();
                  }
                  spotify.Category? category =
                      categoryProvider.categories[index];
                  return GestureDetector(
                    onTap: () {
                      context.push(
                        '${CategoryDetailScreen.routeName}/${category.id ?? ""}/${category.name}',
                      );
                    },
                    child: GridTile(
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            width: double.infinity,
                            imageUrl: category.icons?.first.url ?? '',
                            fit: BoxFit.cover,
                            colorBlendMode: BlendMode.darken,
                            color: Colors.black.withOpacity(0.6),
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.black.withOpacity(.5),
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.black.withOpacity(.6),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          Center(
                            child: Text(
                              category.name ?? '',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: categoryProvider.categories.length + 1,
              ),
            ),
          ],
        );
      },
    );
  }
}
