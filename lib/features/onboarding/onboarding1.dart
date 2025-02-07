// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:recruiter_app/core/constants.dart';
// import 'package:recruiter_app/core/theme.dart';
// import 'package:recruiter_app/core/utils/navigation_animation.dart';
// import 'package:recruiter_app/features/onboarding/onboarding2.dart';
// import 'package:recruiter_app/features/onboarding/onboarding3.dart';
// import 'package:recruiter_app/features/onboarding/widgets/circles.dart';
// import 'package:recruiter_app/widgets/reusable_button.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Onboarding1 extends StatelessWidget {
//   const Onboarding1({Key? key}) : super(key: key);

//   Future<void> _navigateToNextScreen(BuildContext context) async {
//     try {
//       // Replace with your async operation if needed
//       await Future.delayed(Duration(seconds: 1)); // Simulating async operation
//       Navigator.push(
//         context,
//         AnimatedNavigation().fadeAnimation(Onboarding2()),
//       );
//     } catch (e) {
//       // Handle exceptions here if needed
//       print("Error during navigation: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Use MediaQuery to get screen dimensions
//     final screenWidth = MediaQuery.of(context).size.width.w;
//     final screenHeight = MediaQuery.of(context).size.height.h;
//     final theme = Theme.of(context);

//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           height: double.infinity,
//           width: double.infinity,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       height: screenHeight * 0.45,
//                       child: Stack(
//                         children: [
//                           SizedBox(
//                             width: double.infinity,
//                             height: screenHeight * 0.45,
//                             child: SvgPicture.asset(
//                               "assets/svgs/onboard_1.svg",
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         Align(
//                             alignment: Alignment.topRight,
//                             child: TextButton(
//                               onPressed: () {
//                                 _navigateToNextScreen(context);
//                               },
//                               child: Text(
//                                 "Skip",
//                                 style: AppTheme.bodyText(secondaryColor)
//                                     .copyWith(fontWeight: FontWeight.w500),
//                               ),
//                             ),

//                             // child: GestureDetector(
//                             //    onTap: () {
//                             //      print("qqqqqqqqqqqqqq");
//                             //    },
//                             //    child: Padding(
//                             //      padding:
//                             //          const EdgeInsets.only(right: 0, top: 8),
//                             //      child: Text(
//                             //        "Skip",
//                             //        style: AppTheme.bodyText(secondaryColor)
//                             //            .copyWith(
//                             //                fontWeight: FontWeight.w500),
//                             //      ),
//                             //    ),
//                             //  ),
//                           ),
//                           Align(
//                               alignment: Alignment.center,
//                               child: CircleAvatar(
//                                 radius: screenHeight * 0.14,
//                                 backgroundColor: buttonColor,
//                               )),
//                           Positioned.fill(
//                               child: Image.asset(
//                                   "assets/images/onboard_photo1.png"))
//                         ],
//                       ),
//                     ),

//                     // Additional content can be added here

//                     // Example of responsive text
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Find the perfect candidates for your team effortlessly',
//                             style: theme.textTheme.headlineMedium!.copyWith(
//                               fontWeight: FontWeight.bold
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           SizedBox(height: 20.h),
//                           Text(
//                             'A one-stop platform for connecting with top talent, streamlining hiring processes, and building exceptional teams',
//                             style: theme.textTheme.bodyMedium,
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: ReusableButton(
//                       action: () {
//                         Navigator.push(context,
//                             AnimatedNavigation().fadeAnimation(Onboarding2()));
//                       },
//                       text: "Next",
//                       width: 100.h,
//                       height: 35.h,
//                       radius: 30.r,
//                       buttonColor: buttonColor,
//                       textColor: buttonTextColor,
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class HalfCirclePainter extends CustomPainter {
//   final Color color;

//   HalfCirclePainter(this.color);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;

//     // Draw a half-circle
//     canvas.drawArc(
//       Rect.fromLTWH(0, 0, size.width, size.height), // Rect for the arc
//       -3.14 / 2, // Start angle (top center)
//       3.14, // Sweep angle (half-circle)
//       true, // Use center to fill the shape
//       paint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/auth/view/login_screen.dart';
import 'package:recruiter_app/features/onboarding/onboarding2.dart';
import 'package:recruiter_app/features/onboarding/onboarding3.dart';
import 'package:recruiter_app/features/onboarding/widgets/circles.dart';
import 'package:recruiter_app/features/plans/plans_screen.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width.w;
    final screenHeight = MediaQuery.of(context).size.height.h;
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: screenHeight * 0.5,
            child: SvgPicture.asset(
              "assets/svgs/onboard_1.svg",
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // height: 400,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: screenHeight * 0.45,
                        child: Stack(
                          children: [
                            SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            AnimatedNavigation()
                                                .fadeAnimation(
                                                    LoginScreen()),
                                            (Route<dynamic> route) =>
                                                false);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 0, top: 0),
                                        child: Text(
                                          "Skip",
                                          // style: theme.textTheme.bodyMedium,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  radius: screenHeight * 0.12,
                                  backgroundColor: buttonColor,
                                )),
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                "assets/images/onboard_photo1.png",
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Additional content can be added here
          
                // Example of responsive text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Find the perfect candidates for your team effortlessly',
                        style: theme.textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'A one-stop platform for connecting with top talent, streamlining hiring processes, and building exceptional teams',
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 30,
                  ),
                  child: ReusableButton(
                    action: () {
                      Navigator.push(context,
                          AnimatedNavigation().fadeAnimation(Onboarding2()));
                    },
                    text: "Next",
                    width: 100.h,
                    height: 35.h,
                    radius: 30.r,
                    textColor: buttonTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
