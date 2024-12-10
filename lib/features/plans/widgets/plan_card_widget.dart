import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';

class PlanCardWidget extends StatelessWidget {
  final List<Map<String, dynamic>> lists;
  PlanCardWidget({Key? key, required this.lists}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    style: AppTheme.headingText(Colors.white),
                  ),
                  Text(
                    '₹ 400',
                    style: AppTheme.headingText(Colors.white),
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
                    style: AppTheme.mediumTitleText(greyTextColor)
                        .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              _buildFeatures(),
              const SizedBox(
                height: 30,
              ),
              ReusableButton(
                  action: () {},
                  text: "Buy now",
                  textColor: Colors.white,
                  textSize: 20.sp,
                  buttonColor: buttonColor)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatures() {
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
                  style: AppTheme.bodyText(Colors.white),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
