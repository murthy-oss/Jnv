import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:share/share.dart';

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
import 'package:jnvapp/other/Settings.dart';
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
          if (FirebaseAuth.instance.currentUser!.uid == userData['userId'])
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Settings1(Image: userData['profilePicture'], email: userData['email'], name: userData['name'],),
                  ),
                );
              },
              icon: FaIcon(FontAwesomeIcons.cog),
            ),
        ],
        title: Text(
          "J.N.V",
          style: GoogleFonts.inter(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              children: [
                // Profile Picture and Name Section
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 35.r,
                              backgroundImage: CachedNetworkImageProvider(
                                userData['profilePicture'] ?? '',
                              ),
                            ),
                            Text(
                              "${userData['name'] ?? ''}",
                              style: GoogleFonts.inter(
                                  fontSize: 17.sp, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildStatColumn(postLen, "Posts"),
                            SizedBox(
                              width: 20.w,
                            ),
                            GestureDetector(
                                onTap: () =>
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return FollowFollowing1(
                                            uid: userData['userId']);
                                      },
                                    )),
                                child: buildStatColumn(followers, "Followers")),
                            SizedBox(
                              width: 20.w,
                            ),
                            GestureDetector(
                                onTap: () =>
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return FollowFollowing(
                                            uid: userData['userId']);
                                      },
                                    )),
                                child: buildStatColumn(following, "Following")),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                // Bio and Additional Information Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData['bio'] ?? '',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          maxLines: 15,
                        ),
                        SizedBox(height: 8.h),
                        if (userData['showEmail'] == true)
                          Text(
                            "Email: ${userData['email'] ?? ''}",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        SizedBox(height: 10.h),
                        if (userData['showLinkedin'] == true)
                          LinkText1(
                            description:
                                "${userData['linkedinLink'] ?? 'LinkedIn :'}",
                            IsShowingDes: true,
                          ),
                        SizedBox(height: 10.h),
                        if (userData['showPhone'] == true)
                          LinkText1(
                            description:
                                "${userData['phoneNumber'] ?? 'phoneNumber :'}",
                            IsShowingDes: true,
                          ),
                        SizedBox(height: 10.h),
                        if (userData['instagramLink'] == true)
                          LinkText1(
                            description:
                                "${userData['phoneNumber'] ?? 'phoneNumber :'}",
                            IsShowingDes: true,
                          ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid == widget.uid
                                  ? MyButton1(
                                text: 'Edit Profile',

                                onTap: () {      Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfilePage(),
                                  ),
                                ); }, color: Colors.red,
                              )
                                  : isFollowing
                                  ? MyButton1(
                                text: 'Unfollow',

                                onTap: () =>      FireStoreMethods().unfollowUser(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  userData['uuid'],
                                ),color: Colors.red,
                              )
                                  : MyButton1(
                                text: 'Follow',
                            onTap: () =>   FireStoreMethods().followUser(
                              FirebaseAuth.instance.currentUser!.uid,
                              userData['uuid'],
                            ),color: Colors.red,
                              ),
                              MyButton1(
                                  onTap: () {
                                    Share.share('${userData['name']}');
                                  },
                                  text: 'Share Profile',
                                  color: Colors.red)
                            ],
                          ),
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
                      .where('uid', isEqualTo: userData['userId'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return GridView.builder(
                      padding: EdgeInsets.all(10),
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

                SizedBox(height: 24.h),

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
            color: Colors.red,
          )
        : SizedBox();
  }

  void createChatRoom() {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    String targetUserUid = userData['userId'];
    String targetUserName = userData['name'] ?? '';
    String targetUserProfile = userData['profilePicture'] ?? '';

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
          'recentMessage': "tap to chat"
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
