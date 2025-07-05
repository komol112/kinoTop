import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kino_top/models/movie_model.dart';
import 'package:kino_top/view/screens/detail_screen.dart';

class MyCardScreen extends StatefulWidget {
  const MyCardScreen({super.key});

  @override
  State<MyCardScreen> createState() => _MyCardScreenState();
}

class _MyCardScreenState extends State<MyCardScreen> {
  String selectedFilter = 'all';
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Color(0xFF121011)
              : Colors.white,
      appBar: AppBar(title: Text("My Movies")),
      body: Column(
        children: [
          const SizedBox(height: 10),
          filterTabs(),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getFilteredMoviesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No movies found"));
                }

                final movies = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading:
                            movie['posterPath'] != null
                                ? Image.network(
                                  'https://image.tmdb.org/t/p/w200${movie['posterPath']}',
                                  width: 50,
                                  fit: BoxFit.cover,
                                )
                                : const Icon(Icons.movie),
                        title: Text(movie['title'] ?? "No title"),
                        subtitle: Text("Status: ${movie['status']}"),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DetailScreen(
                                      movie: Results(
                                        posterPath: movie["posterPath"],
                                        id: movie['id'],
                                        voteAverage: movie["voteAverage"],
                                        popularity: movie["popularity"],
                                        overview: movie["overview"],
                                        releaseDate: movie["releaseDate"],
                                        title: movie["title"],
                                        originalLanguage:
                                            movie["originalLanguage"],
                                      ),
                                    ),
                              ),
                            );
                          },
                          icon: Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget filterTabs() {
    final filters = ['all', 'planned', 'watching', 'watched'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          filters.map((filter) {
            final isSelected = selectedFilter == filter;
            return TextButton(
              onPressed: () {
                setState(() {
                  selectedFilter = filter;
                });
              },
              style: TextButton.styleFrom(
                minimumSize: Size(0, 0),
                backgroundColor: isSelected ? Colors.red : Colors.transparent,
                foregroundColor: isSelected ? Colors.white : Colors.white,
              ),
              child: Text(filter[0].toUpperCase() + filter.substring(1)),
            );
          }).toList(),
    );
  }

  Stream<QuerySnapshot> getFilteredMoviesStream() {
    final moviesRef = FirebaseFirestore.instance.collection('movies');

    if (selectedFilter == 'all') {
      return moviesRef.where('userId', isEqualTo: userId).snapshots();
    } else {
      return moviesRef
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: selectedFilter)
          .snapshots();
    }
  }
}
