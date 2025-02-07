import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/widgets/chip_container_widget.dart';

class JobDetailsWidget extends StatelessWidget {
  final JobPostModel jobData;
  const JobDetailsWidget({Key? key, required this.jobData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _buildJobDetailsTab(
        context: context, theme: theme, jobdata: jobData);
  }

  Widget _buildJobDetailsTab(
      {required BuildContext context,
      required ThemeData theme,
      required JobPostModel jobdata}) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // spacing: 10,
          children: [
            Text(
              "Job Description",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
            _basicDetails(theme: theme, context: context)
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.2, end: 0),
            _proffesionalDetails(context: context)
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.2, end: 0),
            _buildAdditionalInfo(context: context)
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.2, end: 0),
            _buildCustomQuestions(context: context)
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.2, end: 0)
          ],
        ),
      ),
    );
  }

  Widget _basicDetails(
      {String? currentndustry,
      String? role,
      String? jobRole,
      String? department,
      String? category,
      String? experience,
      String? salary,
      String? location,
      String? email,
      String? phone,
      String? availability,
      required ThemeData theme,
      required BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          // border: Border.all(color: secondaryColor),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 3),
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          // spacing: 15,
          children: [
            _buildItemWIdget(
                theme: theme,
                title: "Industry Type",
                subTitle: jobData.industry ?? "N/A",
                icon: "🏭"),
            _buildItemWIdget(
                theme: theme,
                title: "Experience",
                subTitle:
                    "${jobData.minimumExperience} - ${jobData.maximumExperience}Yrs",
                icon: "⏳"),
            _buildItemWIdget(
                theme: theme,
                title: "Job Location",
                subTitle:
                    "${CustomFunctions.toSentenceCase(jobData.city ?? "N/A")}, ${CustomFunctions.toSentenceCase(jobData.country ?? "N/A")}",
                icon: "📍"),
            _buildItemWIdget(
                theme: theme,
                title: "Salary",
                subTitle:
                    "${jobData.currency} ${CustomFunctions().formatCTC(jobData.minimumSalary)} - ${CustomFunctions().formatCTC(jobData.maximumSalary)}",
                icon: "💰"),
            _buildItemWIdget(
                theme: theme,
                title: "Job Type",
                subTitle: jobData.jobType ?? "N/A",
                icon: "💼"),
            jobData.skills != null
                ? _buildSkillWidget(
                    theme: theme, skills: jobData.skills!, context: context)
                : const SizedBox.shrink(),
          ],
        ),
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

  Widget _buildSkillWidget(
      {required BuildContext context,
      required ThemeData theme,
      required List<dynamic> skills}) {
    return Wrap(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // spacing: 5,
          children: [
            Row(
              // spacing: 5,
              children: [
                Text("🧠"),
                Text(
                  "Skills",
                  style: theme.textTheme.titleMedium!
                      .copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            skills.isNotEmpty
                ? Wrap(
                    spacing: 10,
                    children: skills.asMap().entries.map((entry) {
                      int index = entry.key;
                      String item = entry.value;
                      final color = index.isEven ? secondaryColor : buttonColor;
                      final animationDuration = (900 + (index * 50)).ms;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ChipContainerWidget(
                          text: item,
                          color: color,
                          textColor: Colors.white,
                          // duration: animationDuration,
                        )
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .slideY(begin: 0.5, end: 0),
                      );
                    }).toList(),
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(15.r)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No skills",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: greyTextColor),
                          ),
                        ],
                      ),
                    ),
                  )
          ],
        )
      ],
    );
  }

  Widget _proffesionalDetails({required BuildContext context}) {
    return Column(
      // spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Job Description",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.transparent),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Text(jobData.description.toString(),
                    style: AppTheme.mediumTitleText(
                      lightTextColor,
                    ).copyWith(
                      fontSize: 12.sp,
                    )),
                SizedBox(
                  height: 5.h,
                ),
                SizedBox(
                  height: 5.h,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo({
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return Column(
      // spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Additional Information",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // spacing: 10,
              children: [
                _buildItemWIdget(
                    theme: theme,
                    title: "Vaccancy",
                    subTitle: "${jobData.vaccancy}",
                    icon: "📂"),
                _buildItemWIdget(
                    theme: theme,
                    title: "education",
                    subTitle: "${jobData.education}",
                    icon: "📖"),
                _buildItemWIdget(
                    theme: theme,
                    title: "Functional Area",
                    subTitle: "${jobData.functionalArea}",
                    icon: "💼"),
                _buildItemWIdget(
                    theme: theme,
                    title: "Gender",
                    subTitle: "${jobData.gender}",
                    icon: "👤"),
                _buildItemWIdget(
                    theme: theme,
                    title: "Nationality",
                    subTitle: "${jobData.nationality}",
                    icon: "🌍"),
                _buildItemWIdget(
                    theme: theme,
                    title: "Requirements",
                    subTitle: jobData.requirements ?? "N/A",
                    icon: "📋")
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCustomQuestions({required BuildContext context}) {
    final theme = Theme.of(context);

    if (jobData.customQuestions == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // spacing: 10,
        children: [
          Text(
            "Custom Questions",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          AnimatedContainer(
            duration: 500.ms,
            height: 40.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: borderColor)),
            child: Row(
              // spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.info,
                  color: Colors.red,
                ),
                Text(
                  "Failed to load custom questions",
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: greyTextColor),
                ),
              ],
            ),
          ),
        ],
      );
    }
    if (jobData.customQuestions!.isEmpty) {
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // spacing: 10,
        children: [
          Text(
            "Questions",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Text("No questions to this job"),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // spacing: 10,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          "Custom Questions",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Column(
          // spacing: 10,
          children: List.generate(jobData.customQuestions!.length, (index) {
            final question = jobData.customQuestions![index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${index + 1}. ",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    CustomFunctions.toSentenceCase(question),
                    style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.normal, fontSize: 12.sp),
                  ),
                )
              ],
            );
          }),
        ),
      ],
    );
  }
}
