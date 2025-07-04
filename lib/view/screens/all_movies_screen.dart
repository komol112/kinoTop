import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kino_top/view/utils/widgets.dart';
import 'package:kino_top/view_model/movie_provider.dart';
import 'package:provider/provider.dart';

class AllMoviesScreen extends StatefulWidget {
  const AllMoviesScreen({super.key});

  @override
  State<AllMoviesScreen> createState() => _AllMoviesScreenState();
}

class _AllMoviesScreenState extends State<AllMoviesScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<MovieProvider>();
      log("aall movies keldi!!!");
      provider.getAllMovies();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        final provider = context.read<MovieProvider>();
        provider.getAllMovies();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Movies")),
      body: getAllMoviesScrolWidget(scrollController: _scrollController),
    );
  }
}

