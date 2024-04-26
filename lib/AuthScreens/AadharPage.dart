import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jnvapp/Auth/OTP%20SUCESS.dart';
import 'package:jnvapp/AuthScreens/adhaarSuccess.dart';
import 'package:jnvapp/components/myButton.dart';
import 'package:jnvapp/components/myTextfield.dart';
import 'package:pinput/pinput.dart';

class AdhaarPage1 extends StatefulWidget {
  const AdhaarPage1({super.key});

  @override
  State<AdhaarPage1> createState() => _AdhaarPage1State();
}

class _AdhaarPage1State extends State<AdhaarPage1> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _aadhaarController = TextEditingController();
    final TextEditingController _pinPutController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    String? _validateAdhaar(String? value) {
      if (value == null || value.isEmpty || value.length < 10) {
        return 'Incorrect Adhaars';
      }

      return null;
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(
          "Aadhar Verification",
          style: TextStyle(
              fontSize: 16.sp,
              letterSpacing: 0.3,
              fontFamily: 'InterRegular',
              fontWeight: FontWeight.w500),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 46.5.w),
          child: SvgPicture.asset('Assets/images/Get started 1.svg'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Container(
              // width: 335.w,
              height: 54.h,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(
                      255, 173, 179, 189), // Specify the border color here
                  // width: 2.0, // Specify the border width here
                ),
                borderRadius: BorderRadius.circular(8.0.r),
              ),
              child: TextFormField(
                obscureText: true,
                validator: _validateAdhaar,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.w),
                  hintText: "Enter your Aadhar number",
                  hintStyle: TextStyle(
                    fontFamily: 'InterRegular',
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  suffix: GestureDetector(
                    onTap: () {
                      // Your onTap logic here
                      if (_validateAdhaar(_aadhaarController.text) == null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OTPSUCCESS()),
                        );
                      }
                      showModalBottomSheet<void>(
                          // context and builder are
                          // required properties in this widget
                          context: context,
                          builder: (BuildContext context) {
                            // we set up a container inside which
                            // we create center column and display text

                            // Returning SizedBox instead of a Container
                            return Container(
                              height: 390.h,
                              width: 390.h,
                              child: Padding(
                                padding: EdgeInsets.all(15.0.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 50.h,
                                    ),
                                    Text(
                                      'Enter 4 Digits Code',
                                      style: TextStyle(
                                          fontSize: 26.sp,
                                          fontFamily: 'InterRegular',
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'Enter the 4 digits code that you received on\nyour mobile number.',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: 'InterRegular',
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(20.0.w),
                                          child: Pinput(
                                            defaultPinTheme: PinTheme(
                                                height: 58.h,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 4.w),
                                                //s padding: EdgeInsets.symmetric(horizontal:16.w ),
                                                width: 58.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.r)),
                                                    border:
                                                        Border.all(width: 1))),
                                            androidSmsAutofillMethod:
                                                AndroidSmsAutofillMethod
                                                    .smsRetrieverApi,
                                            length: 4,
                                            controller: _pinPutController,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24.w, vertical: 20.h),
                                      child: MyButton3(
                                        textcolor: Colors.white,
                                        text: 'Continue',
                                        color: Color.fromARGB(255, 244, 66, 66),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdhaarSucess()),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 17, 85, 204),
                        border: Border.all(
                          color: const Color.fromARGB(255, 17, 85, 204),
                        ),
                        borderRadius: BorderRadius.circular(5.0.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 3.h),
                        child: Text(
                          "Get Code",
                          style: TextStyle(
                            fontSize: 16.sp,
                            letterSpacing: 0.3,
                            fontFamily: 'InterRegular',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                controller: _aadhaarController,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                ),
              )),
        ),
      ]),
    );
  }
}
