// ignore_for_file: body_might_complete_normally_nullable, unused_field, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jnvapp/Screen/SetUpNavodhya/Navodhya.dart';
import 'package:jnvapp/Screen/onboardingProfile/onboardingProfilePage.dart';


import 'package:jnvapp/components/MyToast.dart';
import 'package:jnvapp/components/myButton.dart';
import 'package:jnvapp/components/myTextfield.dart';
import 'package:jnvapp/services/AuthFunctions.dart';
import 'package:jnvapp/services/FireStoreMethod.dart';

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
  FocusNode name = FocusNode();
  FocusNode Password_focus_signup = FocusNode();
   FocusNode Confirm_Password_focus_signup = FocusNode();
  FocusNode email_focus_signin = FocusNode();
  FocusNode Password_focus_signin = FocusNode();
  bool passwordVisible=false;
  bool IsColor=false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _selectedGender;
  String? _selectedOccupation; // Corrected variable name
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _maritalStatusController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController(); 
  @override
  void initState() {
    super.initState();
     IsColor=false;
    _tabController = TabController(length: 2, vsync: this);
     
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  String? _validateInput(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (fieldName == 'Email') {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    } else if (fieldName == 'Gender') {
      if (value != 'Male' && value != 'Female' && value != 'Others') {
        return 'Please select a valid gender';
      }
    }
    return null;
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        
       
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(250.h),
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 14.w),
            child: Column( 
              children: [
              
              SvgPicture.asset('assets/images/signinimg.svg'),
              //Image.asset('assets/images/signup1.png'),

                
                TabBar(
                  controller: _tabController,
                  labelColor: const Color.fromARGB(255, 27, 28, 30),
                  dividerColor:const Color.fromARGB(255, 27, 28, 30),
                  indicatorColor: const Color.fromARGB(255, 22, 138, 67),
                 indicatorSize:TabBarIndicatorSize.tab,
                  indicatorWeight: 5.0,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 40.w),
                  labelStyle: 
                  TextStyle(fontWeight: FontWeight.w700,   fontFamily:
                           'InterRegular',fontSize: 14.sp, 
                           
                          ),
                  //unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: 'SignUp'),
                    Tab(text: 'SignIn'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          
          buildForm(
            'Create An Account' ,
            [
            
            MyTextField(
                controller: _nameController,
                hint: "Full Name",
                obscure: false,
                selection: true,
                //preIcon: Icons.drive_file_rename_outline,
                keyboardtype: TextInputType.name,
                validator: (value) => _validateInput(value, fieldName: 'Name'),
              ),
              GestureDetector(
                onTap: () async {
                  await _selectDate(context);
                },
                child: AbsorbPointer(
                  child: MyTextField(
                    controller: _dobController,
                    hint: "DOB",
                    obscure: false,
                    selection: true,
                   // preIcon: Icons.calendar_today,
                    keyboardtype: TextInputType.datetime,
                    validator: (value) => _validateInput(value, fieldName: 'Date of Birth'),
                  ),
                ),
              ),
               Padding(
                 padding:  EdgeInsets.symmetric(horizontal: 1.w,vertical: 5.h),
                 child: Container(
                //  width: 370.w,
                  //height: 40.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    border:Border.all(
                      
                                  color: Color.fromARGB(255, 173, 179,
                                      189), // Specify the border color here
                                  // width: 2.0, // Specify the border width here
                                ),
                                borderRadius: BorderRadius.circular(8.0.r),),
                 
                    
                   child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    items: ['Male', 'Female', 'Others'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                        style: TextStyle(
                          color: Colors.black
                        ),),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Select Gender',
                      hintStyle: TextStyle(
                                  fontFamily: 'InterRegular',
                                  color: Color.fromARGB(255, 173, 179, 189),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400),
                     // prefixIcon: Icon(Icons.people),
                    ),
                    validator: (value) => _validateInput(value, fieldName: 'Gender'),
                                 ),
                 ),
               ),
                buildTextFormField('email', 'Email', Icons.mail,
            email_focus_signup),
            
              MyTextField(
                controller: _mobileController,
                hint: "Phone Number",
                obscure: false,
                selection: true,
              //  preIcon: Icons.phone,
                keyboardtype: TextInputType.phone,
                validator: (value) => _validateInput(value, fieldName: 'Mobile'),
              ),
               buildTextFormField('password', 'password', Icons.lock,
            Password_focus_signup),
             buildTextFormField('password', 'confirm password', Icons.lock,
            Confirm_Password_focus_signup),
            
            
          //     buildTextFormField('Age', 'Enter Your Age',
           //  Icons.input,age_focus),
            SizedBox(height: 10.h,),
               
          
               
           
            SizedBox(height: 10.h,),
           
          ], 'SignUp', 'Already have an Account? Login','Or Sign Up with',
          _signInFormKey,
          IsColor),

          buildForm(
            'Welcome Back!',
            [
            buildTextFormField('email', 'Enter Email', Icons.mail,
            email_focus_signin),
            SizedBox(height: 5.h,),
            buildTextFormField('password', 'Enter password', Icons.lock,
            Password_focus_signin),
            
          ], 'SignIn', "Don't have an Account? SignUp",'Or Sign In with',
          _signUpFormKey,
          IsColor),
        ],
      ),
    
    );
  }

  Widget buildForm(String titleText,List<Widget> formFields, String buttonText, 
  String switchText,String extraText, GlobalKey<FormState> _formKey, bool isColor) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.all(14.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            
              SizedBox(
                height: 24.h,
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
                child: MyButton3(
                  textcolor: (buttonText=="SignUp")?!IsColor?Color.fromARGB(255, 244, 66, 66): Colors.white:IsColor?Color.fromARGB(255, 244, 66, 66): Colors.white,
                  text: buttonText,
                  color: (buttonText=="SignUp")?IsColor?Color.fromARGB(255, 244, 66, 66): Colors.white:!IsColor?Color.fromARGB(255, 244, 66, 66): Colors.white,
                    onTap: () {
                      print(_tabController.index);
                    
                      String? nameError =
                  _validateInput(_nameController.text, fieldName: 'Name');
                  String? emailError =
                  _validateInput(_emailController.text, fieldName: 'Email');
                  if (nameError == null && emailError == null) {
                    FireStoreMethods().createUser(
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      name: _nameController.text.toLowerCase(),
                      dateOfBirth: _dobController.text,
                      gender: _selectedGender!,
                      email: email,
                      phoneNumber: "+91${_mobileController.text}",
                      aadharCardNumber: _aadhaarController.text,
                      maritalStatus: _maritalStatusController.text,
                      occupation: _selectedOccupation!,
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
                      context: context,
                    );
                  if(buttonText=="SignIn"){  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SetUpNavodhya();
                        },
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please fill all the fields correctly',
                        ),
                      ),
                    );
                  }
                  }
                            

                    // Handle SignUp or SignIn logic
                    //AlertDialog(title: Text("Sucessfully Sign Up"),);
                    if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                      if(buttonText=="SignUp"){
                        
                        AuthService.Signup(email, password);
                           ToastUtil.showToastMessage("Successful SignUp");
                           setState(() {
                        IsColor=!IsColor;
                        _tabController.animateTo(isLogin ? 0 : 1);
                       
                       // IsColor=false;
                      });
                      Future.delayed(Duration(milliseconds: 250), () {
 setState(() {
    IsColor = false;
 });});
 
                      }
                      else if(buttonText=="SignIn"){
                        AuthService.Signin(email,password);
                        ToastUtil.showToastMessage("Successful SignUp");
                           setState(() {
                        IsColor=!IsColor;
                       // IsColor=false;
                      });
                      Future.delayed(Duration(milliseconds: 300), () {
 setState(() {
    IsColor = false;
 });});
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
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8.h),
      child: Container(
        width: 358.w,
       // height:40.h ,
        decoration: const BoxDecoration(),
        child: TextFormField(
          focusNode: focus_Node,
          
          obscureText: (key=='password' && !passwordVisible)?true:false,
          decoration: InputDecoration(
            suffixIcon: key=='password' ?IconButton(
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
                                border: OutlineInputBorder(
                                   borderSide: BorderSide(
                                  color: Color.fromARGB(255, 173, 179,
                                      189), // Specify the border color here
                                  // width: 2.0, // Specify the border width here
                                ),
                                borderRadius: BorderRadius.circular(8.0.r),),
                                contentPadding: EdgeInsets.all(10.w),
                                hintText: hintText,
                                hintStyle:TextStyle(
                                  fontFamily: 'InterRegular',
                                  color: Color.fromARGB(255, 173, 179, 189),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400),
                                //fillColor: Color(0xFFF2F2F2),
                                //filled: true,
                                //focusColor: Color(0xffd8c8ea),
                                
                              ),
          
          key: ValueKey(key),
          validator:(value){
            if(key=='name'){
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
            }
              else{
                return null;
              }
              if(key=='name'){
                 if((value.toString().length<3)){
                return 'Name Must Contain more than 3 letter';
              }
              }
              else{
                return null;
              }
              
            }
           ,
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
  MaterialPageRoute(builder: (context) =>  SetUpNavodhya()),
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
