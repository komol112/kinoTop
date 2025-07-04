import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kino_top/models/movie_model.dart';
import 'package:kino_top/view/screens/detail_screen.dart';

class FavScreen extends StatelessWidget {
  const FavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Color(0xFF121011)
              : Colors.white,
      appBar: AppBar(
        title: Text(
          'liked_movies'.tr(),
          style: TextStyle(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Color(0xFF121011),
          ),
        ),
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? Color(0xFF121011)
                : Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('movies').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: Text(
                'no_liked_movies'.tr(),
                style: TextStyle(
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Color(0xFF121011),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final title = data['title'] ?? '';
              final posterPath = data['posterPath'] ?? '';
              final overview = data['overview'] ?? '';

              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DetailScreen(
                            isLike: true,
                            movie: Results(
                              posterPath: data["posterPath"],
                              title: data["title"],
                              overview: data["overview"],
                              originalTitle: data["originalTitle"],
                              releaseDate: data["releaseDate"],
                              voteAverage: data["voteAverage"],
                              originalLanguage: data["originalLanguage"],
                              backdropPath: data["backdropPath"],
                              popularity: data["popularity"],
                            ),
                          ),
                    ),
                  );
                  log("title : ${data["title"].toString()}");
                },
                leading: Image.network(
                  'https://image.tmdb.org/t/p/w200$posterPath',
                  width: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Color(0xFF121011),
                  ),
                ),
                subtitle: Text(
                  overview,
                  style: TextStyle(
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Color(0xFF121011),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
