import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/features/home/viewmodel/home_provider.dart';

class JobCreditMeter extends StatefulWidget {
  const JobCreditMeter({Key? key}) : super(key: key);

  @override
  State<JobCreditMeter> createState() => _JobCreditMeterState();
}

class _JobCreditMeterState extends State<JobCreditMeter> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchRecruiterCounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Job posting credit meter",
            style: AppTheme.titleText(lightTextColor).copyWith(
              fontWeight: FontWeight.bold
            ),
          ),
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
                      _buildcreditCountWidget(
                          title: "Remaining post",
                          count: provider.countData != null
                              ? provider.countData!.remainingJobsCount
                                  .toString()
                              : "0"),
                      _buildcreditCountWidget(
                          title: "Total posted job",
                          count: provider.countData != null
                              ? provider.countData!.usedJobsCount.toString()
                              : "0")
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  LinearProgressIndicator(
                    backgroundColor: borderColor,
                    value: provider.countData != null ? (provider.countData!.usedJobsCount)/(provider.countData!.remainingJobsCount + provider.countData!.usedJobsCount) : 0.0,
                    color: buttonColor,
                    minHeight: 8.h,
                    borderRadius: BorderRadius.circular(10),
                    semanticsValue: "2",
                    valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Here is a summary of your usage",
                  style: AppTheme.bodyText(lightTextColor).copyWith(
                    fontSize: 11.sp
                  ),)
                ],
              ),
            ),
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0)
        ],
      );
    });
  }

  Widget _buildcreditCountWidget(
      {required String count, required String title}) {
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
        Text("$title: $count", style: AppTheme.bodyText(lightTextColor).copyWith(
          fontSize: 11.sp
        ),)
      ],
    ).animate().fadeIn(duration: 500.ms).scale();
  }
}
