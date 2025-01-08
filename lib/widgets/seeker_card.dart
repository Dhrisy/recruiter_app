import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';

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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          // color: Colors.green,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: borderColor)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 15,
          children: [
            CircleAvatar(
              radius: 40.r,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  // if (widget.seekerData.personalData != null &&
                  //     widget.seekerData.personalData!.employed == true)
                  Text("${widget.seekerData.personalData != null &&
                          widget.seekerData.personalData!.employed == true}"),
                  // Text(widget.seekerData.personalData != null &&
                  //         widget.seekerData.personalData!.employed == true
                  //     ? "Experienced"
                  //     : "Fresher"),
                  Row(
                    children: [
                      Text(widget.seekerData.personalData!.user.name.toString().toUpperCase()),
                      Text(" - Fresher"),
                    ],
                  ),
                  if (widget.seekerData.personalData != null &&
                      widget.seekerData.personalData!.employed == true)
                    Text(
                        "${widget.seekerData.personalData!.totalExperienceYears}yr ${widget.seekerData.personalData!.totalExperienceMonths}m of ${widget.seekerData.employmentData != null ? widget.seekerData.employmentData!.first.jobRole : "N/A"}"),
                  Row(
                    children: [
                      _buildItemWidget(
                          theme: theme,
                          title: "Current company",
                          subTitle: widget.seekerData.personalData!.user.name.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      _buildItemWidget(
                          theme: theme,
                          title: "Current company",
                          subTitle: "name"),
                      _buildItemWidget(
                          theme: theme,
                          title: "Current company",
                          subTitle: "name")
                    ],
                  ),
                  // if (widget.seekerData.personalData != null &&
                  //     widget.seekerData.personalData!.employed == true)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Skills",
                          overflow: TextOverflow.ellipsis,
                        ),
                        ...?widget.seekerData.personalData?.skills?.entries
                            .map((entry) {
                          return Text("${entry.key}: ${entry.value}");
                        }).toList(),
                      ],
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
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
