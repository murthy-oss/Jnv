import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../FetchDataProvider/fetchData.dart';
import '../../Tabs/EventTab/EventTab.dart';
import '../../Tabs/FeedPaGE/FeedPage.dart';
import '../../Tabs/SearchTab/SearchTab.dart';
import '../../Widgets/Drawer/drawer.dart';
import '../Add Post/adddPost.dart';
import '../Chatting/chatPage.dart';
import '../Notifications/Notificationsd.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomeTab(),
    AddPostScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
    EventTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch user data immediately when HomeScreen is initialized

    Provider.of<UserFetchController>(context, listen: false).fetchUserData();
  }

  Uuid uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    var myUser = Provider.of<UserFetchController>(context).myUser;
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: CircleAvatar(
                radius: 17,
                backgroundImage: myUser != null && myUser.profilePicture != null
                    ? CachedNetworkImageProvider(myUser.profilePicture!)
                    : AssetImage('Assets/images/Avatar.png') as ImageProvider<Object>?,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title:  Text("Ts Bridge Edu",style: GoogleFonts.aladin(fontSize: 15),),
        actions: [
          Consumer<UserFetchController>(
            builder: (context, userController, _) {
              if (userController.isDataFetched) {
                // User data is fetched, you can access it here
                var myUser = userController.myUser;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    child: IconButton(
                      icon:  FaIcon(Bootstrap.chat_dots,size: MediaQuery.of(context).size.width*0.04),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return  RecentChatsPage();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              child: IconButton(
                icon:  FaIcon(Bootstrap.search,size:MediaQuery.of(context).size.width*0.04),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SearchPage();
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              child: IconButton(
                icon:  FaIcon(FontAwesomeIcons.bell,size:MediaQuery.of(context).size.width*0.04,),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Notifications();
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex], // Use directly from the list
      bottomNavigationBar: BottomNavigationBar(
        type:BottomNavigationBarType.fixed ,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        iconSize: 20,
        elevation: 1,
        items: [
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: FaIcon(Bootstrap.camera),
            label: 'Post',
          ),

          const BottomNavigationBarItem(
            icon: FaIcon(Clarity.event_outline_badged),
            label: 'Events',
          ),
        ],
      ),
    );
  }
}
