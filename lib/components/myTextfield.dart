import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.only(bottom: 5),
        child: AutofillGroup(
          child: TextFormField(
              validator: widget.validator, // Set the validator

              autofillHints: widget.autofillhints,
              obscureText: _obscureText,
              keyboardType: widget.keyboardtype,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.all(20),
                hintText: widget.hint,
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
                fillColor: widget.fillcolor ?? Color(0xFFF2F2F2),
                filled: true,
                focusColor: Color(0xffd8c8ea),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15.0),
                ),
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
