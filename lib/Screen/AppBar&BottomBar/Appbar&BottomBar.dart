import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:jnvapp/Tabs/JobTab/JobTab.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../FetchDataProvider/fetchData.dart';
import '../../Tabs/Add Post/adddPost.dart';
import '../../Tabs/ChatTab/chatPage.dart';
import '../../Tabs/EventTab/EventTab.dart';
import '../../Tabs/FeedPaGE/FeedPage.dart';
import '../../Widgets/Drawer/drawer.dart';

import '../Add Post/adddPost.dart';
import '../Notifications/Notificationsd.dart';
import '../SearchPage/SearchTab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomeTab(),
    SearchPage(),
     AddPostScreen(uid:FirebaseAuth.instance.currentUser!.uid),
JobTab(),
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
        leading:Builder(
          builder: (BuildContext context) {
            return IconButton(
                  icon: CircleAvatar(
                    radius: 20.r,
                    backgroundImage: myUser != null && myUser.profilePicture != ''
                        ? CachedNetworkImageProvider(myUser.profilePicture!)
                        : AssetImage('Assets/images/Avatar.png') as ImageProvider<Object>?,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
          }
        ),
    title:  Text("J.N.V",style: GoogleFonts.inter(fontSize: 16.sp,fontWeight: FontWeight.w700),),
        actions: [
          Consumer<UserFetchController>(
            builder: (context, userController, _) {
              if (userController.isDataFetched) {
                // User data is fetched, you can access it here
                var myUser = userController.myUser;
                return IconButton(
                  icon:  FaIcon(Bootstrap.chat,color: Colors.black,size: 20.r),
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
                );
              } else {
                return Container();
              }
            },
          ),

          IconButton(
            icon:  FaIcon(FontAwesomeIcons.bell,color: Colors.black,size:20.r,),
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
        ],
      ),
      body: _pages[_selectedIndex], // Use directly from the list
      bottomNavigationBar: BottomNavigationBar(
        type:BottomNavigationBarType.fixed ,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFFF44242),
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
showUnselectedLabels: false,
        iconSize: 20,
        elevation: 1,
        items: [
          const BottomNavigationBarItem(
            icon: FaIcon(AntDesign.home_outline),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.search),
            label: 'Search',
          ),
          const BottomNavigationBarItem(
            icon: FaIcon(Icons.add_circle_outline,),
            label: 'Post',
          ),

          const BottomNavigationBarItem(
            icon: FaIcon(Bootstrap.people),
            label: 'Jobs',
          ),   const BottomNavigationBarItem(
            icon: FaIcon(Clarity.event_outline_badged),
            label: 'Events',
          ),
        ],
      ),
    );
  }
}
