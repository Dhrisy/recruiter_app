import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/details/job_details_provider.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';
import 'package:recruiter_app/features/responses/provider/seeker_provider.dart';
import 'package:recruiter_app/widgets/common_error_widget.dart';
import 'package:recruiter_app/widgets/common_nodatafound_widget.dart';
import 'package:recruiter_app/widgets/shimmer_list_loading.dart';
import 'package:recruiter_app/widgets/shimmer_widget.dart';

class AdditionalDetailsWidget extends StatefulWidget {
  final SeekerModel? seekerData;
  final int? jobId;
  const AdditionalDetailsWidget({Key? key, this.seekerData, this.jobId})
      : super(key: key);

  @override
  State<AdditionalDetailsWidget> createState() =>
      _AdditionalDetailsWidgetState();
}

class _AdditionalDetailsWidgetState extends State<AdditionalDetailsWidget> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.jobId != null) {
        Provider.of<JobDetailsProvider>(context, listen: false)
            .fetchSeekersJobApplied(jobId: widget.jobId)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });

        Provider.of<JobDetailsProvider>(context, listen: false)
            .fetchSeekersInvitedToJob(jobId: widget.jobId)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        
          _buildApplicationResponses(
              theme: theme, seekerData: widget.seekerData)
        ],
      ),
    );
  }

  Widget _buildApplicationResponses({
    required ThemeData theme,
    SeekerModel? seekerData,
  }) {
    return Consumer<JobDetailsProvider>(builder: (context, provider, child) {
      if (_isLoading == true) {
        return   Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  width: MediaQuery.of(context).size.width * 0.4.w, 
                  height: 20.h,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r)
                  ),
                  ),
              const  RowListShimmerLoadingWidget(),
              ShimmerWidget(
                  width: MediaQuery.of(context).size.width * 0.4.w, 
                  height: 20.h,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r)
                  ),
                  ),
              const  RowListShimmerLoadingWidget(),
              ShimmerWidget(
                  width: MediaQuery.of(context).size.width * 0.4.w, 
                  height: 20.h,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r)
                  ),
                  ),
              const  RowListShimmerLoadingWidget(),
              ],
            ),
          );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Job applications received to this job",
              style: theme.textTheme.titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
             Text("The following job seekers have responded to this job posting. Their applications have been submitted for review, and they are being considered based on their skills and experience",
            style: theme.textTheme.bodyMedium!.copyWith(
              color: greyTextColor
            ),),
            const SizedBox(
              height: 10,
            ),
            if (provider.message == "error" || provider.seekerLists == null)
              CommonErrorWidget(),
            if (provider.seekerLists != null &&
                provider.message == "" &&
                provider.seekerLists!.isEmpty)
              _buildEmpty(theme: theme, text: "No seeker yet"),
            if (provider.seekerLists != null &&
                provider.seekerLists!.isNotEmpty &&
                provider.message == "")
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 10,
                  children:
                      List.generate(provider.seekerLists!.length, (index) {
                    return _buildSeekercardWidget(
                        theme: theme, seekerData: provider.seekerLists![index]);
                  }),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Interview scheduled for this position",
              style: theme.textTheme.titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
             Text("The following job seekers have been scheduled for an interview for this position. Their applications have been reviewed, and they have been shortlisted based on their qualifications and experience",
            style: theme.textTheme.bodyMedium!.copyWith(
              color: greyTextColor
            ),),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(10, (index) {
                  return _buildInterviewScheduledListsWidget(theme: theme);
                }),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Invited job seekers for this position",
              style: theme.textTheme.titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text("The following job seekers have been invited to apply for this position. They have been selected based on their skills and experience relevant to the job requirements",
            style: theme.textTheme.bodyMedium!.copyWith(
              color: greyTextColor
            ),),
            const SizedBox(
              height: 10,
            ),
            if (provider.invitedMessage == "error" ||
                provider.invitedSeekersLists == null)
            const  CommonErrorWidget(),
            if (provider.invitedSeekersLists != null &&
                provider.invitedMessage == "" &&
                provider.invitedSeekersLists!.isEmpty)
              _buildEmpty(theme: theme, text: "No seeker yet"),
            if (provider.invitedSeekersLists != null &&
                provider.invitedSeekersLists!.isNotEmpty &&
                provider.invitedMessage == "")
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 10,
                  children: List.generate(provider.invitedSeekersLists!.length,
                      (index) {
                    return _buildSeekercardWidget(
                        theme: theme,
                        seekerData: provider.invitedSeekersLists![index]);
                  }),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildEmpty({required ThemeData theme, required String text}) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/no_result_found.jpg",
            fit: BoxFit.contain,
            height: 50.h,
          ),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: greyTextColor, fontSize: 14.sp),
          )
        ],
      ),
    );
  }

  Widget _buildSeekercardWidget({
    required ThemeData theme,
    SeekerModel? seekerData,
  }) {
    if (seekerData != null) {}
    return AnimatedContainer(
      duration: 500.ms,
      width: 200.w,
      // height: 100.h,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
                color: borderColor, blurRadius: 7.r, offset: const Offset(0, 3))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 15,
              children: [
                Container(
                  height: 70.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(10.r)),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    seekerData != null && seekerData.personalData != null
                        ? Text(
                            "👤 ${CustomFunctions.toSentenceCase(seekerData.personalData!.user.name.toString())}",
                            style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 14.sp, fontWeight: FontWeight.bold),
                          )
                        : Text("N/A"),
                    Text(
                      "👔 ${CustomFunctions.toSentenceCase(seekerData!.personalData!.user.role.toString())}",
                      style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        "💼 ${seekerData.personalData!.personal.totalExperienceYears}yr ${seekerData.personalData!.personal.totalExperienceMonths}m"),
                  ],
                ))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              spacing: 10,
              children: [
                Text("📍"),
                Expanded(
                    child: Text(
                  "${CustomFunctions.toSentenceCase(seekerData.personalData!.personal.city.toString())}",
                  overflow: TextOverflow.ellipsis,
                ))
              ],
            ),
            const SizedBox(
              height: 1,
            ),
            // seekerData.personalData!.personal.employed == false
            //     ? Text("Fresher")
            //     : Text("Employed")
          ],
        ),
      ),
    );
  }

  Widget _buildInterviewScheduledListsWidget({
    required ThemeData theme,
    SeekerModel? seekerData,
  }) {
    return AnimatedContainer(
      duration: 500.ms,
      width: 300,
      height: 100,
      decoration: BoxDecoration(color: buttonColor),
    );
  }

  Widget _buildInvitedListsWidget({
    required ThemeData theme,
    SeekerModel? seekerData,
  }) {
    return AnimatedContainer(
      duration: 500.ms,
      width: 300,
      height: 100,
      decoration: BoxDecoration(color: buttonColor),
    );
  }
}
