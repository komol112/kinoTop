// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kino_top/models/movie_model.dart';

class DetailScreen extends StatefulWidget {
  Results movie;
  DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isLike = false;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    fetchLikeStatus();
  }

  Future<void> fetchLikeStatus() async {
    if (userId == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('likes').doc(userId).get();

    if (doc.exists) {
      setState(() {
        isLike = doc.data()?[widget.movie.id.toString()] ?? false;
      });
    }
  }

  Future<void> toggleLike() async {
    if (userId == null) return;

    setState(() {
      isLike = !isLike;
    });

    final likesRef = FirebaseFirestore.instance.collection('likes').doc(userId);
    final moviesRef = FirebaseFirestore.instance.collection('movies');

    await likesRef.set({
      widget.movie.id.toString(): isLike,
    }, SetOptions(merge: true));

    if (isLike) {
      await moviesRef.doc(widget.movie.id.toString()).set({
        
        'id': widget.movie.id,
        'title': widget.movie.title,
        'posterPath': widget.movie.posterPath,
        'overview': widget.movie.overview,
        'voteAverage': widget.movie.voteAverage,
        'popularity': widget.movie.popularity,
        'releaseDate': widget.movie.releaseDate,
        'originalLanguage': widget.movie.originalLanguage,
      });
    } else {
      await moviesRef.doc(widget.movie.id.toString()).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121011),
      body: Stack(
        children: [
          Hero(
            tag: ValueKey(
              "https://image.tmdb.org/t/p/w500${widget.movie.posterPath}",
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              child: Image.network(
                height: 450,
                width: double.infinity,
                fit: BoxFit.cover,
                'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
              ),
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Color(0xFF1E1E1E),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios, color: Colors.grey.shade200),
                ),
                Spacer(),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Color(0xFF1E1E1E),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.menu, color: Colors.grey.shade200),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Color(0xFF1E1E1E),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Row(
                        spacing: 15,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  widget.movie.title ?? "trailer",
                                  style: TextStyle(
                                    color: Colors.grey.shade200,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                widget.movie.voteAverage.toString(),
                                style: TextStyle(
                                  color: Colors.grey.shade200,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF1E1E1E),
                                  Colors.grey.shade700,
                                  Colors.grey,
                                ],
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Watch trailer",
                                  style: TextStyle(color: Colors.grey.shade200),
                                ),
                                Icon(Icons.play_arrow_rounded),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Censor Raiting",
                                style: TextStyle(color: Colors.grey.shade200),
                              ),
                              Row(
                                spacing: 5,
                                children: [
                                  Icon(Icons.star, color: Colors.amber),
                                  Text(
                                    widget.movie.voteAverage.toString(),
                                    style: TextStyle(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Popularity",
                                style: TextStyle(color: Colors.grey.shade200),
                              ),
                              Text(
                                widget.movie.popularity.toString(),
                                style: TextStyle(color: Colors.grey.shade200),
                              ),
                            ],
                          ),
                          Column(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Relase Date",
                                style: TextStyle(color: Colors.grey.shade200),
                              ),
                              Text(
                                widget.movie.releaseDate.toString(),
                                style: TextStyle(color: Colors.grey.shade200),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Available in Language's",
                                style: TextStyle(color: Colors.grey.shade200),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  toggleLike();
                                },
                                icon: Icon(
                                  isLike
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isLike ? Colors.red : Colors.grey,
                                ),
                              ),
                              SizedBox(width: 20.w),
                            ],
                          ),
                          Text(
                            widget.movie.originalLanguage.toString(),
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      Divider(),
                      Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Story Plot",
                            style: TextStyle(
                              color: Colors.grey.shade200,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            maxLines: 4,
                            widget.movie.overview.toString(),
                            style: TextStyle(
                              color: Colors.grey.shade200,
                              fontSize: 13,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Color(0xFfEB2F3D),
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 60),
                      ),
                      onPressed: () {},
                      child: Text("Book Tickets"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
