import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatefulWidget {
  final String hint;
  final bool obscure;
  final bool selection;
  final FocusNode? focusNode;
  final TextEditingController controller;

  final IconData? suffixIcon; // Make suffixIcon optional
  final autofillhints;
  final FormFieldValidator<String>? validator; // Add validator
  final TextInputType keyboardtype;
  final Color? fillcolor;
  const MyTextField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.selection,
    this.focusNode,
     
    this.suffixIcon,
    this.autofillhints,
    this.validator,
    required this.keyboardtype,
    this.fillcolor, // Add validator parameter
// Update suffixIcon to be optional
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.9,
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 8.h),
        child: AutofillGroup(
          child: TextFormField(
              validator: widget.validator, // Set the validator

              autofillHints: widget.autofillhints,
              obscureText: _obscureText,
              keyboardType: widget.keyboardtype,
              decoration: InputDecoration(
                //focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.all(10.w),
                hintText: widget.hint,
             hintStyle:   TextStyle(
                                fontFamily: 'InterRegular',
                                color: Color.fromARGB(255, 173, 179, 189),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400),
                //prefixIcon: Icon(widget.preIcon),
                suffixIcon: widget.suffixIcon != null
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(_obscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      )
                    : null,
               
               
                              border: OutlineInputBorder(
                                 borderSide: BorderSide(
                                color: Color.fromARGB(255, 173, 179,
                                    189), // Specify the border color here
                                // width: 2.0, // Specify the border width here
                              ),
                              borderRadius: BorderRadius.circular(8.0.r),),
              ),
              controller: widget.controller,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              )),
        ),
      ),
    );
  }
}
