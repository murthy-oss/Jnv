import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../Screen/chats/chat_screen.dart';

import 'getx_chatsearch.dart'; // Import the SearchTabController

class RecentChatsPage extends StatefulWidget {
  const RecentChatsPage({Key? key}) : super(key: key);

  @override
  _RecentChatsPageState createState() => _RecentChatsPageState();
}

class _RecentChatsPageState extends State<RecentChatsPage> {
  late String currentUserUid;
  final SearchChat searchController = Get.put(SearchChat()); // Instantiate the SearchTabController
  bool showSearchResults = false; // Track whether to show search results or not
String id='';
  @override
  void initState() {
    super.initState();
    currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchBar(searchController.ChatSearch, () {
          searchController.ChatSearch(searchController.searchController.text);
          setState(() {
            showSearchResults = true; // Show search results when search button is pressed
          });
        }),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatRooms')
            .where('users', arrayContains: currentUserUid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.deepPurple));
          }

          List<DocumentSnapshot> chatRooms = snapshot.data!.docs;
          if (chatRooms.isEmpty) {
            return Center(child: Text('No recent chats'));
          }

          List<DocumentSnapshot> filteredChatRooms = chatRooms
              .where((room) => (room['users'] as List).contains(currentUserUid))
              .toList();

          if (filteredChatRooms.isEmpty) {
            return Center(child: Text('No recent chats with this user'));
          }

          return Column(
            children: [
              if (showSearchResults && searchController.searchResults.isNotEmpty)
                Card(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    children: searchController.searchResults.map((doc) {
                      String userName = doc['name'] ?? 'Unknown';
                      String UserProfile = doc['profilePicture'] ?? 'Unknown';

                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatRoomId: id, UserName: doc['name'], ProfilePicture: doc['profilePicture'], UId: doc['userId']),)),
                        child: Card(
                          color: Colors.grey[200],
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: CachedNetworkImageProvider(UserProfile ?? ''),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userName ?? '',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Tap to chat',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredChatRooms.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot room = filteredChatRooms[index];
                    String otherUserUid = (room['users'] as List).firstWhere((uid) => uid != currentUserUid);
id=room.id;
                    return UserTile(
                      uid: otherUserUid,
                      onTap: () {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(otherUserUid)
                            .get()
                            .then((userData) {
                          if (userData.exists) {
                            String userName = userData['name'] ?? 'Unknown';
                            String profilePicture = userData['profilePicture'] ?? '';
                            String UID = userData['userId'] ?? '';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  chatRoomId: room.id,
                                  UserName: userName,
                                  ProfilePicture: profilePicture,
                                  UId: UID,
                                ),
                              ),
                            );
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final String uid;
  final VoidCallback onTap;

  const UserTile({Key? key, required this.uid, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, userSnapshot) {
        if (userSnapshot.hasError) {
          return Text('Error: ${userSnapshot.error}');
        }

        if (!userSnapshot.hasData || userSnapshot.data == null) {
          return SizedBox.shrink();
        }

        var userData = userSnapshot.data!.data();
        if (userData == null || userData is! Map<String, dynamic>) {
          return SizedBox.shrink(); // Handle null or invalid data
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: InkWell(
            onTap: onTap,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: CachedNetworkImageProvider(userData['profilePicture'] ?? ''),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['name'] ?? '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tap to chat',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

typedef ChatSearchCallback = void Function(String query);

class SearchBar extends StatelessWidget {
  final ChatSearchCallback onSearchChanged;
  final VoidCallback onSearchPressed;

  const SearchBar(this.onSearchChanged, this.onSearchPressed);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: onSearchPressed,
        ),
      ],
    );
  }
}
