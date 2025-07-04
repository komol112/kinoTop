import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kino_top/models/movie_model.dart';
import 'package:kino_top/screens/detail_screen.dart';

class FavScreen extends StatelessWidget {
  const FavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Liked Movies", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('movies').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "Siz Kinolarga Like bosmagansiz",
                style: TextStyle(color: Colors.white),
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
                title: Text(title, style: TextStyle(color: Colors.white)),
                subtitle: Text(
                  overview,
                  style: TextStyle(color: Colors.white70),
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
