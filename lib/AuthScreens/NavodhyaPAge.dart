// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:jnvapp/Auth/OTP%20SUCESS.dart';
// import 'package:jnvapp/AuthScreens/NavodhyaSuccess.dart';
// import 'package:jnvapp/AuthScreens/adhaarSuccess.dart';
// import 'package:jnvapp/components/myButton.dart';
// import 'package:jnvapp/components/myTextfield.dart';
// import 'package:pinput/pinput.dart';
//
// class NAvodhyaPage extends StatefulWidget {
//   const NAvodhyaPage({super.key});
//
//   @override
//   State<NAvodhyaPage> createState() => _AdhaarPage1State();
// }
//
// class _AdhaarPage1State extends State<NAvodhyaPage> {
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController _aadhaarController = TextEditingController();
//     final TextEditingController _pinPutController = TextEditingController();
//     final _formKey = GlobalKey<FormState>();
//     final _emailController = TextEditingController();
//     String? _validateAdhaar(String? value) {
//       if (value == null || value.isEmpty || value.length < 10) {
//         return 'Incorrect Adhaars';
//       }
//
//       return null;
//     }
//
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//         Text(
//           "Navodhya Verification",
//           style: TextStyle(
//               fontSize: 16.sp,
//               letterSpacing: 0.3,
//               fontFamily: 'InterRegular',
//               fontWeight: FontWeight.w500),
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 46.5.w),
//           child: SvgPicture.asset('Assets/images/Get started 1.svg'),
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 14.w),
//           child: Container(
//             // width: 335.w,
//               height: 54.h,
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Color.fromARGB(
//                       255, 173, 179, 189), // Specify the border color here
//                   // width: 2.0, // Specify the border width here
//                 ),
//                 borderRadius: BorderRadius.circular(8.0.r),
//               ),
//               child: TextFormField(
//                 obscureText: true,
//                 validator: _validateAdhaar,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.all(10.w),
//                   hintText: "Enter your Navodhya number",
//                   hintStyle: TextStyle(
//                     fontFamily: 'InterRegular',
//                     color: Colors.black,
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w400,
//                   ),
//
//                 ),
//                 controller: _aadhaarController,
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.w500,
//                 ),
//               )),
//         ),
//       ]),
//     );
//   }
// }
