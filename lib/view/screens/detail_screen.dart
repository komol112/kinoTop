// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kino_top/models/movie_model.dart';
import 'package:kino_top/view/screens/comments_screen.dart';

class DetailScreen extends StatefulWidget {
  Results movie;
  DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  String? selectedStatus;
  bool isLiked = false;

  String get movieDocId => '${userId}_${widget.movie.id}';

  @override
  void initState() {
    super.initState();
    fetchLikeStatus();
    fetchStatus();
  }

  Future<void> fetchLikeStatus() async {
    final doc =
        await FirebaseFirestore.instance.collection('likes').doc(userId).get();
    if (doc.exists) {
      setState(() {
        isLiked = doc.data()?[widget.movie.id.toString()] ?? false;
      });
    }
  }

  Future<void> fetchStatus() async {
    if (userId == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('movies')
            .doc(movieDocId)
            .get();
    if (doc.exists) {
      setState(() {
        selectedStatus = doc.data()?['status'];
      });
    }
  }

  Future<void> toggleLike() async {
    if (userId == null) return;

    setState(() {
      isLiked = !isLiked;
    });

    final likesRef = FirebaseFirestore.instance.collection('likes').doc(userId);
    final moviesRef = FirebaseFirestore.instance.collection('movies');

    if (isLiked) {
      // Yoqtirildi: likes va movies kolleksiyasiga qo‘shamiz
      await likesRef.set({
        widget.movie.id.toString(): true,
      }, SetOptions(merge: true));

      await moviesRef.doc(movieDocId).set({
        'id': widget.movie.id,
        'title': widget.movie.title,
        'posterPath': widget.movie.posterPath,
        'overview': widget.movie.overview,
        'voteAverage': widget.movie.voteAverage,
        'popularity': widget.movie.popularity,
        'releaseDate': widget.movie.releaseDate,
        'originalLanguage': widget.movie.originalLanguage,
        'userId': userId,
        'status': selectedStatus,
      }, SetOptions(merge: true));
    } else {
      // Yoqtirish olib tashlandi: likes'dan o‘chiramiz va movies'dan ham o‘chiramiz
      await likesRef.update({widget.movie.id.toString(): FieldValue.delete()});

      await moviesRef.doc(movieDocId).delete();
    }
  }

  Future<void> updateStatus(String status) async {
    if (userId == null) return;

    setState(() {
      selectedStatus = status;
    });

    await FirebaseFirestore.instance.collection('movies').doc(movieDocId).set({
      'id': widget.movie.id,
      'title': widget.movie.originalTitle,
      'posterPath': widget.movie.posterPath,
      'overview': widget.movie.overview,
      'voteAverage': widget.movie.voteAverage,
      'popularity': widget.movie.popularity,
      'releaseDate': widget.movie.releaseDate,
      'originalLanguage': widget.movie.originalLanguage,
      'userId': userId,
      'status': status,
    }, SetOptions(merge: true));
  }

  String statusLabel(String status) {
    switch (status) {
      case 'planned':
        return 'Planned';
      case 'watched':
        return 'Watched';
      case 'unwatched':
        return 'Watching';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF121011) : Colors.white,
      body: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
              height: 450,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Icon(Icons.broken_image),
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor:
                        isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: isDark ? Colors.grey.shade200 : Colors.grey.shade900,
                  ),
                ),
                Spacer(),
                PopupMenuButton<String>(
                  style: IconButton.styleFrom(
                    backgroundColor:
                        isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                  ),
                  icon: Icon(
                    Icons.more_vert,
                    color: isDark ? Colors.grey.shade200 : Colors.grey.shade900,
                  ),
                  onSelected: updateStatus,
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(value: 'planned', child: Text("Planned")),
                        PopupMenuItem(value: 'watched', child: Text("Watched")),
                        PopupMenuItem(
                          value: 'unwatched',
                          child: Text("Watching"),
                        ),
                      ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  widget.movie.title ?? "trailer",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color:
                                        isDark
                                            ? Colors.grey.shade200
                                            : Colors.grey.shade900,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                widget.movie.voteAverage.toString(),
                                style: TextStyle(
                                  color:
                                      isDark
                                          ? Colors.grey.shade200
                                          : Colors.grey.shade900,
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
                                  'watch_trailer'.tr(),
                                  style: TextStyle(
                                    color:
                                        isDark
                                            ? Colors.grey.shade900
                                            : Colors.grey.shade200,
                                  ),
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
                              SizedBox(
                                width: 147.6.w,
                                child: Text(
                                  maxLines: 1,
                                  'censor_raiting'.tr(),
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,

                                    color:
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey.shade200
                                            : Colors.grey.shade900,
                                  ),
                                ),
                              ),
                              Row(
                                spacing: 5,
                                children: [
                                  Icon(Icons.star, color: Colors.amber),
                                  Text(
                                    "${widget.movie.voteAverage ?? "0"}",
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.grey.shade200
                                              : Colors.grey.shade900,
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
                              SizedBox(
                                width: 105.w,
                                child: Text(
                                  maxLines: 1,
                                  'popularity'.tr(),
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color:
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey.shade200
                                            : Colors.grey.shade900,
                                  ),
                                ),
                              ),
                              Text(
                                widget.movie.popularity.toString(),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey.shade200
                                          : Colors.grey.shade900,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 117.w,
                                child: Text(
                                  maxLines: 1,
                                  'relase_date'.tr(),
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color:
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey.shade200
                                            : Colors.grey.shade900,
                                  ),
                                ),
                              ),
                              Text(
                                widget.movie.releaseDate.toString(),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey.shade200
                                          : Colors.grey.shade900,
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
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'awailable in languages :'.tr(),
                                    style: TextStyle(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  Text(
                                    widget.movie.originalLanguage.toString(),
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  toggleLike();
                                },
                                icon: Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isLiked ? Colors.red : Colors.grey,
                                ),
                              ),
                              SizedBox(width: 20.w),
                            ],
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          if (selectedStatus != null)
                            Text(
                              "Status: ${statusLabel(selectedStatus!)}",
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => CommentsScreen(
                                        movieId: widget.movie.id.toString(),
                                      ),
                                ),
                              );
                            },
                            child: Text(
                              "Comments",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),

                      Divider(),
                      Text(
                        "Story Plot",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color:
                              isDark
                                  ? Colors.grey.shade200
                                  : Colors.grey.shade900,
                        ),
                      ),
                      Text(
                        widget.movie.overview.toString(),
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w200,
                          color:
                              isDark
                                  ? Colors.grey.shade200
                                  : Colors.grey.shade900,
                        ),
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
                        foregroundColor:
                            isDark
                                ? Colors.grey.shade200
                                : Colors.grey.shade900,
                        minimumSize: Size(double.infinity, 60),
                      ),
                      onPressed: () {},
                      child: Text('book_tickets'),
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

  Widget buildInfoColumn(
    String title,
    IconData? icon,
    String value,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.grey.shade200 : Colors.grey.shade900,
          ),
        ),
        Row(
          children: [
            if (icon != null) Icon(icon, color: Colors.amber),
            SizedBox(width: 5),
            Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.grey.shade200 : Colors.grey.shade900,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
