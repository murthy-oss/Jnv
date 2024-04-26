import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jnvapp/AuthScreens/NavodhyaSuccess.dart';
import 'package:jnvapp/components/myButton.dart';
import 'package:jnvapp/components/myTextfield.dart';

class SetUpNAvodhya3 extends StatefulWidget {
  const SetUpNAvodhya3({super.key});

  @override
  State<SetUpNAvodhya3> createState() => _SetUpNAvodhya3State();
}

class _SetUpNAvodhya3State extends State<SetUpNAvodhya3> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    TextEditingController _controller1 = TextEditingController();
    TextEditingController _controller2 = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Navodayan Verification',
            style: GoogleFonts.inter(fontSize: 18.sp),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Column(children: [
          MyTextField(
              controller: _controller,
              hint: 'Enter Your Exam Roll Number',
              obscure: false,
              selection: true,
              keyboardtype: TextInputType.name),
          MyTextField(
              controller: _controller1,
              hint: 'Enter Your Passing Year',
              obscure: false,
              selection: true,
              keyboardtype: TextInputType.name),
          MyTextField(
              controller: _controller2,
              hint: 'Enter Your Full Name',
              obscure: false,
              selection: true,
              keyboardtype: TextInputType.name),
          MyButton1(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NAvodhyaSuccess(),
                    ));
              },
              text: 'Continue',
              color: Colors.black)
        ]),
      ),
    );
  }
}
