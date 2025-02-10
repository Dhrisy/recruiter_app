import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/auth/view/login_screen.dart';
import 'package:recruiter_app/features/auth/view/register.dart';
import 'package:recruiter_app/features/settings/model/subscription_model.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';

class PlanCardWidget extends StatelessWidget {
  final List<Map<String, dynamic>> lists;
  final bool? fromSettings;
  final PlanModel plan;
  const PlanCardWidget({
    Key? key,
    required this.plan,
    required this.lists,
    this.fromSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Stack(
        children: [
          Container(
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
                        plan.title,
                        style: theme.textTheme.headlineMedium!
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        '₹ ${plan.rate}',
                        style: theme.textTheme.headlineMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Text(
                        "KEY FEATURES",
                        style: theme.textTheme.titleLarge!
                            .copyWith(fontSize: 15.sp, color: greyTextColor),
                      ),
                    ],
                  ),
                  _buildFeatures(context),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ReusableButton(
              action: () async {
                if (fromSettings == true) {
                } else {
                  Navigator.push(
                      context, AnimatedNavigation().slideAnimation(Register(planId: plan.id,)));
                }
              },
              text: "Buy now",
              textColor: Colors.white,
              textSize: 20.sp,
            ),
          )
        ],
      ),
    );
  }


  Widget _buildFeatures(BuildContext context) {
    final theme = Theme.of(context);
    final features = [
      plan.description.ss,
      plan.description.descOne,
      plan.description.descTwo
    ].where((feature) => feature != null).toList();

    return Column(
      children: List.generate(features.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.check,
                  size: 12.sp,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(features[index]!,
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontSize: 13.sp, color: Colors.white)),
              )
            ],
          ),
        );
      }),
    );
  }
}
