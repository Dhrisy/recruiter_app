import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/auth/view/login_screen.dart';
import 'package:recruiter_app/features/auth/view/register.dart';
import 'package:recruiter_app/features/navbar/view/navbar.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';

class PlanCardWidget extends StatelessWidget {
  final List<Map<String, dynamic>> lists;
  PlanCardWidget({Key? key, required this.lists}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lists[0]["plan_name"],
                    style: theme.textTheme.headlineMedium!.copyWith(color: Colors.white),
                  ),
                  Text(
                    '₹ ${lists[0]["rupees"]}',
                    style: theme.textTheme.headlineMedium!.copyWith(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text(
                    "KEY FEATURES",
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontSize: 15.sp,
                      color: greyTextColor
                    ),
                  ),
                ],
              ),
              _buildFeatures(context),
              const SizedBox(
                height: 30,
              ),
              ReusableButton(
                  action: () {
                    Navigator.push(context, AnimatedNavigation().slideAnimation(LoginScreen()));
                  },
                  text: "Buy now",
                  textColor: Colors.white,
                  textSize: 20.sp,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatures(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: List.generate(lists.length, (index) {
        final stdData = lists[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: stdData["is_applicable"] == true
                    ? Colors.green
                    : Colors.grey,
                child: Icon(
                  stdData["is_applicable"] == true ? Icons.check : Icons.close,
                  size: 12.sp,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  "${stdData["title"]}",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontSize: 13.sp,
                    color: Colors.white
                  )
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
