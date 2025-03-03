import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/details/job_details.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/features/job_post/viewmodel.dart/job_posting_provider.dart';
import 'package:recruiter_app/widgets/common_alertdialogue.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';

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
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        Navigator.push(
            context,
            AnimatedNavigation()
                .fadeAnimation(JobDetails(jobData: widget.job)));
      },
      child: Stack(
        children: [
          Container(
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
                  : Border.all(
                      color: widget.borderColor ?? secondaryColor,
                      width: 1.0.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6.0.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40.0.r,
                      backgroundColor: Colors.white,
                      backgroundImage: widget.profilePictureUrl != null
                          ? NetworkImage(widget.profilePictureUrl!)
                          : AssetImage(
                              "assets/images/default_company_logo.png"),
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
                                  style: AppTheme.headingText(lightTextColor)
                                      .copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: _isSelected
                                              ? Colors.white
                                              : lightTextColor),
                                ),
                              ),
                              // Icon(
                              //   Icons.bookmark_outline,
                              //   size: 20.sp,
                              //   color: _isSelected ? buttonColor : secondaryColor,
                              // )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                  "No.of vaccancies: ${widget.job.vaccancy.toString()}",
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTheme.bodyText(lightTextColor)
                                      .copyWith(
                                          color: _isSelected
                                              ? Colors.white
                                              : lightTextColor,
                                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color:
                                    _isSelected ? buttonColor : secondaryColor,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                  "${CustomFunctions.toSentenceCase(widget.job.city.toString())}, ${CustomFunctions.toSentenceCase(widget.job.country.toString())}",
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTheme.bodyText(_isSelected
                                          ? Colors.white
                                          : lightTextColor)
                                      .copyWith()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.job.status == true
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(color: Colors.green)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "Active",
                                    style: AppTheme.bodyText(lightTextColor)
                                        .copyWith(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(color: greyTextColor)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "Expired",
                                    style: AppTheme.bodyText(lightTextColor)
                                        .copyWith(
                                      color: greyTextColor,
                                    ),
                                  ),
                                ),
                              ),
                        InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CommonAlertDialog(
                                      title: "Delete?",
                                      message:
                                          "Dou you want to delete this job ${widget.job.title}",
                                      onConfirm: () async {
                                        if (widget.job.id != null) {
                                          final result = await Provider.of<
                                                      JobPostingProvider>(
                                                  context,
                                                  listen: false)
                                              .deleteJobPost(
                                                  jobId: widget.job.id!);

                                          if (result == "success") {
                                            Navigator.pop(context);
                                            CommonSnackbar.show(context,
                                                message:
                                                    "${widget.job.title} deleted successfully");
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
                            },
                            child: const Icon(
                              Icons.delete,
                              color: secondaryColor,
                            )),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

