import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:recruiter_app/core/constants.dart';

class CommonErrorWidget extends StatelessWidget {
  const CommonErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            style: theme.textTheme.titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            "Something went wrong",
            style: theme.textTheme.bodyMedium!.copyWith(color: greyTextColor),
          )
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale();
  }
}
