import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jnvapp/Screen/SetUpNavodhya/Navodhya3.dart';
import 'package:jnvapp/components/myButton.dart';

class SetUpNAvodhya1 extends StatefulWidget {
  const SetUpNAvodhya1({super.key});

  @override
  State<SetUpNAvodhya1> createState() => _SetUpNAvodhya1State();
}

class _SetUpNAvodhya1State extends State<SetUpNAvodhya1> {
  File? _image;
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Navodayan Verification',
            style: GoogleFonts.inter(fontSize: 18.sp),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(color: Colors.grey[100] ,elevation: 2
        , shadowColor:Colors.black,
         borderOnForeground: true
          ,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

          Padding(
            padding:  EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                final imagePicker = ImagePicker();
                final pickedImage = await imagePicker.getImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  setState(() {
                    _image = File(pickedImage.path);
                  });
                }
              },
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: _image != null
                    ? BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(_image!),
                    fit: BoxFit.cover,
                  ),
                )
                    : BoxDecoration(
                  border: Border.all(width: 1,),borderRadius: BorderRadius.circular(20)
                ),
                child: _image == null
                    ? Center(
                  child: Text('10th Marksheet or 12th Marksheet'),
                )
                    : null,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding:  EdgeInsets.all(8.0),
              child: MyButton3(onTap: () =>  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SetUpNAvodhya3(),
                  )), text: 'Continue', color: Colors.black, textcolor: Colors.white),
            )
          ),Spacer(),
              CheckboxListTile(
                title: Text(
                  'I hereby agree that the above document belongs to me and voluntarily give my consent to JNV Diaries or its parent organization to utilize it as my Mark-sheet proof for Navodayan verification only',
                  style: TextStyle(fontSize: 14),
                ),
                value: _isChecked, // Use the _isChecked variable here
                onChanged: (newValue) {
                  setState(() {
                    _isChecked = newValue!; // Update the _isChecked variable
                  });
                },
              ),
              Spacer(),
              Padding(
                padding:  EdgeInsets.all(8.0),
                child: Text(
                  'If you are facing any difficulties, please get in touch with us on Whatsapp',
                  style: GoogleFonts.inter(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
