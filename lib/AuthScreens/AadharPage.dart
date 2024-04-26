import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jnvapp/components/myTextfield.dart';

class AdhaarPage1 extends StatefulWidget {
  const AdhaarPage1({super.key});

  @override
  State<AdhaarPage1> createState() => _AdhaarPage1State();
}

class _AdhaarPage1State extends State<AdhaarPage1> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _aadhaarController=TextEditingController();
    return Scaffold(


      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [ 
        Text("Aadhar Verification",
        style: TextStyle(
          fontSize: 16.sp,
          letterSpacing: 0.3,
          fontFamily: 'InterRegular',
          fontWeight: FontWeight.w500
        ),),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 46.5.w),
          child: SvgPicture.asset('assets/images/Get started 1.svg'),
        ),
         Container(
      width: 335.w,
    height: 54.h,
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 8.h),
        child: AutofillGroup(
          child: TextFormField(
             

             
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                //focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.all(10.w),
                hintText: "Enter your Aadhar number",
             hintStyle:   TextStyle(
                                fontFamily: 'InterRegular',
                                color: Color.fromARGB(255, 103, 114, 148),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400),
                //prefixIcon: Icon(widget.preIcon),
                
                 
               
                              border: OutlineInputBorder(
                                 borderSide: BorderSide(
                              // Specify the border color here
                                // width: 2.0, // Specify the border width here
                              ),
                              borderRadius: BorderRadius.circular(8.0.r),),
              ),
              controller: _aadhaarController,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              )),
        ),
      ),
    ),
        
      ]),
    );
  }
}