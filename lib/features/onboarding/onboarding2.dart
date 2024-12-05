import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width.w;
    final screenHeight = MediaQuery.of(context).size.height.h;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Using LayoutBuilder for more dynamic sizing
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth,
                    height: screenHeight * 0.5, // 50% of screen height
                    color: Colors.yellow,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background Circle
                        Positioned.fill(
                          child: Center(
                            child: CircleAvatar(
                              radius: screenWidth * 0.3, // Responsive radius
                              backgroundColor: buttonColor,
                            ),
                          ),
                        ),
                        

                        // Decorative Dot
                        Positioned(
                          top: screenHeight * 0.1,
                          left: screenWidth * 0.1,
                          child: CircleAvatar(
                            radius: 15.r, // Using screenutil for consistent sizing
                            backgroundColor: buttonColor,
                          ),
                        ),
                         // Decorative Dot
                        Positioned(
                          top: screenHeight * 0.07,
                          right: screenWidth * 0.1,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CircleAvatar(
                              radius: 20.r, // Using screenutil for consistent sizing
                              backgroundColor: buttonColor,
                            ),
                          ),
                        ),

                        // Main Image
                        Positioned.fill(
                          child: Center(
                            child: Image.asset(
                              "assets/images/onboard_photo1.png",
                              fit: BoxFit.contain,
                              width: screenWidth * 0.7, // Responsive width
                              height: screenHeight * 0.4, // Responsive height
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Additional content can be added here
              SizedBox(height: 20.h),
              // Example of responsive text
              Text(
                'Welcome to Recruiter App',
                style: TextStyle(
                  fontSize: 18.sp, // Scalable font size
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}