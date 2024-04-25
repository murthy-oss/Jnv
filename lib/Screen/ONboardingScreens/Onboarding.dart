import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../Auth/SignUp.dart';
import '../../Models/ONboardingModel.dart';
import '../../Widgets/dotWidget.dart';
import '../../components/myButton.dart';
import 'getX.dart';

class Onboarding extends StatelessWidget {
  
  final OnboardingController controller = Get.put(OnboardingController());

  TextSpan processText(String text) {
 List<TextSpan> spans = [];
 List<String> parts = text.split('JNV Diaries');

 for (int i = 0; i < parts.length; i++) {
    spans.add(TextSpan(text: parts[i], style: TextStyle(fontWeight: FontWeight.w400,   fontFamily: 'InterRegular',fontSize: 16.sp, color: const Color.fromARGB(255, 65, 65, 65),letterSpacing: 0.3.sp)));
    if (i < parts.length - 1) {
      spans.add(TextSpan(text: 'JNV Diaries', style: TextStyle(fontWeight: FontWeight.w700,  fontFamily: 'InterRegular', fontSize: 16.sp, color:  const Color.fromARGB(255, 244, 66, 66),letterSpacing: 0.3.sp)));
    }
 }

 return TextSpan(children: spans);
}
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.sizeOf(context).height;
    
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: contents.length,
                    onPageChanged: (int index) {
                      controller.setPageIndex(
                          index); // Update currentIndex using controller
                    },
                    itemBuilder: (_, i) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 98.h,
                                  ),
                                  child: SvgPicture.asset(
                                    height:250.h,
                                    contents[i].image,
                                   
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(top: 53.h),
                                child: Container(
                                  child: Obx(() => Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(
                                          contents.length,
                                          (index) => buildDot(index, context,
                                              controller.currentIndex.value),
                                        ),
                                      )),
                                ),
                              ),
                                      
                              SizedBox(height: 48.h),
                              SizedBox(
                                width: 300.w,
                                height: 57.h,
                                child:  RichText(
                                       textAlign: TextAlign.center,
                                       text:processText(contents[i].title),
                                      ),
                              ),
                            ],
                          ),
                          
                    
                        // Adjusted height
     
        
                          // Add spacing between buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w,vertical: 28.h),
                  child: MyButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(
                                milliseconds: 500), // Adjust duration as needed
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    SignUpPage(),
                            transitionsBuilder:
                                (context, animation, secondaryAnimation, child) {
                              var begin = 0.0;
                              var end = 1.0;
                              var curve = Curves.ease;
        
                              var tween = Tween(begin: begin, end: end).chain(
                                CurveTween(curve: curve),
                              );
        
                              return FadeTransition(
                                opacity: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      text:contents[i].image=="Assets/images/onboard1.svg"? "Get Started":
                     contents[i].image=="Assets/images/onboard2.svg" ?"Next":"Start",
                      color: const Color.fromARGB(255, 244, 66, 66)),
                ),
                        ],
                      );
                    },
                  ),
                ),
        
                
              ],
            );
          },
        ),
      ),
    );
  }
}
