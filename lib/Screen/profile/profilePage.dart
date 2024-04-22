import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Services/FireStoreMethod.dart';
import '../../UI-Models/feed_postUi.dart';
import '../../Widgets/TextLinkWidget.dart';
import '../../components/FolowButton.dart';
import '../../components/myButton.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import '../chats/chat_screen.dart';
import 'FollowerFollowingPage.dart';
import 'editProfile.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getStreamData();
  }

  getStreamData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .snapshots()
        .listen((userDataSnapshot) {
      if (userDataSnapshot.exists) {
        userData = userDataSnapshot.data()!;
        setState(() {
          followers = userData['followers'].length;
          following = userData['following'].length;
          isFollowing = (userData['followers'] as List<dynamic>).any(
              (follower) =>
                  follower is Map<String, dynamic> &&
                  follower['uid'] == FirebaseAuth.instance.currentUser!.uid);
        });
      }
    });

    FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: widget.uid)
        .snapshots()
        .listen((postSnapshot) {
      setState(() {
        postLen = postSnapshot.docs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (FirebaseAuth.instance.currentUser!.uid == userData['uuid'])
            IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(),
                    )),
                icon: FaIcon(Icons.settings))
        ],
        backgroundColor: Color(0xFF888BF4),
        title: Text(
          "@${userData['name'] ?? ''}",
          style: GoogleFonts.aladin(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              children: [
                // Profile Picture and Name Section
                Column(
                  children: [
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: CachedNetworkImageProvider(
                        userData['profilePhotoUrl'] ?? '',
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "@${userData['name'] ?? ''}",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // Stats and Follow/Following Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildStatColumn(postLen, "Posts"),
                    GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return FollowFollowing1(uid: userData['uuid']);
                              },
                            )),
                        child: buildStatColumn(followers, "Followers")),
                    GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return FollowFollowing(uid: userData['uuid']);
                              },
                            )),
                        child: buildStatColumn(following, "Following")),
                  ],
                ),

                SizedBox(height: 24),
                FirebaseAuth.instance.currentUser!.uid == widget.uid
                    ? FollowButton(
                        text: 'Edit Profile',
                        backgroundColor: Color(0xFF888BF4),
                        textColor: primaryColor,
                        borderColor: Colors.grey,
                        function: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(),
                            ),
                          );
                        },
                      )
                    : isFollowing
                        ? FollowButton(
                            text: 'Unfollow',
                            backgroundColor: Colors.red,
                            textColor: Colors.black,
                            borderColor: Colors.grey,
                            function: () async {
                              FireStoreMethods().unfollowUser(
                                FirebaseAuth.instance.currentUser!.uid,
                                userData['uuid'],
                              );
                            },
                          )
                        : FollowButton(
                            text: 'Follow',
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            borderColor: Colors.blue,
                            function: () async {
                              FireStoreMethods().followUser(
                                FirebaseAuth.instance.currentUser!.uid,
                                userData['uuid'],
                              );
                            },
                          ),

                // Bio and Additional Information Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bio:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey[300],
                          child: Text(
                            userData['bio'] ?? '',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(height: 8),
                        if(userData['showEmail']==true)      Row(
                          children: [
                            Icon(Icons.email, color: Colors.blue),
                            SizedBox(width: 8),

                            Text(
                              "Email: ${userData['email'] ?? ''}",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        if(userData['showLinkedin']==true) Row(
                          children: [
                            Icon(FontAwesomeIcons.linkedin,
                                color: Colors.blue),
                            SizedBox(width: 5),

                            LinkText1(
                              description:
                                  "${userData['LinkedIn'] ?? 'LinkedIn :'}",
                              IsShowingDes: true,
                            ),
                          ],
                        ) ,
                        SizedBox(height: 16),

                        if(userData['showPhone']==true)  Row(
                          children: [
                            Icon(FontAwesomeIcons.linkedin,
                                color: Colors.blue),
                            SizedBox(width: 5),
                            LinkText1(
                              description:
                                  "${userData['phoneNumber'] ?? 'phoneNumber :'}",
                              IsShowingDes: true,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),

                Divider(),

                // User Posts Grid
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: userData['uuid'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap = snapshot.data!.docs[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Scaffold(
                                    appBar: AppBar(
                                      title: Text('Posts'),
                                      backgroundColor: Color(0xFF888BF4),
                                    ),
                                    body: PostCard(
                                      username: snap['username'],
                                      likes: snap['likes'],
                                      time: snap['datePublished'],
                                      profilePicture: snap['profImage'],
                                      image: snap['postUrl'],
                                      description: snap['description'],
                                      postId: snap['postId'],
                                      uid: snap['uid'],
                                      comments: '',
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: FadeInImage(
                            fadeInDuration: Duration(milliseconds: 100),
                            filterQuality: FilterQuality.high,
                            placeholder:
                                AssetImage('Assets/images/onboarding1.png'),
                            image: CachedNetworkImageProvider(
                                snap['postUrl'] ?? ''),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                ),

                SizedBox(height: 24),

                // Message Button
                buildMessageButton(),
              ],
            ),
    );
  }

  Widget buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget buildMessageButton() {
    return FirebaseAuth.instance.currentUser!.uid != widget.uid
        ? MyButton1(
            onTap: () {
              createChatRoom();
            },
            text: "Message",
            color: Colors.blue,
          )
        : SizedBox();
  }

  void createChatRoom() {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    String targetUserUid = userData['uuid'];
    String targetUserName = userData['name'] ?? '';
    String targetUserProfile = userData['profilePhotoUrl'] ?? '';

    // Create a unique chat room ID based on user UIDs
    String chatRoomId = currentUserUid.hashCode <= targetUserUid.hashCode
        ? '$currentUserUid-$targetUserUid'
        : '$targetUserUid-$currentUserUid';

    // Check if the chat room already exists
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .get()
        .then((chatRoomSnapshot) {
      if (chatRoomSnapshot.exists) {
        // Chat room already exists, navigate to chat screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatRoomId: chatRoomId,
              UserName: targetUserName,
              ProfilePicture: targetUserProfile,
              UId: targetUserUid,
            ),
          ),
        );
      } else {
        // Chat room doesn't exist, create and navigate to chat screen
        FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId).set({
          'users': [currentUserUid, targetUserUid],
          'createdAt': FieldValue.serverTimestamp(),
          'recentMessage': ""
        }).then((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                chatRoomId: chatRoomId,
                UserName: targetUserName,
                ProfilePicture: targetUserProfile,
                UId: targetUserUid,
              ),
            ),
          );
        });
      }
    });
  }
}
