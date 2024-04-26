import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:jnvapp/Screen/AppBar&BottomBar/Appbar&BottomBar.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import '../FetchDataProvider/fetchData.dart';
import '../Services/FireStoreMethod.dart';
import '../components/myButton.dart';
import 'OTP SUCESS.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final String verificationId;

  OTPScreen({required this.phone, required this.verificationId});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _pinPutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 16.h,
            ),
            Center(
              child: Image.asset(
                //height:200.h,
                "Assets/images/verification2.png",
                fit: BoxFit
                    .fill, // Maintain aspect ratio while covering the container
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "OTP Verificaton",
                  style: TextStyle(
                      fontFamily: 'InterRegular',
                      color: Colors.black,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28.0, top: 15),
              child: Row(
                children: [
                  Text(
                    "Enter The OTP sent to ",
                    style: TextStyle(
                        fontFamily: 'InterRegular',
                        color: Color.fromARGB(255, 65, 65, 65),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "+91${widget.phone} ",
                    style: TextStyle(
                        fontFamily: 'InterRegular',
                        color: Color.fromARGB(255, 65, 65, 65),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Pinput(
                defaultPinTheme: PinTheme(
                    height: 80,
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(width: 1))),
                androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsRetrieverApi,
                length: 6,
                controller: _pinPutController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text(
                    "Didn't you recived the OTP?   ",
                    style: TextStyle(
                        fontFamily: 'InterRegular',
                        color: Color.fromARGB(255, 65, 65, 65),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () {
                      _resendOTP();
                    },
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(
                          fontFamily: 'InterRegular',
                          color: Color.fromARGB(255, 244, 66, 66),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _verifyOTP,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: MyButton(
                  onTap: () => _verifyOTP(),
                  text: "Verify",
                  color: Color.fromARGB(255, 244, 66, 66),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyOTP() async {
    String pin = _pinPutController.text.trim();
    if (pin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid OTP.")),
      );
      return;
    }

    try {
      // Verify OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: pin,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if the user exists and navigate accordingly
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? phoneNumber = user.phoneNumber;
        print(phoneNumber);
        if (phoneNumber != null) {
          bool isPhoneNumberRegistered =
              await isPhoneNumberAlreadyRegistered(phoneNumber);
          if (isPhoneNumberRegistered) {
            // Phone number is registered, navigate to home page
            Provider.of<UserFetchController>(context, listen: false)
                .fetchUserData();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {
            FireStoreMethods().createUser(
                userId: FirebaseAuth.instance.currentUser!.uid,
                name: '',
                dateOfBirth: '',
                gender: '',
                email: '',
                phoneNumber: '${FirebaseAuth.instance.currentUser!.phoneNumber}',
                aadharCardNumber: '',
                maritalStatus: '',
                occupation: '',
                section: '',
                state: '',
                district: '',
                schoolCampus: '',
                entryYear: '',
                entryClass: '',
                passOutYear: '',
                house: '',
                profilePicture: '',
                bio: '',
                achievements: '',
                instagramLink: '',
                linkedinLink: '',
                IsVerified: false,
                context: context);
            // Phone number is not registered, navigate to setup profile page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OTPSUCCESS()),
            );
          }
        } else {
          // Handle null phone number
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Phone number is null. Please try again.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User does not exist. Please try again.")),
        );
      }
    } catch (e) {
      // Handle verification failure
      print("Error verifying OTP: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to verify OTP. Please try again.")),
      );
    }
  }

  // Function to check if the phone number is already registered
  Future<bool> isPhoneNumberAlreadyRegistered(String phoneNumber) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking phone number registration: $e");
      return false;
    }
  }

  void _resendOTP() async {
    try {
      // Send OTP to the user's phone number again
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91${widget.phone}",
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-retrieve verification code if needed
          FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Failed to resend OTP: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to resend OTP. Please try again.")),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          // Show snackbar indicating OTP has been resent
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("OTP has been resent.")),
          );
          // Create a new instance of OTPScreen with the new verification ID
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                  phone: widget.phone, verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle code auto-retrieval timeout if needed
        },
        timeout: Duration(seconds: 60), // Timeout duration
      );
    } catch (e) {
      print("Error resending OTP: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to resend OTP. Please try again.")),
      );
    }
  }
}
