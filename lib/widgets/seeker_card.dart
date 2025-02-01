import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/details/job_details.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/features/resdex/model/invite_seeker_model.dart';
import 'package:recruiter_app/features/resdex/model/job_response_model.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';
import 'package:recruiter_app/features/resdex/provider/search_seeker_provider.dart';
import 'package:recruiter_app/features/seeker_details/seeker_details.dart';
import 'package:recruiter_app/widgets/common_alertdialogue.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';

class SeekerCard extends StatefulWidget {
  final SeekerModel seekerData;
  final Color? borderColor;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  final bool? isInvited;
  final JobPostModel? jobData;
  final bool? fromResponse;
  final bool? fromINterview;
  final JobResponseModel? responseData;
  final InvitedSeekerWithJob? invitedModel;
  const SeekerCard(
      {Key? key,
      required this.seekerData,
      this.borderColor,
      required this.isBookmarked,
      required this.onBookmarkToggle,
      this.jobData,
      this.isInvited,
      this.fromINterview,
      this.responseData,
      this.fromResponse,
      this.invitedModel})
      : super(key: key);

  @override
  _SeekerCardState createState() => _SeekerCardState();
}

class _SeekerCardState extends State<SeekerCard>
    with SingleTickerProviderStateMixin {
  bool isSaved = false;
  late AnimationController _controller;
  late Animation<double> _iconAnimation;
  late Animation<Offset> _itemAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // checkBookmarked();
    });

    _iconAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _itemAnimation = Tween<Offset>(
            begin: const Offset(0, 0.05), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.seekerData.personalData != null) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 5, color: borderColor, offset: Offset(-2, 1))
            ]),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                AnimatedNavigation().fadeAnimation(
                  SeekerDetails(
                    responseData: widget.responseData,
                    fromInterview: widget.fromINterview,
                    jobData: widget.jobData,
                    fromResponse: widget.fromResponse,
                    isInvited: widget.isInvited,
                    seekerData: widget.seekerData,
                  ),
                ));
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.isInvited == true
                    ? Row(
                        children: [
                          Text(
                            "Invited job : ",
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: greyTextColor),
                          ),
                          InkWell(
                            onTap: (){
                              if(widget.jobData != null){
                              Navigator.push(context, AnimatedNavigation().fadeAnimation(JobDetails(jobData: widget.jobData!)));

                              }
                            },
                            child: Text(
                              widget.jobData != null
                                  ? widget.jobData!.title.toString().toUpperCase()
                                  : "N/A",
                              style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 12.sp, color: Colors.blue),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                     widget.fromResponse == true
                    ? Row(
                        children: [
                          Text(
                            "Applied to : ",
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: greyTextColor),
                          ),
                          InkWell(
                            onTap: (){
                              if(widget.jobData != null){
                              Navigator.push(context, AnimatedNavigation().fadeAnimation(JobDetails(jobData: widget.jobData!)));

                              }
                            },
                            child: Text(
                              widget.jobData != null
                                  ? widget.jobData!.title.toString().toUpperCase()
                                  : "N/A",
                              style: theme.textTheme.titleMedium!.copyWith(
                                color: Colors.blue,
                                  fontWeight: FontWeight.bold, fontSize: 12.sp),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                     widget.fromINterview == true
                    ? Row(
                        children: [
                          Text(
                            "Applied to : ",
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: greyTextColor),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                if(widget.jobData != null){
                                Navigator.push(context, AnimatedNavigation().fadeAnimation(JobDetails(jobData: widget.jobData!)));
                            
                                }
                              },
                              child: Text(
                                widget.jobData != null
                                    ? widget.jobData!.title.toString().toUpperCase()
                                    : "N/A",
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: Colors.blue,
                                    fontWeight: FontWeight.bold, fontSize: 12.sp),
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 15,
                          ),

                          Expanded(
                            child: Text(
                                widget.responseData != null
                                    ? widget.responseData!.status
                                    : "N/A",
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: Colors.blue,
                                    fontWeight: FontWeight.bold, fontSize: 12.sp),
                              ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image
                    CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          AssetImage("assets/images/profile_picture.jpg"),
                    ),
                    const SizedBox(width: 16),
                    // Details Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget
                                            .seekerData.personalData!.user.name
                                            .toString()
                                            .toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleLarge!
                                            .copyWith(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    widget.seekerData.personalData!.personal
                                                .employed ==
                                            false
                                        ? Text("Fresher")
                                        : Text(
                                            "${CustomFunctions.toSentenceCase(widget.seekerData.personalData!.personal.introduction.toString())}",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                              color: greyTextColor,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              // Bookmark Icon
                              InkWell(
                                onTap: widget.onBookmarkToggle,
                                child: ScaleTransition(
                                  scale: _iconAnimation,
                                  child: Icon(
                                    widget.isBookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_outline,
                                    color: widget.isBookmarked
                                        ? secondaryColor
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                             ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text('🏢 '),
                              Expanded(
                                child: Text(
                                  widget.seekerData.personalData!.personal
                                              .employed ==
                                          false
                                      ? "No experience"
                                      : '${widget.seekerData.personalData!.personal.totalExperienceYears}yr ${widget.seekerData.personalData!.personal.totalExperienceMonths}m',
                                  // '${widget.seekerData.personalData!.totalExperienceYears}yr ${widget.seekerData.personalData!.totalExperienceMonths}m',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text('📍 '),
                              Expanded(
                                child: Text(
                                  "${CustomFunctions.toSentenceCase(widget.seekerData.personalData!.personal.city.toString())}, ${CustomFunctions.toSentenceCase(widget.seekerData.personalData!.personal.state.toString())}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                widget.seekerData.personalData!.personal.skills!.isEmpty
                    ? Text(
                        "No skills found",
                        style: theme.textTheme.bodyMedium!.copyWith(
                            color: greyTextColor, fontWeight: FontWeight.bold),
                      )
                    : Row(
                        children: [
                          Text(
                            "Skills : ",
                            style: theme.textTheme.bodyMedium!.copyWith(
                                color: greyTextColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                              child: Wrap(
                            children: List.generate(
                                widget.seekerData.personalData!.personal.skills!
                                    .length, (index) {
                              final skill = widget.seekerData.personalData!
                                  .personal.skills![index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: buttonColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          skill,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ))
                        ],
                      ),
                widget.isInvited == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ReusableButton(
                              buttonColor: secondaryColor,
                              textColor: Colors.white,
                              height: 25.h,
                              width: 150.w,
                              radius: 8,
                              action: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CommonAlertDialog(
                                          titleColor: secondaryColor,
                                          title: "Withdraw Invite",
                                          subTitle:
                                              "Are you sure want to withraw the invitation for ${CustomFunctions.toSentenceCase(widget.seekerData.personalData!.user.name.toString())}",
                                          message:
                                              "If you withdraw the invitation for ${CustomFunctions.toSentenceCase(widget.seekerData.personalData!.user.name.toString())}, you will need to re-invite them by visiting the job or seeker details. Please confirm your action.",
                                          onConfirm: () async {
                                            if (widget.invitedModel != null && widget.invitedModel!.id != null) {

                                                  print(widget.jobData!.title.toString());
                                              final result = await Provider.of<
                                                          SearchSeekerProvider>(
                                                      context,
                                                      listen: false)
                                                  .deleteInvitedSeeker(
                                                      id: widget.invitedModel!.id!);

                                              if (result == true) {
                                                Navigator.pop(context);
                                                CommonSnackbar.show(context,
                                                    message:
                                                        "Invite deleted successfully!");
                                                Provider.of<SearchSeekerProvider>(
                                                        context,
                                                        listen: false)
                                                    .fetchInvitedCandidates();
                                              } else {
                                                Navigator.pop(context);
                                                CommonSnackbar.show(context,
                                                    message: result.toString());
                                              }
                                            }
                                          },
                                          onCancel: () {
                                            Navigator.pop(context);
                                          },
                                          height: 200);
                                    });
                              },
                              text: "Withdraw invite")
                        ],
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.5, end: 0);
    } else {
      return Text("Error seeker data is null");
    }
  }

  Widget _buildItemWidget(
      {required ThemeData theme,
      required String title,
      required String subTitle}) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subTitle,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
