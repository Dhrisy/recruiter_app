import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';
import 'package:recruiter_app/features/resdex/provider/search_seeker_provider.dart';
import 'package:recruiter_app/widgets/chip_container_widget.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';
import 'package:recruiter_app/widgets/common_error_widget.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';

class SeekerDetails extends StatefulWidget {
  final SeekerModel seekerData;
  
  const SeekerDetails({Key? key, required this.seekerData}) : super(key: key);

  @override
  _SeekerDetailsState createState() => _SeekerDetailsState();
}

class _SeekerDetailsState extends State<SeekerDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // checkBookmarked();
    });
  }

  // void checkBookmarked() async {
  //   if (widget.seekerData.personalData != null) {
  //     Provider.of<SearchSeekerProvider>(context, listen: false).isSaved = false;
  //     final res =
  //         await Provider.of<SearchSeekerProvider>(context, listen: false)
  //             .isSeekerSaved(
  //                 widget.seekerData.personalData!.personal.id.toString());

  //     Provider.of<SearchSeekerProvider>(context, listen: false).isSaved = res;

  //     // setState(() {
  //     //   isSaved = res;
  //     // });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height.h;
    final screenWidth = MediaQuery.of(context).size.width.w;

    final theme = Theme.of(context);
    final seekerName = widget.seekerData.personalData?.user.name ?? "Unknown";

    return Material(
      child: Scaffold(
        body: Stack(
          children: [
            // Background SVG
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.45,
              child: SvgPicture.asset(
                "assets/svgs/onboard_1.svg",
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 15,
                  children: [
                    Consumer<SearchSeekerProvider>(
                        builder: (context, provider, child) {
                      return CommonAppbarWidget(
                        isBackArrow: true,
                        icon: provider.bookmarkedStates[widget.seekerData.personalData!.personal.id] == true
                            ? Icons.bookmark
                            : Icons.bookmark_outline,
                            action: (){
                              provider.toggleBookmark(widget.seekerData);
                            },


                        // action: () async {
                        //   if (widget.seekerData.personalData != null) {
                        //     final _isSaved = await provider.toggleSaveCandidate(
                        //         id: widget.seekerData.personalData!.personal.id
                        //             .toString());

                        //     final seekerSaved = await provider.isSeekerSaved(
                        //         widget.seekerData.personalData!.personal.id
                        //             .toString());

                        //     if (seekerSaved == true) {
                        //       // provider.setSaved(true);
                        //       // setState(() {
                        //       //   isSaved = true;
                        //       // });
                        //       CommonSnackbar.show(context, message: "Saved ");
                        //     } else if (seekerSaved == false) {
                        //       // setState(() {
                        //       // provider.setSaved(false);
                        //       //   isSaved = false;
                        //       // });
                        //       CommonSnackbar.show(context, message: "Removed");
                        //     } else {
                        //       CommonSnackbar.show(context,
                        //           message: "Something went wrong!");
                        //     }
                        //   }

                        //   await Provider.of<SearchSeekerProvider>(context,
                        //           listen: false)
                        //       .isSeekerSaved(widget
                        //           .seekerData.personalData!.personal.id
                        //           .toString());
                        // },
                       
                       
                       
                        title: CustomFunctions.toSentenceCase(seekerName),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: 15,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfileCard(
                                theme: theme, seekerData: widget.seekerData),
                            _buildSummaryWidget(
                                theme: theme, seekerData: widget.seekerData),
                            _buildSkillWidget(theme: theme, skills: []),
                            _buildBasicDetailsWidget(
                                theme: theme, seekerData: widget.seekerData),
                            _buildExperienceWidget(
                                theme: theme, seekerData: widget.seekerData),
                            _buildQualificationWidget(
                                theme: theme, seekerData: widget.seekerData),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(
      {required ThemeData theme, required SeekerModel seekerData}) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
              blurRadius: 8.r, offset: const Offset(0, 4.5), color: borderColor)
        ],
      ),
      duration: const Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          spacing: 15,
          children: [
            Container(
              height: 100.h,
              width: 100.w,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Text(
                  CustomFunctions.toSentenceCase(
                      widget.seekerData.personalData != null &&
                              widget.seekerData.personalData!.personal
                                      .employed ==
                                  true
                          ? widget.seekerData.employmentData != null
                              ? widget.seekerData.employmentData!.first.jobRole
                                  .toString()
                              : ""
                          : "Fresher"),
                  style: theme.textTheme.titleLarge!.copyWith(),
                ).animate().fadeIn(duration: 900.ms).scale(),
                Text.rich(TextSpan(text: "", children: [
                  TextSpan(
                      text: "0",
                      style: theme.textTheme.bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                  TextSpan(text: "yr "),
                  TextSpan(
                      text: "0",
                      style: theme.textTheme.bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                  TextSpan(text: "m"),
                ])),
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "📧",
                    ),
                    Text(seekerData.personalData!.user.email.toString())
                  ],
                ),
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "📱",
                    ),
                    Text(seekerData.personalData!.user.phoneNumber.toString())
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ReusableButton(
                              height: 30.h,
                              textColor: Colors.white,
                              iconWidget: const Icon(
                                Icons.download_rounded,
                                color: Colors.white,
                              ),
                              action: () {},
                              text: "Download Resume",
                          )
                          .animate()
                          .fadeIn(duration: 800.ms)
                          .scale(),
                    ),
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.5, end: 0);
  }

  Widget _buildSummaryWidget(
      {required ThemeData theme, required SeekerModel seekerData}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          "Summary",
          style: theme.textTheme.titleLarge!
              .copyWith(fontWeight: FontWeight.bold, color: secondaryColor),
        ),
        AnimatedContainer(
          duration: 200.ms,
          child: Column(
            children: [
              Text(
                  "Performing hot reload...cReloaded 1 of 2617 libraries in 1,247ms (compile: 59 ms, reload: 514 ms, reassemble: 321 ms). D/EGL_emulation(14066): app_time_stats: avg=58219.61ms min=58219.61ms max=58219.61ms count=1",
                  style: theme.textTheme.bodyMedium!.copyWith(
                  ),
                  )
            ],
          ),
        )
      ],
    ).animate().fadeIn(duration: 500.ms).scale(
        // begin: const Offset(-1, 1), end: Offset.zero
        );
  }

  // List<String> _skills = [
  //   "aa",
  //   "aaaaaaaaaaaaaaa",
  //   "aaaaaa",
  //   "aaaaaaaaaaaaaaaaaaaaaaaaaaaa",
  //   "ssssssssssss"
  // ];

  // Helper function to format CTC
  String formatCTC(dynamic ctc) {
    if (ctc == null) return 'N/A';

    try {
      double ctcValue = double.parse(ctc.toString());
      if (ctcValue >= 1000000) {
        // For millions
        return '₹${(ctcValue / 1000000).toStringAsFixed(1)}M';
      } else if (ctcValue >= 1000) {
        // For thousands
        return '₹${(ctcValue / 1000).toStringAsFixed(1)}K';
      }
      return '₹$ctcValue';
    } catch (e) {
      return 'N/A';
    }
  }

  Widget _buildSkillWidget(
      {required ThemeData theme, required List<String> skills}) {
    return Wrap(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Text(
              "Skills",
              style: theme.textTheme.titleLarge!
                  .copyWith(fontWeight: FontWeight.bold, color: secondaryColor),
            ),
          skills.isNotEmpty
          ?  Wrap(
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
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.5, end: 0),
                );
              }).toList(),
            )
            : _buildEmptyDataWidget(icon: Icons.lightbulb_outlined, text: "No skills found")
          
          
          ],
        )
      ],
    );
  }

  Widget _buildExperienceWidget(
      {required ThemeData theme, required SeekerModel seekerData}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Experiences",
          style: theme.textTheme.titleLarge!
              .copyWith(fontWeight: FontWeight.bold, color: secondaryColor),
        ),
        SizedBox(height: 20), // Replace spacing parameter
        seekerData.employmentData != null &&
                seekerData.employmentData!.isNotEmpty
            ? Column(
                children:
                    seekerData.employmentData!.asMap().entries.map((data) {
                  final index = data.key;
                  final employmentData = data.value;
                  final _borderColor =
                      index.isEven ? secondaryColor : buttonColor;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AnimatedContainer(
                      duration: 900.ms,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 8.r,
                              offset: const Offset(0, 4.5),
                              color: borderColor)
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            _buildItemWidget(
                                theme: theme,
                                text: CustomFunctions.toSentenceCase(
                                    employmentData.companyName ?? "N/A"),
                                fontWeight: FontWeight.bold,
                                icon: Text("🏢")),
                            _buildItemWidget(
                              theme: theme,
                              text:
                                  "Experience : ${CustomFunctions.toSentenceCase(employmentData.experience ?? "0")}yr",
                              fontWeight: FontWeight.normal,
                              fontSize: 12.sp,
                              // icon: Icon(Icons.business)
                            ),
                            Row(
                              children: [
                                Expanded(
                                  // Correct usage of Expanded inside Row
                                  child: _buildItemWidget(
                                      theme: theme,
                                      text:
                                          "${CustomFunctions.toSentenceCase(employmentData.jobTitle ?? "N/A")}",
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.normal,
                                      icon: Text(
                                        "👨‍💼",
                                      )),
                                ),
                                Expanded(
                                  // Correct usage of Expanded inside Row
                                  child: _buildItemWidget(
                                      theme: theme,
                                      text:
                                          "${CustomFunctions.toSentenceCase(employmentData.jobTitle ?? "N/A")}",
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.normal,
                                      icon: Text("💼")),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildItemWidget(
                                    theme: theme,
                                    text:
                                        "CTC : ${formatCTC(employmentData.ctc ?? "0")}",
                                    icon: const Text(
                                      "💰",
                                    ),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Expanded(
                                  child: _buildItemWidget(
                                      theme: theme,
                                      text:
                                          "Notice period : ${CustomFunctions.toSentenceCase(employmentData.noticePeriod ?? "N/A")}",
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.normal,
                                      icon: const Text("⏰")),
                                ),
                              ],
                            ),
                            _buildItemWidget(
                                theme: theme,
                                text:
                                    "Industry : ${employmentData.roleCategory ?? "N/A"}",
                                fontWeight: FontWeight.normal,
                                fontSize: 12.sp,
                                icon: const Text(
                                  "🏭",
                                )),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: 0.5, end: 0),
                  );
                }).toList(),
              )
            : _buildEmptyDataWidget(icon: Icons.work_outline, text: "No experience found")
      ],
    );
  }

  Widget _buildQualificationWidget(
      {required ThemeData theme, required SeekerModel seekerData}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Text(
          "Qualifications",
          style: theme.textTheme.titleLarge!
              .copyWith(fontWeight: FontWeight.bold, color: secondaryColor),
        ),
        widget.seekerData.qualificationData != null &&
                widget.seekerData.qualificationData!.isNotEmpty
            ? Column(
                children:
                    seekerData.qualificationData!.asMap().entries.map((data) {
                  final index = data.key;
                  final qualificationData = data.value;
                  final _borderColor =
                      index.isEven ? secondaryColor : buttonColor;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AnimatedContainer(
                      duration: 900.ms,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 8.r,
                              offset: const Offset(0, 4.5),
                              color: borderColor)
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            _buildQualificationItemWIdget(
                                theme: theme,
                                title: "Education",
                                subTitle: qualificationData.education ?? 'N/A',
                                icon: "🎓"),
                            _buildQualificationItemWIdget(
                                theme: theme,
                                title: "Course",
                                subTitle: qualificationData.course ?? 'N/A',
                                icon: '📘'),
                            _buildQualificationItemWIdget(
                                theme: theme,
                                title: "University",
                                subTitle: qualificationData.university ?? 'N/A',
                                icon: "🏫"),
                            Row(
                              children: [
                                Text("📅 "),
                                Expanded(
                                    child: Text("Duration",
                                        style: theme.textTheme.titleMedium!
                                            .copyWith(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold))),
                                Text(": "),
                                Expanded(
                                  child: Text(
                                      "${qualificationData.startingYr ?? "0"} - ${qualificationData.endingYr ?? "0"}",
                                      style:
                                          theme.textTheme.titleMedium!.copyWith(
                                        fontSize: 12.sp,
                                      )),
                                )
                              ],
                            ),
                            _buildQualificationItemWIdget(
                                theme: theme,
                                title: "Grade",
                                subTitle: qualificationData.grade ?? 'N/A',
                                icon: "⭐"),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: 1, end: 0),
                  );
                }).toList(),
              )
            : _buildEmptyDataWidget(icon: Icons.workspace_premium, text: "No qualification Found")
      ],
    );
  }

  Widget _buildBasicDetailsWidget(
      {required ThemeData theme, required SeekerModel seekerData}) {
    String getFormattedDate(String date) {
      final DateTime dateTime = DateTime.parse(date);
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    }

    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Personal Details",
          style: theme.textTheme.titleLarge!
              .copyWith(fontWeight: FontWeight.bold, color: secondaryColor),
        ),
        seekerData.personalData != null
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AnimatedContainer(
                      duration: 900.ms,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 8.r,
                              offset: const Offset(0, 4.5),
                              color: borderColor)
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          spacing: 10,
                          children: [
                            _buildQualificationItemWIdget(
                                theme: theme,
                                title: "Email",
                                subTitle: seekerData.personalData!.user.email ??
                                    "N/A",
                                icon: "📧"),
                            _buildQualificationItemWIdget(
                                theme: theme,
                                title: "Phone",
                                subTitle:
                                    seekerData.personalData!.user.phoneNumber ??
                                        "N/A",
                                icon: "📱"),
                            _buildQualificationItemWIdget(
                                theme: theme,
                                title: "Professional Role",
                                subTitle: CustomFunctions.toSentenceCase(
                                    seekerData.personalData!.user.role ??
                                        "N/A"),
                                icon: "👨‍💼"),
                            Row(children: [
                              const Text("📍"),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  child: Text("Location",
                                      style: theme.textTheme.titleMedium!
                                          .copyWith(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold))),
                              const Text(": "),
                              Expanded(
                                child: seekerData
                                            .personalData!.personal.address !=
                                        null
                                    ? Row(
                                        spacing: 8,
                                        children: [
                                          Flexible(
                                            child: Row(
                                                spacing: 8,
                                                children: List.generate(
                                                    seekerData
                                                        .personalData!
                                                        .personal
                                                        .address!
                                                        .length, (index) {
                                                  final _address = seekerData
                                                      .personalData!
                                                      .personal
                                                      .address![index];
                                                  return Flexible(
                                                    child: Text(
                                                        CustomFunctions
                                                            .toSentenceCase(
                                                                _address),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: theme.textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                          fontSize: 12.sp,
                                                        )),
                                                  );
                                                })),
                                          ),
                                          Flexible(
                                            child: Text(
                                              seekerData.personalData!.personal
                                                      .city ??
                                                  "",
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Flexible(
                                              child: Text(seekerData
                                                      .personalData!
                                                      .personal
                                                      .state ??
                                                  "")),
                                        ],
                                      )
                                    : Text("N/A"),
                              ),
                            ]),
                            _buildQualificationItemWIdget(
                                theme: theme,
                                title: "Total experience",
                                subTitle:
                                    "${seekerData.personalData!.personal.totalExperienceYears} - ${seekerData.personalData!.personal.totalExperienceMonths}",
                                icon: "⏳"),
                            _buildQualificationItemWIdget(
                                theme: theme,
                                title: "Preferred Salary",
                                subTitle: formatCTC(seekerData.personalData!
                                    .personal.preferedSalaryPackage),
                                icon: "💰"),
                            Row(children: [
                              const Text("📍"),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  child: Text("Preferred Locations",
                                      style: theme.textTheme.titleMedium!
                                          .copyWith(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold))),
                              Text(": "),
                              Expanded(
                                child: seekerData.personalData!.personal
                                            .preferedWorkLocations !=
                                        null
                                    ? Row(
                                        children: List.generate(
                                            seekerData
                                                .personalData!
                                                .personal
                                                .preferedWorkLocations!
                                                .length, (index) {
                                        final _locations = seekerData
                                            .personalData!
                                            .personal
                                            .preferedWorkLocations![index];
                                        return Expanded(
                                            child: Text(
                                                CustomFunctions.toSentenceCase(
                                                    _locations),
                                                style: theme
                                                    .textTheme.titleMedium!
                                                    .copyWith(
                                                  fontSize: 12.sp,
                                                )));
                                      }))
                                    : Text("N/A"),
                              ),
                            ]),
                            _buildQualificationItemWIdget(
                                theme: theme,
                                title: "Date of Birth",
                                subTitle: formatCTC(getFormattedDate(seekerData
                                    .personalData!.personal.dob
                                    .toString())),
                                icon: "🎂"),
                            _buildQualificationItemWIdget(
                                theme: theme,
                                title: "Nationality",
                                subTitle: CustomFunctions.toSentenceCase(
                                    seekerData.personalData!.personal
                                            .nationality ??
                                        "N/A"),
                                icon: "🌏"),
                            _buildQualificationItemWIdget(
                                theme: theme,
                                title: "Gender",
                                subTitle:
                                    seekerData.personalData!.personal.gender ??
                                        "N/A",
                                icon: "👤"),
                            _buildQualificationItemWIdget(
                                theme: theme,
                                title: "Is Differently Able",
                                subTitle: seekerData.personalData!.personal
                                            .isDifferentlyAbled ==
                                        true
                                    ? "Yes"
                                    : "No",
                                icon: "🚶"),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: 0.5, end: 0),
                  )
                ],
              )
            : const CommonErrorWidget()
      ],
    );
  }

  Widget _buildQualificationItemWIdget(
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

  Widget _buildItemWidget({
    required ThemeData theme,
    required String text,
    Widget? icon,
    required FontWeight fontWeight,
    double? fontSize,
  }) {
    return Row(
      spacing: 10,
      children: [
        icon ?? const SizedBox.shrink(),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium!
                .copyWith(fontWeight: fontWeight, fontSize: fontSize ?? 15.sp),
          ),
        ),
      ],
    );
  }

Widget _buildEmptyDataWidget({
  required IconData icon,
  required String text
}){
return AnimatedContainer(
              duration: 500.ms,
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white,
                 borderRadius: BorderRadius.circular(15.r),
                 boxShadow: [
                          BoxShadow(
                              blurRadius: 8.r,
                              offset: const Offset(0, 4.5),
                              color: borderColor)
                        ],
              ),
              child:  Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon,
                    size: 20,
                    color: greyTextColor,
                    ),
                    Text(text,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: greyTextColor
                    ))
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.5, end: 0);
          
}

}
