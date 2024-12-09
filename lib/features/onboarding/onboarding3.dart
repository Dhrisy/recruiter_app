import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/navbar/view/navbar.dart';
import 'package:recruiter_app/features/onboarding/widgets/circles.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';

class Onboarding3 extends StatelessWidget {
  const Onboarding3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width.w;
    final screenHeight = MediaQuery.of(context).size.height.h;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.45,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.45,
                            child: SvgPicture.asset(
                              "assets/svgs/onboard_3.svg",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 8, top: 8),
                                    child: Text(
                                      "Back",
                                      style: AppTheme.bodyText(secondaryColor)
                                          .copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(right: 0, top: 8),
                                    child: Text(
                                      "Skip",
                                      style: AppTheme.bodyText(secondaryColor)
                                          .copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )
                              ],
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
                              "assets/images/onboard_photo3.png",
                              height: screenHeight * 0.36,
                            ),
                          )
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
                            'Your hiring journey starts here',
                            style: AppTheme.headingText(lightTextColor),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            'Streamline your hiring process by connecting with qualified candidates and making better hiring decisions with ease',
                            style: AppTheme.smallText(lightTextColor),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ReusableButton(
                      action: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => Navbar()));
                      },
                      text: "Next",
                      width: 100.h,
                      height: 35.h,
                      radius: 30.r,
                      buttonColor: buttonColor,
                      textColor: buttonTextColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
