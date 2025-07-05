import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentsScreen extends StatefulWidget {
  final String movieId;

  const CommentsScreen({super.key, required this.movieId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _commentController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> sendComment() async {
    if (_commentController.text.trim().isEmpty || user == null) return;

    final commentText = _commentController.text.trim();

    final userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();

    final firstName = userDoc.data()?["firstName"] ?? "user";

    await FirebaseFirestore.instance
        .collection('comments')
        .doc(widget.movieId)
        .collection('messages')
        .add({
          'userId': user!.uid,
          'firstName': firstName,
          'text': commentText,
          'createdAt': FieldValue.serverTimestamp(),
        });

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comments")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('comments')
                      .doc(widget.movieId)
                      .collection('messages')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final comments = snapshot.data!.docs;

                if (comments.isEmpty) {
                  return Center(child: Text("No comments yet"));
                }

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final data = comments[index].data() as Map<String, dynamic>;

                    return ListTile(
                      leading: CircleAvatar(child: Icon(Icons.person)),
                      title: Text(data['firstName'] ?? 'Anonymous'),
                      subtitle: Text(data['text']),
                      trailing: Text(
                        (data['createdAt'] as Timestamp?)
                                ?.toDate()
                                .toLocal()
                                .toString()
                                .substring(0, 16) ??
                            '',
                        style: TextStyle(fontSize: 10),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: "Write a comment...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(icon: Icon(Icons.send), onPressed: sendComment),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
