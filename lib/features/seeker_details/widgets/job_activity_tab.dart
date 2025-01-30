import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/widgets/job_card_widget.dart';

class JobActivityTab extends StatefulWidget {
  final JobPostModel? jobData;
  const JobActivityTab({Key? key, this.jobData}) : super(key: key);

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
        spacing: 15,
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

          widget.jobData != null ?  JobCardWidget(job: widget.jobData!) : const SizedBox.shrink()
          
        ],
      ),
    );
  }
}
