import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/core/utils/skills.dart';
import 'package:recruiter_app/features/details/job_details.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';
import 'package:recruiter_app/features/resdex/provider/search_seeker_provider.dart';
import 'package:recruiter_app/features/responses/provider/seeker_provider.dart';
import 'package:recruiter_app/features/seeker_details/seeker_details.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';
import 'package:recruiter_app/widgets/shimmer_widget.dart';

class SeekerCard extends StatefulWidget {
  final SeekerModel seekerData;
  final Color? borderColor;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle; 
  const SeekerCard({Key? key, 
  required this.seekerData, 
  this.borderColor,
  required this.isBookmarked,
   required this.onBookmarkToggle,
  })
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

  // void checkBookmarked() async {
  //   if (widget.seekerData.personalData != null) {
  //     Provider.of<SearchSeekerProvider>(context, listen: false).isSaved = false;

  //     final res =
  //         await Provider.of<SearchSeekerProvider>(context, listen: false)
  //             .isSeekerSaved(
  //                 widget.seekerData.personalData!.personal.id.toString());
  //     Provider.of<SearchSeekerProvider>(context, listen: false).isSaved = res;
  //   }
  // }

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
                  blurRadius: 5,
                  color: borderColor,
                  offset: const Offset(-2, 1))
            ]),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                AnimatedNavigation().fadeAnimation(SeekerDetails(
                  seekerData: widget.seekerData,
                )));
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                                        widget.seekerData.personalData!.user
                                            .name
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
                                        ? Text(" - Fresher")
                                        : Text(
                                            " - ${CustomFunctions.toSentenceCase(widget.seekerData.personalData!.personal.introduction.toString())}",
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
                        widget.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                        color: widget.isBookmarked ? secondaryColor : Colors.grey,
                      ),
                    ),
                  ),
                              // Consumer<SearchSeekerProvider>(
                              //     builder: (context, provider, child) {
                              //   return InkWell(
                              //       onTap: () async {
                              //         if (widget.seekerData.personalData !=
                              //             null) {
                              //           final _isSaved = await provider
                              //               .toggleSaveCandidate(
                              //                   id: widget.seekerData
                              //                       .personalData!.personal.id
                              //                       .toString());
      
                              //           final seekerSaved = await provider
                              //               .isSeekerSaved(widget.seekerData
                              //                   .personalData!.personal.id
                              //                   .toString());
      
                              //           if (seekerSaved == true) {
                              //             provider.setSaved(true);
                              //             // setState(() {
                              //             //   isSaved = true;
                              //             // });
                              //             CommonSnackbar.show(context,
                              //                 message: "Saved ");
                              //           } else if (seekerSaved == false) {
                              //             // setState(() {
                              //             //   isSaved = false;
                              //             // });
                              //             provider.setSaved(false);
                              //             CommonSnackbar.show(context,
                              //                 message: "Removed");
                              //           } else {
                              //             CommonSnackbar.show(context,
                              //                 message:
                              //                     "Something went wrong!");
                              //           }
                              //         }
                              //       },
                              //       child: provider.isSaved == true
                              //           ? ScaleTransition(
                              //               scale: _iconAnimation,
                              //               child: Icon(Icons.bookmark))
                              //           : ScaleTransition(
                              //               scale: _iconAnimation,
                              //               child: Icon(
                              //                   Icons.bookmark_outline)));
                              // })
                            
                            
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
                            color: greyTextColor,
                            fontWeight: FontWeight.bold),
                      )
                    : Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: List.generate(
                            widget.seekerData.personalData!.personal.skills!
                                .length, (index) {
                          return Row(
                            children: [
                              Text(
                                "Skills : ",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                    color: greyTextColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Expanded(
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
                                          "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      )
              ],
            ),
          ),
        ),
      ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.5, end: 0);
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
