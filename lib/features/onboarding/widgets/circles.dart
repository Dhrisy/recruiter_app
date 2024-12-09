import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';

class LeftCenterHalfCircle extends StatelessWidget {
  LeftCenterHalfCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width.w;
    final screenHeight = MediaQuery.of(context).size.height.h;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100.h,
            width: 90.w,
            decoration:
                BoxDecoration(color: buttonColor, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}

class TopLeftCircle extends StatelessWidget {
  const TopLeftCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: 50.h,
        width: 50.w,
        decoration: BoxDecoration(
            color: buttonColor,
            borderRadius:
                BorderRadius.only(bottomRight: Radius.circular(50.r))),
      ),
    );
  }
}

class RightCenterHalfCircle extends StatelessWidget {
  RightCenterHalfCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width.w;
    final screenHeight = MediaQuery.of(context).size.height.h;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100.h,
            width: 90.w,
            decoration:
                BoxDecoration(color: buttonColor, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}

class Circles {
  Widget buildSmallCircle() {
    return CircleAvatar(
      radius: 15.r, // Using screenutil for consistent sizing
      backgroundColor: buttonColor,
    );
  }

  Widget buildMediumCircle() {
    return CircleAvatar(
      radius: 20.r, // Using screenutil for consistent sizing
      backgroundColor: buttonColor,
    );
  }

  Widget buildCenterBigCircle(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width.w;
    final screenHeight = MediaQuery.of(context).size.height.h;
    return Positioned.fill(
      child: Center(
        child: CircleAvatar(
          radius: screenWidth * 0.25, // Responsive radius
          backgroundColor: buttonColor,
        ),
      ),
    );
  }
}
