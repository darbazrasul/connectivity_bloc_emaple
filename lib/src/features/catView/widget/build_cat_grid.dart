import 'package:connectivity_bloc_emaple/src/features/catView/cubit/fetch_cats_cubit.dart';
import 'package:connectivity_bloc_emaple/src/features/catView/widget/cat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class BuildCatGrid extends StatefulWidget {
  final ScrollController scrollController;
  final List catList;
  bool isLoadingMore = false;

  BuildCatGrid({
    super.key,
    required this.scrollController,
    required this.catList,
    required this.isLoadingMore,
  });

  @override
  State<BuildCatGrid> createState() => _BuildCatGridState();
}

class _BuildCatGridState extends State<BuildCatGrid> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<FetchCatsCubit>().catList.clear();
        await context.read<FetchCatsCubit>().fetchCats();
      },
      child: CustomScrollView(
        controller: widget.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = widget.catList[index];
                return CatCard(imageUrl: item.url ?? '', index: index);
              }, childCount: widget.catList.length),
            ),
          ),
          if (widget.isLoadingMore)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 32,
                        width: 32,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Loading more...',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}
