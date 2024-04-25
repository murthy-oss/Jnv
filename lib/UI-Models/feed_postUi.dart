import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share/share.dart';
import 'Comment.dart';
import '../Services/FireStoreMethod.dart';
import '../Widgets/TextLinkWidget.dart';
import '../Widgets/shimmerWidget.dart';
import '../components/myButton.dart';
import '../other/report.dart';
import '../Models/likegetx.dart';

class PostCard extends StatefulWidget {
  final String username;
  final List<dynamic> likes;
  final Timestamp time;
  final String profilePicture;
  final String image;
  final String description;
  final String postId;
  final String uid;
  final String comments;

  PostCard({
    required this.username,
    required this.likes,
    required this.time,
    required this.profilePicture,
    required this.image,
    required this.description,
    required this.postId,
    required this.uid,
    required this.comments,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final postController = Get.put(PostController());
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void _openImageFullScreen(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain, // Adjust image size to fit the dialog
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference commentsRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments');

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return ShimmerPostCard(); // Assuming you have a shimmer loading widget
        }

        var postData = snapshot.data!.data() as Map<String, dynamic>;
        List<dynamic> postLikes = postData['likes'];
        bool isLiked =
        postLikes.contains(currentUser!.phoneNumber.toString());

        return GetBuilder<PostController>(
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
                  child: Container(
                    color: Colors.grey[200],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 20.0,
                              backgroundImage:
                              CachedNetworkImageProvider(widget.profilePicture),
                            ),
                            SizedBox(width: 10.0),
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         ProfileScreen(uid: widget.uid),
                                //   ),
                                // );
                              },
                              child: Text(
                                widget.username,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.0,
                                  color: Color(0xFF888BF4),
                                ),
                              ),
                            ),
                          ],
                        ),
                        DropdownButton<String>(
                          icon: Icon(Icons.more_vert),
                          items: currentUser != null &&
                              currentUser!.uid == widget.uid
                              ? <DropdownMenuItem<String>>[
                            DropdownMenuItem(
                                value: 'Delete', child: Text('Delete')),
                            DropdownMenuItem(
                                value: 'Edit', child: Text('Edit')),
                          ]
                              : <DropdownMenuItem<String>>[
                            DropdownMenuItem(
                                value: 'Report', child: Text('Report')),
                          ],
                          onChanged: (String? newValue) async {
                            if (newValue == 'Delete') {
                              await FireStoreMethods().deletePost(widget.postId);
                            } else if (newValue == 'Report') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReportPostScreen(
                                    uid: widget.uid,
                                    postId: widget.postId,
                                  ),
                                ),
                              );
                            } else if (newValue == 'Edit') {
                              postController.toggleEditing(
                                  widget.postId, true);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return GestureDetector(
                        onLongPress: () =>
                            _openImageFullScreen(context, widget.image),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: constraints.maxWidth *
                              1.2, // Set height equal to the image's width
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(widget.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Obx(() {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[200],
                    child: Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            postController.isLiking
                                ? CircularProgressIndicator()
                                : IconButton(
                              icon: Column(
                                children: [
                                  Icon(
                                    isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Color(0xFF888BF4),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 1.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          '${postLikes.length} ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.0,
                                            color: Color(0xFF888BF4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                if (postController.isLiking) return;
                                postController.setLiking(true);

                                await FireStoreMethods().likePost(
                                  widget.postId,
                                  FirebaseAuth.instance.currentUser!
                                      .phoneNumber
                                      .toString(),
                                  postLikes,
                                  widget.uid,
                                );

                                postController.setLiking(false);
                              },
                            ),
                            SizedBox(width: 12.0),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CommentsScreen(
                                          postId: widget.postId,
                                          image: widget.image,
                                          TargetUserId: widget.uid,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Icon(Icons.comment_outlined,
                                      color: Color(0xFF888BF4)),
                                ),
                                StreamBuilder<QuerySnapshot>(
                                  stream: commentsRef.snapshots(),
                                  builder: (context, commentsSnapshot) {
                                    if (commentsSnapshot.hasError) {
                                      return Text(
                                          'Error: ${commentsSnapshot.error}');
                                    }

                                    if (!commentsSnapshot.hasData ||
                                        commentsSnapshot.data == null) {
                                      return SizedBox.shrink();
                                    }

                                    int numComments =
                                        commentsSnapshot.data!.docs.length;

                                    return Text(
                                      '$numComments',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        color: Color(0xFF888BF4),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 18.0, left: 15),
                              child: IconButton(
                                onPressed: () {
                                  Share.share(
                                      'Check out this cool app!/username=${widget.username}');
                                },
                                icon: FaIcon(FontAwesomeIcons.share,
                                    color: Color(0xFF888BF4)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      postController.isEditing(widget.postId)
                          ? Column(
                        children: [
                          TextField(
                            controller: descriptionController,
                            decoration: InputDecoration(
                              hintText: 'Edit Description',
                            ),
                          ),
                          MyButton1(
                            onTap: () {
                              postController.updateDescription(
                                  widget.postId,
                                  descriptionController.text);
                            },
                            text: "Save",
                            color: Colors.blue,
                          )
                        ],
                      )
                          : LinkText(
                        description: widget.description,
                        IsShowingDes: postController.isShowingDescription(widget.postId),
                      ),
                      if (widget.description.length > 50)
                        TextButton(
                          onPressed: () {
                            postController.showDescription(
                                widget.postId,
                                !postController
                                    .isShowingDescription(widget.postId));
                          },
                          child: Text(
                            postController.isShowingDescription(widget.postId)
                                ? 'Show less'
                                : 'Show more',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Divider(),
              ],
            );
          },
        );
      },
    );
  }
}
