import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Auth/SignUp.dart';
import '../../Models/ONboardingModel.dart';
import '../../Widgets/dotWidget.dart';
import '../../components/myButton.dart';
import 'getX.dart';
class Onboarding extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
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
                      children: [
                        Container(
                          height: constraints.maxWidth, // Adjusted height
                          width: constraints.maxWidth,
                          decoration: BoxDecoration(
                            color: Color(0xFF888BF4),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: Center(
                            child: Transform.scale(
                              scale: 0.8, // Adjust the scale factor as needed
                              child: Image.asset(
                                contents[i].image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),
                        Text(
                          contents[i].title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.aladin(
                            fontWeight: FontWeight.w400,
                            fontSize: constraints.maxWidth * 0.11, // Responsive font size
                            color: Colors.grey[750],
                          ),
                        ),
                        SizedBox(height: constraints.maxWidth * 0.25), // Adjusted height
                        Text(
                          contents[i].discription,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.aladin(
                            fontWeight: FontWeight.w400,
                            fontSize: constraints.maxWidth * 0.07, // Responsive font size
                            color: Colors.grey[900],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              Container(
                child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    contents.length,
                        (index) =>
                        buildDot(index, context, controller.currentIndex.value),
                  ),
                )),
              ),
              SizedBox(height: 5), // Add spacing between buttons
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(
                            milliseconds: 500), // Adjust duration as needed
                        pageBuilder: (context, animation, secondaryAnimation) =>
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
                  text: "Get Started",
                   color:Color(0xFF888BF4)
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
