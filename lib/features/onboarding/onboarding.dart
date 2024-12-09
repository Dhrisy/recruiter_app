import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/onboarding/landing_screen.dart';
import 'package:recruiter_app/features/onboarding/onboarding1.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final pages = [
    Onboarding1(),
    Onboarding1(),
    Onboarding1(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: PageView.builder(
                    controller: _controller,
                    itemBuilder: (context, index) {
                      return pages[index];
                    })),
            Padding(
              padding: EdgeInsets.only(top: 0, bottom: 10),
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: WormEffect(
                  activeDotColor: buttonColor,
                  dotColor: secondaryColor,
                  dotHeight: 9.h,
                  dotWidth: 15.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
