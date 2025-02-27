import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/details/widgets/additional_details_widget.dart';
import 'package:recruiter_app/features/details/widgets/job_details_widget.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/features/job_post/view/all_jobs.dart';
import 'package:recruiter_app/features/job_post/view/job_form.dart';
import 'package:recruiter_app/features/job_post/viewmodel.dart/job_posting_provider.dart';
import 'package:recruiter_app/viewmodels/job_viewmodel.dart';
import 'package:recruiter_app/widgets/chip_container_widget.dart';
import 'package:recruiter_app/widgets/common_alertdialogue.dart';
import 'dart:math' as math;

import 'package:recruiter_app/widgets/common_appbar_widget.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';

class CustomTabIndicator extends Decoration {
  final Color color;
  final double radius;
  final double indicatorHeight;

  const CustomTabIndicator({
    this.color = Colors.blue, // Use your secondaryColor here
    this.radius = 4,
    this.indicatorHeight = 4,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(
      color: color,
      radius: radius,
      indicatorHeight: indicatorHeight,
    );
  }
}

class _CustomPainter extends BoxPainter {
  final Color color;
  final double radius;
  final double indicatorHeight;

  _CustomPainter({
    required this.color,
    required this.radius,
    required this.indicatorHeight,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double width = configuration.size!.width;
    final double height = configuration.size!.height;

    final Rect rect = Offset(
          offset.dx,
          height - indicatorHeight,
        ) &
        Size(width, indicatorHeight);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint,
    );
  }
}

class JobDetails extends StatefulWidget {
  final JobPostModel jobData;
  const JobDetails({Key? key, required this.jobData}) : super(key: key);

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    print(widget.jobData.id);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int calculateDaysDifference(String givenDateString) {
    try {
      DateTime currentDate = DateTime.now();
      DateTime givenDate = DateTime.parse(givenDateString);

      // Calculate the difference in days
      return givenDate.difference(currentDate).inDays.abs();
    } catch (e) {
      // Return a default value if an error occurs
      return 0; // Or handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height.h;
    final screenWidth = MediaQuery.of(context).size.width.w;
    final date = DateTime.parse(widget.jobData.createdOn ?? "");
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: screenHeight * 0.45,
            child: SvgPicture.asset(
              "assets/svgs/onboard_1.svg",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: DefaultTabController(
              length: 2,
              child: BlocConsumer<JobBloc, JobsState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: CommonAppbarWidget(
                                    // fromJobDetails: true,
                                    isBackArrow: true,
                                    title: CustomFunctions.toSentenceCase(
                                        widget.jobData.title.toString())),
                              ),
                            ),
                            PopupMenuButton<String>(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: secondaryColor,
                                ),
                                position: PopupMenuPosition.under,
                                color: secondaryColor,
                                onSelected: (value) async {
                                  switch (value) {
                                    case "edit":
                                      Navigator.push(
                                          context,
                                          AnimatedNavigation()
                                              .fadeAnimation(JobForm(
                                            isEdit: true,
                                            jobData: widget.jobData,
                                          )));
                                    case "delete":
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CommonAlertDialog(
                                              title: "Delete?",
                                              message:
                                                  "Dou you want to delete this job ${widget.jobData.title}",
                                              onConfirm: () async {
                                                if (widget.jobData.id != null) {
                                                  final result = await Provider
                                                          .of<JobPostingProvider>(
                                                              context,
                                                              listen: false)
                                                      .deleteJobPost(
                                                          jobId: widget
                                                              .jobData.id!);

                                                  if (result == "success") {
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                            context,
                                                            AnimatedNavigation()
                                                                .fadeAnimation(
                                                                    AllJobs()),
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                    CommonSnackbar.show(context,
                                                        message:
                                                            "${widget.jobData.title} deleted successfully");
                                                  } else {
                                                    Navigator.pop(context);
                                                    CommonSnackbar.show(context,
                                                        message: "$result");
                                                  }
                                                }
                                              },
                                              onCancel: () {
                                                Navigator.pop(context);
                                              },
                                              height: 100);
                                        },
                                      );

                                      print("delete");
                                    case "close":
                                      bool status = false;

                                     

                                      if (widget.jobData.status == true) {
                                        status = false;
                                      }else{
                                        status = true;
                                      }
                                      final result = await Provider.of<JobPostingProvider>(context, listen: false).editJobPost(
                                          job: JobPostModel(
                                              benefits: widget.jobData.benefits,
                                              candidateLocation: widget
                                                  .jobData.candidateLocation,
                                              city: widget.jobData.city,
                                              country: widget.jobData.country,
                                              createdOn:
                                                  widget.jobData.createdOn,
                                              currency: widget.jobData.currency,
                                              customQuestions: widget
                                                  .jobData.customQuestions,
                                              description:
                                                  widget.jobData.description,
                                              education:
                                                  widget.jobData.education,
                                              functionalArea:
                                                  widget.jobData.functionalArea,
                                              gender: widget.jobData.gender,
                                              id: widget.jobData.id,
                                              industry: widget.jobData.industry,
                                              jobType: widget.jobData.jobType,
                                              maximumExperience: widget
                                                  .jobData.maximumExperience,
                                              maximumSalary:
                                                  widget.jobData.maximumSalary,
                                              minimumExperience: widget
                                                  .jobData.minimumExperience,
                                              minimumSalary:
                                                  widget.jobData.minimumSalary,
                                              nationality:
                                                  widget.jobData.nationality,
                                              requirements:
                                                  widget.jobData.requirements,
                                              skills: widget.jobData.skills,
                                              status: status,
                                              title: widget.jobData.title,
                                              vaccancy:
                                                  widget.jobData.vaccancy));

                                                 
                                      if (result == "success") {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            AnimatedNavigation()
                                                .fadeAnimation(AllJobs()),
                                            (Route<dynamic> route) => false);
                                        CommonSnackbar.show(context,
                                            message:
                                                "Closed the ob successfully");
                                        Provider.of<JobPostingProvider>(context,
                                                listen: false)
                                            .fetchJobLists();
                                      }
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              size: 20,
                                              color: buttonColor,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Edit Job',
                                              style: theme.textTheme.bodyMedium!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              size: 20,
                                              color: buttonColor,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Delete Job',
                                              style: theme.textTheme.bodyMedium!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: widget.jobData.status == true
                                            ? 'close'
                                            : "open",
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              size: 20,
                                              color: buttonColor,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              widget.jobData.status == true
                                                  ? 'Close Job'
                                                  : "Open",
                                              style: theme.textTheme.bodyMedium!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //   PopupMenuItem<String>(
                                    ])
                          ],
                        ),
                        _buildHeaderWidget(
                                theme: theme, jobData: widget.jobData)
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .slideX(begin: -0.5, end: 0),
                        TabBar(
                          indicatorColor: secondaryColor,
                          indicatorSize: TabBarIndicatorSize.tab,
                          unselectedLabelStyle: theme.textTheme.bodyLarge!
                              .copyWith(color: greyTextColor),
                          labelStyle: theme.textTheme.bodyLarge!.copyWith(
                              color: buttonColor, fontWeight: FontWeight.bold),
                          indicator: CustomTabIndicator(
                            color: secondaryColor.withValues(alpha: 0.7),
                            radius: 15,
                            indicatorHeight: 2.h,
                          ),
                          tabs: const [
                            Tab(
                              text: "Job Details",
                            ),
                            Tab(
                              text: "Responses",
                            )
                          ],
                        ),
                        Expanded(
                            child: TabBarView(children: [
                          JobDetailsWidget(jobData: widget.jobData),
                          AdditionalDetailsWidget(
                            jobId: widget.jobData.id,
                            jobData: widget.jobData,
                          )
                        ]))
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderWidget(
      {required ThemeData theme, required JobPostModel jobData}) {
    final date = DateTime.parse(jobData.createdOn ?? "");
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        // border: Border(
        //     bottom: BorderSide(
        //   color: borderColor,
        // )),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animated Logo
            AnimatedContainer(
              duration: const Duration(milliseconds: 0),
              child: CircleAvatar(
                radius: 40.r,
                backgroundColor: Colors.white,
                backgroundImage:
                    AssetImage("assets/images/default_company_logo.png"),
              ),
            ),
            SizedBox(width: 12.w),

            // Animated Title and Subtitle
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   CustomFunctions.toSentenceCase(jobData.title.toString()),
                  //   maxLines: 1,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  Row(
                    children: [
                      Icon(
                        Icons.place,
                        size: 18.sp,
                        color: buttonColor,
                      ),
                      Expanded(
                        child: Text(
                          '${CustomFunctions.toSentenceCase(jobData.city.toString())}, ${CustomFunctions.toSentenceCase(jobData.country.toString())}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                              "Job posted on ${DateFormat("dd-MM-yyyy").format(date)} ")),
                      Text(
                        "(${calculateDaysDifference(jobData.createdOn ?? "")} days ago)",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: greyTextColor),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
