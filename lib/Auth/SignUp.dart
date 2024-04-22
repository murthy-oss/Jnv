import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:jnvapp/AuthScreens/HomePage.dart';
import 'package:jnvapp/AuthScreens/SignUpMail.dart';
import 'package:jnvapp/Screen/onboardingProfile/onboardingProfilePage.dart';
import 'package:jnvapp/services/AuthFunctions.dart';


import '../Sizeconfig/Size_Config.dart';
import '../components/myButton.dart';
import '../components/mydivider.dart';
import 'otpPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(children: [
          Container(
            height: SizeConfig.screenWidth * 0.7,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            child: Center(
              child: Transform.scale(
                scale: 1.2, // Adjust the scale factor as needed
                child: Image.asset(
                  "Assets/images/signup4.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenWidth * 0.05, vertical: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 250, bottom: 5),
                          child: TextFormField(
                            validator: (phone) {
                              if (phone!.isEmpty)
                                return "Please enter phone number";
                              else if (!RegExp(
                                      r"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$")
                                  .hasMatch(phone)) {
                                return "Please Enter the valid phone number";
                              }
                            },
                            obscureText: false,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.all(20),
                              hintText: 'Phone Number',
                              hintStyle: GoogleFonts.aladin(),
                              fillColor: Color(0xFFF2F2F2),
                              filled: true,
                              focusColor: Color(0xffd8c8ea),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            controller: _phoneController,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: width * 0.02,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //Sign in Button
                          Padding(
                            padding: const EdgeInsets.only(top: 1.0),
                            child: MyButton(
                                onTap: () async {
                                  final phone = _phoneController.text.trim();
                                  if (phone.isNotEmpty) {
                                    await FirebaseAuth.instance
                                        .verifyPhoneNumber(
                                      phoneNumber: '+91$phone',
                                      verificationCompleted:
                                          (PhoneAuthCredential credential) {
                                        // Auto verification
                                      },
                                      verificationFailed:
                                          (FirebaseAuthException e) {
                                        print(
                                            'Verification Failed: ${e.message}');
                                      },
                                      codeSent: (String verificationId,
                                          int? resendToken) {
                                        setState(() {
                                          _verificationId = verificationId;
                                        });
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: Duration(
                                                milliseconds:
                                                    500), // Adjust duration as needed
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                OTPScreen(
                                              phone: phone,
                                              verificationId: verificationId,
                                            ),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              var begin = Offset(0.0, 1.0);
                                              var end = Offset.zero;
                                              var curve = Curves.ease;

                                              var tween =
                                                  Tween(begin: begin, end: end)
                                                      .chain(
                                                CurveTween(curve: curve),
                                              );

                                              return SlideTransition(
                                                position:
                                                    animation.drive(tween),
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      codeAutoRetrievalTimeout:
                                          (String verificationId) {
                                        // Auto retrieval timeout
                                      },
                                    );
                                  }
                                },
                                text: 'Next',
                                color: Color(0xFF888BF4)),
                          ),
                          SizedBox(
                            height: width * 0.05,
                          ),
                          myDivider(),
                          SizedBox(
                            height: width * 0.08,
                          ),
                          //Signup button
                          Center(
                            child: Text(
                              "OR LOG IN BY",
                              style: GoogleFonts.aladin(fontSize: 17),
                            ),
                          ),
                          SizedBox(
                            height: width * 0.04,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: (){
                                   AuthService.signInWithGoogle();
                                   checkUserSignInStatus();
                  
                                },
                                child: CircleAvatar(
                                    radius: 25,
                                    child: Icon(
                                      AntDesign.google_circle_fill,
                                      color: Color(0xFF888BF4),
                                      size: 35,
                                    )),
                              ),
                              GestureDetector(
                                onTap: (){
                                    AuthService.signInWithFacebook();
                 checkUserSignInStatus();
                  

                                },
                                child: CircleAvatar(
                                    radius: 25,
                                    child: Icon(
                                      AntDesign.facebook_fill,
                                      color: Color(0xFF888BF4),
                                      size: 35,
                                    )),
                              ),
                              GestureDetector(
                             onTap: (){
                              Navigator.push(
                            
                             context, 
                             MaterialPageRoute(
                              builder: (context)=>SignUpMail()));
                             },
                                child: CircleAvatar(
                                    radius: 25,
                                    child: Icon(
                                      Icons.email,
                                      color: Color(0xFF888BF4),
                                      size: 35,
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: width * 0.1,
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   PageRouteBuilder(
                              //     transitionDuration: Duration(
                              //         milliseconds:
                              //             500), // Adjust duration as needed
                              //     pageBuilder:
                              //         (context, animation, secondaryAnimation) =>
                              //             TermsAndConditionsPage(),
                              //     transitionsBuilder: (context, animation,
                              //         secondaryAnimation, child) {
                              //       var begin = Offset(0.0, 1.0);
                              //       var end = Offset.zero;
                              //       var curve = Curves.ease;
                              //
                              //       var tween =
                              //           Tween(begin: begin, end: end).chain(
                              //         CurveTween(curve: curve),
                              //       );
                              //
                              //       return SlideTransition(
                              //         position: animation.drive(tween),
                              //         child: child,
                              //       );
                              //     },
                              //   ),
                              // );
                            },
                            child: Text("Terms and Conditions",
                                style: GoogleFonts.aladin(
                                  color: Color(0xFF888BF4),
                                  fontWeight: FontWeight.w600,
                                  fontSize: width * 0.05,
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
  Future<void> checkUserSignInStatus() async {
  FirebaseAuth auth = FirebaseAuth.instance;

  // Get the current user
  User? user = auth.currentUser;

  if (user != null) {
    // The user is signed in
    print('User is signed in: ${user.uid}');
    Navigator.push(
  context,
  MaterialPageRoute(builder: (context) =>  SetUpProfile()),
);

  } else {
    // The user is not signed in
    print('User is not signed in');
  }
}

}
