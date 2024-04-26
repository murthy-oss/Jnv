// ignore_for_file: sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import 'package:jnvapp/AuthScreens/SignUpMail.dart';
import 'package:jnvapp/AuthScreens/idAuthPage.dart';
import 'package:jnvapp/Screen/onboardingProfile/onboardingProfilePage.dart';
import 'package:jnvapp/components/MyToast.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 110.h,
              ),
              Center(
                  child: Text(
                "Welcome Back",
                style: TextStyle(
                    fontFamily: 'InterRegular',
                    color: Color.fromARGB(255, 27, 28, 30),
                    fontSize: 26.sp,
                    letterSpacing: 0.3.sp,
                    fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: 16.h,
              ),
              Center(
                  child: Column(
                children: [
                  Text(
                    "Log in to account using email or",
                    style: TextStyle(
                        fontFamily: 'InterRegular',
                        color: Color.fromARGB(255, 169, 162, 163),
                        fontSize: 16.sp,
                        letterSpacing: 0.3.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "social networks",
                    style: TextStyle(
                        fontFamily: 'InterRegular',
                        color: Color.fromARGB(255, 169, 162, 163),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              )),
              Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 51.h, bottom: 16.h,left: 14.w,right: 14.w),
                      child: TextFiledUiMethod('Phone Number'),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //Sign in Button
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: MyButton(
                              onTap: () async {
                                final phone = _phoneController.text.trim();
                                if (phone.isNotEmpty) {
                                  await FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber: '+91$phone',
                                    verificationCompleted:
                                        (PhoneAuthCredential credential) {
                                      // Auto verification
                                    },
                                    verificationFailed:
                                        (FirebaseAuthException e) {
                                      print('Verification Failed: ${e.message}');
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
                                          transitionsBuilder: (context, animation,
                                              secondaryAnimation, child) {
                                            var begin = Offset(0.0, 1.0);
                                            var end = Offset.zero;
                                            var curve = Curves.ease;
                        
                                            var tween =
                                                Tween(begin: begin, end: end)
                                                    .chain(
                                              CurveTween(curve: curve),
                                            );
                        
                                            return SlideTransition(
                                              position: animation.drive(tween),
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
                              text: 'OTP',
                              color: Color.fromARGB(255, 244, 66, 66)),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        myDivider(),
                        SizedBox(
                          height: width * 0.08,
                        ),
                        //Signup button
                          authbuttons("Login With ID", AntDesign.idcard_outline  ),
                        SizedBox(
                          height: 14.h,
                        ),
                        authbuttons("Login With Email", AntDesign.mail_fill ),
                        SizedBox(
                          height: 14.h,
                        ),
                        authbuttons(
                            "Login With Google", AntDesign.google_outline ),
                      
                      ],
                    )
                  ],
                ),
              ),
              //150.verticalSpace
            ],
          ),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don’t have an account?",
                  style: TextStyle(fontWeight: FontWeight.w400,   fontFamily:
                     'InterRegular',fontSize: 16.sp, color: const Color.fromARGB(255, 27, 28, 30),letterSpacing: 0.3.sp)),
                GestureDetector(
                  onTap: (){
                     Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUpMail()));
                  },
                  child: Text("Register",
                      style: TextStyle(fontWeight: FontWeight.w400,   fontFamily:
                       'InterRegular',fontSize: 16.sp, color: const Color.fromARGB(255, 244, 66, 66),letterSpacing: 0.3.sp)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget TextFiledUiMethod(String hint) {
    return Container(
                        width: 358.w,
                        height: 40.h,
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
                            contentPadding: EdgeInsets.all(10.w),
                            hintText: hint,
                            hintStyle: TextStyle(
                                fontFamily: 'InterRegular',
                                color: Color.fromARGB(255, 173, 179, 189),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 173, 179,
                                    189), // Specify the border color here
                                // width: 2.0, // Specify the border width here
                              ),
                              borderRadius: BorderRadius.circular(8.0.r),
                            ),
                          ),
                          controller: _phoneController,
                        ),
                      );
  }

  Widget authbuttons(String s, AntDesignIconData icon,  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.h),
      child: ElevatedButton(
        onPressed: () {
          if (s == 'Login With Email') {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUpMail()));
          } else if(s == 'Login With Google'){
            AuthService.signInWithGoogle();
            checkUserSignInStatus();
          }
          else{
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => IdAuthPagState()));
          }
        },
        child: SizedBox(
          width: 358.w,
          height: 44.h,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width:(s=='Login With Google')? 10.w:0.w,
                ),
                (s=='Login With Google')?
                SvgPicture.asset('Assets/images/google.svg',
                fit: BoxFit.fill,
                )
                :
                Icon(
                  icon ,
                  color: s!='Login With Google'?Colors.white:Colors.black,
                ),
                SizedBox(
                  width:s=='Login With Email'? 10.w:(s=='Login With ID')?10.w:10.w,
                ),
                Text(
                  s,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'InterRegular',
                    fontWeight: FontWeight.w400,
                    color: s!='Login With Google'?Colors.white:Colors.black,
                  ),
                ),
                 SizedBox(
                  width:(s=='Login With ID')?25.w:0.w,
                ),
              ],
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          // Use the determined color
          backgroundColor:(s=='Login With ID')? Color.fromARGB(255,17, 85, 205):(s=='Login With Email')?Colors.black:Colors.white,
          side: BorderSide(
            color: const Color.fromARGB(255, 173, 179, 189), // Border color
            // Border width
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0.r),
          ),
        ),
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
        MaterialPageRoute(builder: (context) => SetUpProfile()),
      );
    } else {
      // The user is not signed in
      print('User is not signed in');
    }
  }
}
