import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../Widgets/TextLinkWidget.dart';
import '../profile/profilePage.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String UserName;
  final String ProfilePicture;
  final String UId;


  const ChatScreen({Key? key, required this.chatRoomId, required this.UserName, required this.ProfilePicture, required this.UId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  late StreamController<QuerySnapshot>? _streamController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _streamController = StreamController<QuerySnapshot>();
    _fetchTargetUserInfo(); // Fetch the target user's info
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _streamController?.close();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // Implement any logic you need when scrolling reaches the bottom
    }
  }

  void _updateRecentMessage(String message, String senderUid) {
    FirebaseFirestore.instance.collection('chatRooms').doc(widget.chatRoomId).update({
      'recentMessage': message
    });
  }

  void _fetchMessages() {
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(widget.chatRoomId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
      if (_streamController != null && !_streamController!.isClosed) {
        _streamController!.add(snapshot); // Add the snapshot to the stream controller
      } else {
        _streamController = StreamController<QuerySnapshot>(); // Create a new stream controller
        _streamController!.add(snapshot); // Add the snapshot to the new stream controller
      }
    });
  }

  void _fetchTargetUserInfo() async {
    DocumentSnapshot roomSnapshot = await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(widget.chatRoomId)
        .get();

    List<String> users = List.from(roomSnapshot['users']);

    // Find the target user's UID
    // String targetUserUid = users.firstWhere((uid) => uid != FirebaseAuth.instance.currentUser!.uid);

    // DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(targetUserUid)
    //     .get();
  }

  void _sendMessage(String messageText, File? imageFile) async {
    if (messageText.isEmpty && imageFile == null) {
      return; // Return if both message text and image are empty
    }

    String? imageUrl;

    if (imageFile != null) {
      imageUrl = await _uploadImageToFirebase(imageFile);
    }

    _updateRecentMessage(messageText.trim(), FirebaseAuth.instance.currentUser!.uid);

    FirebaseFirestore.instance.collection('chatRooms').doc(widget.chatRoomId).collection('messages').add({
      'message': messageText,
      'senderUid': FirebaseAuth.instance.currentUser!.uid,
      'timestamp': Timestamp.now(),
      'imageUrl': imageUrl,
    });

    _messageController.clear();
  }

  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName.jpg');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      await _downloadImageToDevice(downloadUrl);
      return downloadUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

  Future<void> _downloadImageToDevice(String imageUrl) async {
    try {
      HttpClient client = HttpClient();
      var request = await client.getUrl(Uri.parse(imageUrl));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File('$dir/image.jpg');
      await file.writeAsBytes(bytes);
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _fetchMessages(); // Initial fetch of messages

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(uid: widget.UId),));
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(widget.ProfilePicture),
              ),
              SizedBox(width: 8),
              Text(widget.UserName),
            ],
          ),
        ),
        backgroundColor: Color(0xFF888BF4),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _streamController!.stream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  );
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                    // Check if the message sender is the current user
                    bool isCurrentUser = data['senderUid'] == FirebaseAuth.instance.currentUser!.uid;

                    return Row(
                      mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        BubbleMessage(
                          isCurrentUser: isCurrentUser,
                          sender: isCurrentUser ? 'You' : '',
                          targetUserName: isCurrentUser ? '' : widget.UserName,
                          text: data['message'],
                          imageUrl: data['imageUrl'],
                          timestamp: data['timestamp'],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageComposer(), // Pass context and image picker
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    final picker = ImagePicker();

    Future<void> _getImage(ImageSource source) async {
      final pickedFile = await picker.getImage(source: source);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        _sendMessage('', imageFile); // Send empty message and the selected image
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () async {
              await _getImage(ImageSource.camera);
            },
          ),
          IconButton(
            icon: Icon(Icons.photo),
            onPressed: () async {
              await _getImage(ImageSource.gallery);
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration.collapsed(hintText: 'Type a message...'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendMessage(_messageController.text.trim(), null); // Send only text message
            },
          ),
        ],
      ),
    );
  }
}

class BubbleMessage extends StatelessWidget {
  final bool isCurrentUser;
  final String sender;
  final String targetUserName; // Add this parameter
  final String text;
  final String? imageUrl;
  final Timestamp timestamp;

  const BubbleMessage({
    Key? key,
    required this.isCurrentUser,
    required this.sender,
    required this.targetUserName, // Update constructor to accept targetUserName
    required this.text,
    this.imageUrl,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat.yMd().add_jm().format(timestamp.toDate());
    // Format timestamp as a string representing date and time

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          color: isCurrentUser ? Colors.green[200] : Colors.grey[300],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isCurrentUser ? 'You' : targetUserName, // Show targetUserName instead of 'Other User'
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            if (imageUrl != null && imageUrl!.isNotEmpty) // Check if imageUrl is not null and not empty
              GestureDetector(
                onTap: () {
                  if (imageUrl != null && Uri.parse(imageUrl!).isAbsolute) {
                    _openImageFullScreen(context, imageUrl!);
                  } else {
                    print('Invalid image URL');
                  }
                },
                child: Image.network(
                  imageUrl!,
                  width: 200,
                ),
              ),
            if (text.isNotEmpty)
              LinkText(description: text, IsShowingDes: true),
            const SizedBox(height: 4),
            Text(
              formattedTime,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 10, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  void _openImageFullScreen(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}


