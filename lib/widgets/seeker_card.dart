import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/details/job_details.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';
import 'package:recruiter_app/features/seeker_details/seeker_details.dart';

class SeekerCard extends StatefulWidget {
  final SeekerModel seekerData;
  const SeekerCard({Key? key, required this.seekerData}) : super(key: key);

  @override
  _SeekerCardState createState() => _SeekerCardState();
}

class _SeekerCardState extends State<SeekerCard> {


  



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.seekerData.personalData != null) {
      return Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
          // side: BorderSide(color: borderColor),
        ),
        margin: const EdgeInsets.only(bottom: 16),
        child: InkWell(
          onTap: (){
            Navigator.push(context, 
            AnimatedNavigation().fadeAnimation(SeekerDetails()));
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
                    ),
                    const SizedBox(width: 16),
                    // Details Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.seekerData.personalData!.user.name
                                    .toString()
                                    .toUpperCase(),
                                style: theme.textTheme.titleLarge!.copyWith(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold
                                ),
                              ),

                              widget.seekerData.personalData!.employed == false
                              ? Text(" - Fresher") :  Text(" - ${CustomFunctions.toSentenceCase(widget.seekerData.personalData!.introduction.toString())}")
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text('🏢 '),
                              Expanded(
                                child: Text(
                                  '${widget.seekerData.personalData!.totalExperienceYears}yr ${widget.seekerData.personalData!.totalExperienceMonths}m',
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
                                  "${CustomFunctions.toSentenceCase(widget.seekerData.personalData!.city.toString())}, ${CustomFunctions.toSentenceCase(widget.seekerData.personalData!.state.toString())}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          widget.seekerData.personalData!.employed == true && widget.seekerData.employmentData != null
                              ? Row(
                                  children: [
                                    _buildItemWidget(
                                        theme: theme,
                                        title: "Current company",
                                        subTitle: widget
                                            .seekerData.employmentData!.first.companyName
                                            .toString()),
                                  ],
                                )
                              : const SizedBox.shrink(),
                          // Row(
                          //   children: [
                          //     _buildItemWidget(
                          //         theme: theme,
                          //         title: "Company name",
                          //         subTitle: widget
                          //             .seekerData.personalData!.user.name
                          //             .toString()),
                          //     const SizedBox(
                          //       width: 15,
                          //     ),
                          //     _buildItemWidget(
                          //         theme: theme,
                          //         title: "Current company",
                          //         subTitle: widget
                          //             .seekerData.personalData!.user.name
                          //             .toString()),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Skills
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (widget.seekerData.personalData?.skills != null)
                      ? widget.seekerData.personalData!.skills!.entries
                          .map((entry) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${entry.key}: ${entry.value}",
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList()
                      : [],
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Text("aaaaaaaaaaa");
    }

    // return Container(
    //   width: double.infinity,
    //   decoration: BoxDecoration(
    //       // color: Colors.green,
    //       borderRadius: BorderRadius.circular(15.r),
    //       border: Border.all(color: borderColor)),
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Row(
    //       spacing: 15,
    //       children: [
    //         CircleAvatar(
    //           radius: 40.r,
    //         ),
    //         Expanded(child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text("Name"),
    //             Text("Name"),
    //             Row(
    //               children: [
    //                 Text("Name"),
    //                 Text("Name"),
    //               ],
    //             ),

    //           ],
    //         ))
    //         // Expanded(
    //         //   child: Column(
    //         //     crossAxisAlignment: CrossAxisAlignment.start,
    //         //     spacing: 2,
    //         //     children: [
    //         //       // if (widget.seekerData.personalData != null &&
    //         //       //     widget.seekerData.personalData!.employed == true)
    //         //       Text("${widget.seekerData.personalData != null &&
    //         //               widget.seekerData.personalData!.employed == true}"),
    //         //       // Text(widget.seekerData.personalData != null &&
    //         //       //         widget.seekerData.personalData!.employed == true
    //         //       //     ? "Experienced"
    //         //       //     : "Fresher"),
    //         //       Row(
    //         //         children: [
    //         //           Text(widget.seekerData.personalData!.user.name.toString().toUpperCase()),
    //         //           Text(" - Fresher"),
    //         //         ],
    //         //       ),
    //         //       if (widget.seekerData.personalData != null &&
    //         //           widget.seekerData.personalData!.employed == true)
    //         //         Text(
    //         //             "${widget.seekerData.personalData!.totalExperienceYears}yr ${widget.seekerData.personalData!.totalExperienceMonths}m of ${widget.seekerData.employmentData != null ? widget.seekerData.employmentData!.first.jobRole : "N/A"}"),
    //         //       Row(
    //         //         children: [
    //         //           _buildItemWidget(
    //         //               theme: theme,
    //         //               title: "Current company",
    //         //               subTitle: widget.seekerData.personalData!.user.name.toString()),
    //         //         ],
    //         //       ),
    //         //       Row(
    //         //         children: [
    //         //           _buildItemWidget(
    //         //               theme: theme,
    //         //               title: "Current company",
    //         //               subTitle: "name"),
    //         //           _buildItemWidget(
    //         //               theme: theme,
    //         //               title: "Current company",
    //         //               subTitle: "name")
    //         //         ],
    //         //       ),
    //         //       // if (widget.seekerData.personalData != null &&
    //         //       //     widget.seekerData.personalData!.employed == true)
    //         //         Column(
    //         //           crossAxisAlignment: CrossAxisAlignment.start,
    //         //           children: [
    //         //             Text(
    //         //               "Skills",
    //         //               overflow: TextOverflow.ellipsis,
    //         //             ),
    //         //             ...?widget.seekerData.personalData?.skills?.entries
    //         //                 .map((entry) {
    //         //               return Text("${entry.key}: ${entry.value}");
    //         //             }).toList(),
    //         //           ],
    //         //         )
    //         //     ],
    //         //   ),
    //         // )

    //       ],
    //     ),
    //   ),
    // );
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
