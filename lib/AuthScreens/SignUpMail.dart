// ignore_for_file: body_might_complete_normally_nullable, unused_field, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jnvapp/Screen/SetUpNavodhya/Navodhya.dart';
import 'package:jnvapp/Screen/onboardingProfile/onboardingProfilePage.dart';


import 'package:jnvapp/components/MyToast.dart';
import 'package:jnvapp/components/myButton.dart';
import 'package:jnvapp/services/AuthFunctions.dart';

class SignUpMail extends StatefulWidget {
  const SignUpMail({Key? key}) : super(key: key);

  @override
  State<SignUpMail> createState() => _SignUpMailState();
}

class _SignUpMailState extends State<SignUpMail>
    with SingleTickerProviderStateMixin {
  String email='';
  String password='';
  String Username='';
  bool isLogin = false;
  late TabController _tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();
  FocusNode Username_focus = FocusNode();
  FocusNode age_focus = FocusNode();
  FocusNode email_focus_signup = FocusNode();
  FocusNode Password_focus_signup = FocusNode();
  FocusNode email_focus_signin = FocusNode();
  FocusNode Password_focus_signin = FocusNode();
  bool passwordVisible=false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
     
  }



  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(50.r)),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100.h),
          child: TabBar(
            controller: _tabController,
            labelColor: Color(0xFF888BF4),
            dividerColor: Color(0xFF888BF4),
            indicatorColor: Color(0xFF888BF4),
            labelStyle: TextStyle(fontSize: 20.w, fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'SignUp'),
              Tab(text: 'SignIn'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildForm(
            'Create An Account' ,
            [
            
            
          
          //     buildTextFormField('Age', 'Enter Your Age',
           //  Icons.input,age_focus),
            SizedBox(height: 10.h,),
               
            buildTextFormField('email', 'Enter Email', Icons.mail,
            email_focus_signup),
            SizedBox(height: 10.h,),
            buildTextFormField('password', 'Enter password', Icons.lock,
            Password_focus_signup),
            
          ], 'SignUp', 'Already have an Account? Login','Or Sign Up with',
          _signInFormKey),

          buildForm(
            'Welcome Back!',
            [
            buildTextFormField('email', 'Enter Email', Icons.mail,
            email_focus_signin),
            SizedBox(height: 10.h,),
            buildTextFormField('password', 'Enter password', Icons.lock,
            Password_focus_signin),
            
          ], 'SignIn', "Don't have an Account? SignUp",'Or Sign In with',
          _signUpFormKey),
        ],
      ),
    
    );
  }

  Widget buildForm(String titleText,List<Widget> formFields, String buttonText, 
  String switchText,String extraText, GlobalKey<FormState> _formKey) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(titleText,style: TextStyle(
                fontSize: 25.w,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(
                height: 30.w,
              ),
              ...formFields,
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                    _tabController.animateTo(isLogin ? 1 : 0);
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text( switchText ),
                  ],
                ),
              ),
             

              Container(
              
                width: double.infinity,
                height: 50.h,
                child: MyButton(
                  text: buttonText,
                  color: Color(0xFF888BF4),
                    onTap: () {
                             ToastUtil.showToastMessage("Successful login");

                    // Handle SignUp or SignIn logic
                    //AlertDialog(title: Text("Sucessfully Sign Up"),);
                    if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                      if(buttonText=="SignUp"){
                        
                        AuthService.Signup(email, password);
                      }
                      else if(buttonText=="SignIn"){
                        AuthService.Signin(email,password);
                        checkUserSignInStatus();
                        
                      }
                       
                    }
                   
                  },
                 
                ),
              ),
             
            ],
          ),
          
        ),
      ),
    );
    
  }

  Widget buildTextFormField(String key, String hintText, IconData prefixIcon, FocusNode focus_Node) {
    return Container(
      decoration: const BoxDecoration(),
      child: TextFormField(
        focusNode: focus_Node,
        
        obscureText: (key=='password' && !passwordVisible)?true:false,
        decoration: InputDecoration(
          suffixIcon: key=='password'?IconButton(
                     icon: Icon(passwordVisible
                         ? Icons.visibility
                         : Icons.visibility_off),
                          onPressed: () {
                       setState(
                         () {
                           passwordVisible = !passwordVisible;
                         },
                       );
                     },
                   ):null,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.all(20),
                              hintText: hintText,
                              hintStyle: GoogleFonts.aladin(),
                              fillColor: Color(0xFFF2F2F2),
                              filled: true,
                              focusColor: Color(0xffd8c8ea),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
        
        key: ValueKey(key),
        validator:(value){
          if(key=='FullName'){
            if(value.toString().length<3){
              return 'Usename is so small';
            }
            else{
              return null;
            }
            
          }
          else if(key=='email'){
            if(!(value.toString().contains('@'))){
              return 'Email is not valid';
            }
            else{
              return null;
            }
            
          }
          
          else if(key=='password'){
            if((value.toString().length<6)){
              return 'password is small';
            }
            else{
              return null;
            }
            
          }
        } ,
        onSaved: (value){
          setState(() {
            if(key=='FullName'){
            Username=value!;
            }
            else if(key=='email'){
              email=value!;
            }
            else if(key=='password'){
              password=value!;
            }
          });
        },
       
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
  MaterialPageRoute(builder: (context) =>  SetUpProfile()),
);

  } else {
    // The user is not signed in
    print('User is not signed in');
  }
}

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
