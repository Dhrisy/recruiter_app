import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';

class CommonErrorWidget extends StatelessWidget {
  const CommonErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    return SizedBox(
      // height: 100,
      width: double.infinity,
      child: Column(
        children: [
          Lottie.asset(
              'assets/images/error_animation.json',
              fit: BoxFit.cover,
              width: 100),
          Text(
            "Oops!",
            style: AppTheme.titleText(greyTextColor)
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            "Something went wrong",
            style: AppTheme.bodyText(greyTextColor).copyWith(color: greyTextColor),
          )
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale();
  }
}
