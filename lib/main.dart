import 'package:connectivity_bloc_emaple/src/App/my_app.dart';
import 'package:connectivity_bloc_emaple/src/features/catView/cubit/fetch_cats_cubit.dart';
import 'package:connectivity_bloc_emaple/src/features/catView/repo/cat_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  const service = CatApiService();
  runApp(
    BlocProvider(
      create: (context) => FetchCatsCubit(service),
      child: const MainApp(),
    ),
  );
}
