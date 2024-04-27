
import 'dart:io';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jnvapp/Auth/OTP%20SUCESS.dart';
import 'package:jnvapp/Auth/otpPage.dart';
import 'package:jnvapp/AuthScreens/NavodhyaSuccess.dart';

import 'package:jnvapp/Screen/Add%20Post/adddPost.dart';
import 'package:jnvapp/Screen/AppBar&BottomBar/Appbar&BottomBar.dart';
import 'package:jnvapp/Screen/SetUpNavodhya/Navodhya.dart';
import 'package:jnvapp/Screen/SetUpNavodhya/Navodhya3.dart';
import 'package:jnvapp/Screen/SetUpNavodhya/SetUpNavodhya1.dart';
import 'package:jnvapp/firebase_options.dart';
import 'package:jnvapp/Screen/ONboardingScreens/Onboarding.dart';
import 'package:jnvapp/firebase_options.dart';
import 'package:jnvapp/other/InvitePage.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'FetchDataProvider/fetchData.dart';
import 'components/Notifications.dart';



//import 'package:inst_clone_1/auth/mainPage.dart';
//import 'package:inst_clone_1/firebase_options.dart';

/*Future<User?> checkAuthenticationStatus() async {
  return FirebaseAuth.instance.authStateChanges().first;
}*/

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
 /* try {
 

    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCINRuerToLYoumEM7PBN-79oJNQs4twAk",
        appId: "1:586710635386:web:aea467e0fe846eb0453cc3",
        messagingSenderId: "586710635386",
        projectId: "gmrtest-5241f",
      ),
    );
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
      await Firebase.initializeApp();
    }
  }*/
 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserFetchController()),
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  var isLoggedIn = false;
  var auth = FirebaseAuth.instance;
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.foregroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }

      UserFetchController();
      checkIfLoggedIn();
    });
  }

  void checkIfLoggedIn() {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLoggedIn = true;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
  //FirebaseAuth auth = FirebaseAuth.instance;
  double width=MediaQuery.sizeOf(context).width;
  double height=MediaQuery.sizeOf(context).height;
  print(width);
  print(height);
  // Get the current user
  //User? user = auth.currentUser;

  return ScreenUtilInit(designSize: Size(width,height), 
minTextAdapt: true,
splitScreenMode: true,
builder: (context, child) => MaterialApp(
  debugShowCheckedModeBanner: false,
  home: child,

  
),

    child:  isLoggedIn ? HomeScreen() : Onboarding(),
  );
    
  }
}


