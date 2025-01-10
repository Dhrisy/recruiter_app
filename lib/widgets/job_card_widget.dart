import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/details/job_details.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';

class JobCardWidget extends StatefulWidget {
  final String? name;
  final String? jobTitle;
  final String? location;
  final String? timeAgo;
  final String? profilePictureUrl;
  final JobPostModel job;
  final Color? borderColor;

  const JobCardWidget(
      {Key? key,
      this.name,
      this.jobTitle,
      this.location,
      this.timeAgo,
      this.profilePictureUrl,
      required this.job,
      this.borderColor})
      : super(key: key);

  @override
  _JobCardWidgetState createState() => _JobCardWidgetState();
}

class _JobCardWidgetState extends State<JobCardWidget> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        Navigator.push(context, AnimatedNavigation().slideAnimation(JobDetails(jobData: widget.job)));
      },
      child: Stack(
        children: [
          Container(
            // height: 90.h,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              gradient: _isSelected
                  ? secondGradient
                  : const LinearGradient(
                      colors: [Colors.white, Colors.white],
                    ),
              borderRadius: BorderRadius.circular(20.0.r),
              border: _isSelected
                  ? Border.all(color: Colors.transparent, width: 1.0.w)
                  : Border.all(color: widget.borderColor ?? secondaryColor, width: 1.0.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6.0.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
              
                CircleAvatar(
                  radius: 40.0.r,
                  backgroundColor: Colors.white,
                  backgroundImage: widget.profilePictureUrl != null
                    ?  NetworkImage(widget.profilePictureUrl!) : AssetImage("assets/images/default_company_logo.png"),
                ),
                SizedBox(width: 15.0.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              CustomFunctions.toSentenceCase(
                                  widget.job.title.toString()),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleLarge!.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: _isSelected
                                      ? Colors.white
                                      : lightTextColor),
                            ),
                          ),
                          Icon(
                            Icons.bookmark_outline,
                            size: 20.sp,
                            color: _isSelected ? buttonColor : secondaryColor,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                              "No.of vaccancies: ${widget.job.vaccancy.toString()}",
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                  color: _isSelected
                                      ? Colors.white
                                      : lightTextColor)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: _isSelected ? buttonColor : secondaryColor,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                              "${CustomFunctions.toSentenceCase(widget.job.city.toString())}, ${CustomFunctions.toSentenceCase(widget.job.country.toString())}",
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                  color: _isSelected
                                      ? Colors.white
                                      : lightTextColor)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Positioned(
          //     top: 10.h,
          //     right: 10.w,
          //     child: SizedBox(
          //         height: 20.h,
          //         width: 20.h,
          //         child: Icon(Icons.bookmark_outline,
          //         color: _isSelected ? buttonColor : secondaryColor)))
        ],
      ),
    );
  }
}

class JobCardTwo extends StatefulWidget {
  final String name;
  final String jobTitle;
  final String location;
  final String timeAgo;
  final String description;
  final String profilePictureUrl;

  const JobCardTwo({
    Key? key,
    required this.name,
    required this.jobTitle,
    required this.location,
    required this.timeAgo,
    required this.description,
    required this.profilePictureUrl,
  }) : super(key: key);

  @override
  _JobCardTwoState createState() => _JobCardTwoState();
}

class _JobCardTwoState extends State<JobCardTwo> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: Stack(
        children: [
          Container(
            height: 130.h,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              gradient: _isSelected
                  ? secondGradient
                  : const LinearGradient(
                      colors: [lightTextColor, lightTextColor],
                    ),
              borderRadius: BorderRadius.circular(20.0.r),
              border: _isSelected
                  ? Border.all(color: Colors.transparent, width: 2.0.w)
                  : Border.all(color: buttonColor, width: 2.0.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6.0.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35.0.r,
                  backgroundColor: const Color(0xFFE1BEE7),
                  backgroundImage: NetworkImage(widget.profilePictureUrl),
                ),
                SizedBox(width: 16.0.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.jobTitle,
                        style: AppTheme.titleText(
                                _isSelected ? lightTextColor : secondaryColor)
                            .copyWith(fontWeight: FontWeight.w300)

                        // const TextStyle(
                        //   fontFamily: 'Roboto',
                        //   fontWeight: FontWeight.w600,
                        //   fontSize: 20.0,
                        //   color: Colors.white,
                        // ),
                        ),
                    SizedBox(height: 4.0.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(widget.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.smallText(_isSelected
                                    ? lightTextColor
                                    : secondaryColor)
                                .copyWith(fontWeight: FontWeight.w400)),
                        SizedBox(
                          width: 10.w,
                        ),
                        Icon(
                          Icons.location_on,
                          color: lightTextColor,
                          size: 15,
                        ),
                        Text(widget.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.smallText(_isSelected
                                    ? lightTextColor
                                    : secondaryColor)
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10.sp)),
                      ],
                    ),
                    SizedBox(height: 5.0.h),
                    SizedBox(
                      height: 30.h,
                      width: 150.w,
                      child: Expanded(
                        child: Text(widget.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.smallText(_isSelected
                                    ? lightTextColor
                                    : secondaryColor)
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10.sp)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 7.h,
              right: 15.w,
              child: Text(
                "View",
                style: AppTheme.smallText(
                  _isSelected ? lightTextColor : secondaryColor,
                ).copyWith(fontSize: 10.sp),
              )),
          Positioned(
              top: 10.h,
              right: 10.w,
              child: SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: Image.asset(
                      color: _isSelected ? lightTextColor : secondaryColor,
                      "assets/savedIcon.png"))),
          Positioned(
            top: 40.h,
            right: 5.w,
            child: Text(
              widget.timeAgo,
              style: AppTheme.smallText(
                      _isSelected ? lightTextColor : secondaryColor)
                  .copyWith(fontWeight: FontWeight.w400, fontSize: 10.sp),
            ),
          ),
        ],
      ),
    );
  }
}
