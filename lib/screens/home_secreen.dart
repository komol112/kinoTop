import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kino_top/view_model/movie_provider.dart';
import 'package:provider/provider.dart';

class HomeSecreen extends StatefulWidget {
  const HomeSecreen({super.key});

  @override
  State<HomeSecreen> createState() => _HomeSecreenState();
}

class _HomeSecreenState extends State<HomeSecreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MovieProvider>().getMovie();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, movieprovider, child) {
        log(
          movieprovider.movieModel?.results?[0].title ??
              "malumot olishda xatolik",
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(
              movieprovider.movieModel?.results?[1].id.toString() ??
                  "malumot yoq",
            ),
          ),
        );
      },
    );
  }
}
