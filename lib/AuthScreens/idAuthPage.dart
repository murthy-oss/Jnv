import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jnvapp/Screen/SetUpNavodhya/Navodhya.dart';
import 'package:jnvapp/components/myButton.dart';
import 'package:jnvapp/components/myTextfield.dart';

class IdAuthPagState extends StatefulWidget {
  const IdAuthPagState({super.key});

  @override
  State<IdAuthPagState> createState() => _IdAuthPagStateState();
}

class _IdAuthPagStateState extends State<IdAuthPagState> {
  TextEditingController _idcontroller=TextEditingController();
   TextEditingController _Passwordcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [ 
            Padding(
              padding:  EdgeInsets.symmetric(vertical: 36.h),
              child: Image.asset('assets/images/idAuthpng.png'),
            ),
            MyTextField(
                  controller: _idcontroller,
                  hint: "Id",
                  obscure: false,
                  selection: true,
                  //preIcon: Icons.drive_file_rename_outline,
                  keyboardtype: TextInputType.name,
                 //validator: (value) => _validateInput(value, fieldName: 'Name'),
                ),
                MyTextField(
                  controller: _Passwordcontroller,
                  hint: "Password",
                  obscure: true,
                  selection: true,
                  //preIcon: Icons.drive_file_rename_outline,
                  keyboardtype: TextInputType.name,
                 //validator: (value) => _validateInput(value, fieldName: 'Name'),
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [ 
                      TextButton(
                        onPressed: (){

                        },
                        child: Text("Forgot Password?",
                        style: TextStyle(
                                    fontFamily: 'InterRegular',
                                    color: Color.fromARGB(255, 244, 66, 66),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700),),
                      )
                    ],
                  ),
                ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 36.h),
                    child: MyButton3(
                      textcolor: Colors.white,
                      text: 'Login',
                      color:  Color.fromARGB(255, 244, 66, 66),
                        onTap: () {
                        
                          Navigator.push(
  context,
  MaterialPageRoute(builder: (context) =>  SetUpNavodhya()),
);
                      },
                     
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}