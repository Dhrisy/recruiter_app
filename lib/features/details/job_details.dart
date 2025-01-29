import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/details/widgets/additional_details_widget.dart';
import 'package:recruiter_app/features/details/widgets/job_details_widget.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/widgets/chip_container_widget.dart';
import 'dart:math' as math;

import 'package:recruiter_app/widgets/common_appbar_widget.dart';

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
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonAppbarWidget(
                      isBackArrow: true,
                      title: widget.jobData.title.toString()),
                  _buildHeaderWidget(theme: theme, jobData: widget.jobData).animate()
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
                    tabs: const[
                      Tab(
                        text: "Job Details",
                      ),
                      Tab(
                        text: "Additional",
                      )
                    ],
                  ),
                  Expanded(
                      child: TabBarView(children: [
                    JobDetailsWidget(jobData: widget.jobData),
                    AdditionalDetailsWidget(jobId: widget.jobData.id)
                  ]))
                ],
              ),
            ),
          )
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
