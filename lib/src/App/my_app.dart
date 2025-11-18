import 'package:connectivity_bloc_emaple/src/features/catView/screen/cat_app.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: CatApp());
  }
}
