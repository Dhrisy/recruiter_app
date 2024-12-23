import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:recruiter_app/core/constants.dart';

class ProfileCompletionCard extends StatelessWidget {
  const ProfileCompletionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 80.h,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [secondaryColor, secondaryGradientColor])),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundImage:
                  const AssetImage("assets/images/default_profile.webp"),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "To start connecting with top talent today!",
                    style: theme.textTheme.bodySmall!
                        .copyWith(color: Colors.white, fontSize: 11.sp),
                  ),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  Text(
                    "Complete your profile!",
                    style: theme.textTheme.bodyMedium!
                        .copyWith(color: Colors.white, fontSize: 14.sp),
                  ),
                ],
              ),
            ),
            CircularPercentIndicator(
              radius: 30.r,
              animation: true,
              fillColor: Colors.transparent,
              percent: 0.4,
              // animateToInitialPercent: true,
              progressColor: buttonColor,
              // restartAnimation: true,
              center: Text("${0.4 * 100}%",
              style: theme.textTheme.bodyMedium!
                        .copyWith(color: Colors.white),),
            ),
            const SizedBox(
              width: 15,
            ),
            Icon(Icons.arrow_forward_ios, size: 15.sp,color: Colors.white,)
          ],
        ),
      ),
    );
  }
}
