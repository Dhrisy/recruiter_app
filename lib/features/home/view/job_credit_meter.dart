import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';

class JobCreditMeter extends StatelessWidget {
  const JobCreditMeter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Job posting credit meter",
        style: theme.textTheme.titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 90.h,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: buttonColor, width: 1.w),
              borderRadius: BorderRadius.circular(20.r)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildcreditCountWidget(),
                    _buildcreditCountWidget()
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                LinearProgressIndicator(
                  backgroundColor: borderColor,
                  value: 0.5,
                  color: buttonColor,
                  minHeight: 8.h,
                  borderRadius: BorderRadius.circular(10),
                  semanticsValue: "2",
                  valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("Here is a summary of your usage")
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildcreditCountWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 20.h,
          width: 20.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r), color: secondaryColor),
        ),
        const SizedBox(
          width: 10,
        ),
        Text("Remaining: 35")
      ],
    );
  }
}
