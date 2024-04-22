
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../UI-Models/feed_postUi.dart';
import '../../Widgets/ShimmerWidget.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  StreamController<QuerySnapshot>? _streamController;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<QuerySnapshot>();
    _fetchPosts();
  }

  void _fetchPosts() {
    FirebaseFirestore.instance.collection('posts').orderBy('datePublished',descending: true).snapshots().listen((snapshot) {
      if (_streamController != null && !_streamController!.isClosed) {
        _streamController!.add(snapshot); // Add the snapshot to the stream controller
      } else {
        _streamController = StreamController<QuerySnapshot>(); // Create a new stream controller
        _streamController!.add(snapshot); // Add the snapshot to the new stream controller
      }
    });
  }

  @override
  void dispose() {
    _streamController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _streamController?.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingShimmer(); // Show shimmer loading effect
          }

          List<QueryDocumentSnapshot> postDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: postDocs.length,
            itemBuilder: (context, index) {
              var post = postDocs[index].data() as Map<String, dynamic>;
              return PostCard(
                username: post['username'] ?? '',
                likes: post['likes'] ?? "0",
                time: post['datePublished'],
                profilePicture: post['profImage'] ?? '',
                image: post['postUrl'] ?? '',
                description: post['description'],
                postId: post['postId'],
                uid: post['uid'],
                comments: post['commentsCount'].toString(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 5, // Adjust this number as needed
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ShimmerPostCard(), // Use ShimmerPostCard instead of PostCard
        );
      },
    );
  }
}

