import 'package:connectivity_bloc_emaple/src/features/catView/cubit/fetch_cats_cubit.dart';
import 'package:connectivity_bloc_emaple/src/features/catView/widget/build_cat_grid.dart';
import 'package:connectivity_bloc_emaple/src/features/shared/widget/build_empty_state.dart';
import 'package:connectivity_bloc_emaple/src/features/shared/widget/build_initial_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatApp extends StatefulWidget {
  const CatApp({super.key});

  @override
  State<CatApp> createState() => _CatAppState();
}

class _CatAppState extends State<CatApp> {
  late final ScrollController _scrollController;
  bool _isLoadingMore = false;

  void _scrollListener() async {
    if (_isLoadingMore) return;

    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.offset >= threshold) {
      setState(() => _isLoadingMore = true);
      await context.read<FetchCatsCubit>().fetchCats();
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchCatsCubit>().fetchCats();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FetchCatsCubit, FetchCatsState>(
      listener: (context, state) {
        if (state is FetchCatsNoInternet) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(child: Text('No internet connection')),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<FetchCatsCubit>();
        final catList = cubit.catList;
        final isEmpty = catList.isEmpty;
        final isInitialLoading = state is FetchCatsLoading && isEmpty;

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: const Text(
              'Cat Gallery',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  cubit.catList.clear();
                  cubit.fetchCats();
                },
                tooltip: 'Refresh',
              ),
            ],
          ),
          body: isInitialLoading
              ? _buildInitialLoading()
              : isEmpty
              ? _buildEmptyState()
              : _buildCatGrid(catList),
        );
      },
    );
  }

  Widget _buildInitialLoading() {
    return const BuildInitialLoading();
  }

  Widget _buildEmptyState() {
    return const BuildEmptyState();
  }

  Widget _buildCatGrid(List catList) {
    return BuildCatGrid(
      catList: catList,
      isLoadingMore: _isLoadingMore,
      scrollController: _scrollController,
    );
  }
}
