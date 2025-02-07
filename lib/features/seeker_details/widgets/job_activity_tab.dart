import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/features/resdex/model/job_response_model.dart';
import 'package:recruiter_app/widgets/job_card_widget.dart';

class JobActivityTab extends StatefulWidget {
  final JobPostModel? jobData;
  final bool? isInterview;
  final JobResponseModel? responseData;
  const JobActivityTab(
      {Key? key, this.jobData, this.isInterview, this.responseData})
      : super(key: key);

  @override
  _JobActivityTabState createState() => _JobActivityTabState();
}

class _JobActivityTabState extends State<JobActivityTab> {
  
  @override
  Widget build(BuildContext context) {
    
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        // spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Text(
            "View the seeker's personal and professional information, including contact details, skills, experience, and qualifications",
            style: theme.textTheme.bodyMedium!.copyWith(color: greyTextColor),
          ),
          Text(
            "Applied Job",
            style: theme.textTheme.titleLarge!
                .copyWith(fontWeight: FontWeight.bold, color: secondaryColor),
          ),


          widget.responseData != null
              ? Container(
                  height: 100,
                  width: double.infinity,
                  child: Row(
                    children: [Text("aaaaaaaaaaaaa")],
                  ),
                )
              : const SizedBox.shrink(),

          // widget.jobData != null
          //     ? JobCardWidget(job: widget.jobData!)
          //     : const SizedBox.shrink(),
          Text(
            "Interview Scheduled Details",
            style: theme.textTheme.titleLarge!
                .copyWith(fontWeight: FontWeight.bold, color: secondaryColor),
          ),
          _buildItemWIdget(
              theme: theme,
              title: "Scheduled Date",
              subTitle: "subTitle",
              icon: "📅"),
          _buildItemWIdget(
              theme: theme,
              title: "Scheduled Time",
              subTitle: "subTitle",
              icon: "🕛"),
          // _buildItemWIdget(
          //     theme: theme,
          //     title: "Applied job",
          //     subTitle: widget.jobData != null
          //         ? CustomFunctions.toSentenceCase(
          //             widget.jobData!.title.toString())
          //         : "N/A",
          //     icon: "💼"),
          Row(
            children: [
              Text("💼"),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                  child: Text("Applied job",
                      style: theme.textTheme.titleMedium!.copyWith(
                          fontSize: 12.sp, fontWeight: FontWeight.bold))),
              Text(": "),
              Expanded(
                  child: Text(
                      CustomFunctions.toSentenceCase(
                          widget.jobData!.title.toString()),
                      style: theme.textTheme.titleMedium!.copyWith(
                          fontSize: 12.sp,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold)))
            ],
          ),

          widget.responseData != null
              ? _buildItemWIdget(
                  theme: theme,
                  title: "Status",
                  subTitle: CustomFunctions.toSentenceCase(
                      widget.responseData!.viewed),
                  icon: "⏳")
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildItemWIdget(
      {required ThemeData theme,
      required String title,
      required String subTitle,
      required String icon}) {
    return Row(
      children: [
        Text(icon),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: Text(title,
                style: theme.textTheme.titleMedium!
                    .copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold))),
        Text(": "),
        Expanded(
            child: Text(subTitle,
                style: theme.textTheme.titleMedium!.copyWith(
                  fontSize: 12.sp,
                )))
      ],
    );
  }
}
