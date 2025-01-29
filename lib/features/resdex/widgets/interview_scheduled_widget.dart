import 'package:flutter/material.dart';
import 'package:recruiter_app/core/constants.dart';

class InterviewScheduledWidget extends StatefulWidget {
  const InterviewScheduledWidget({ Key? key }) : super(key: key);

  @override
  _InterviewScheduledWidgetState createState() => _InterviewScheduledWidgetState();
}

class _InterviewScheduledWidgetState extends State<InterviewScheduledWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      child: Column(
        children: [
          Text("Schedule an interview with the seekers who have applied to the jobs. You can review their applications and select the candidates for the next step",
          style: theme.textTheme.bodyMedium!.copyWith(
            color: greyTextColor,
          ),
          ),
          
        ],
      ),
    );
  }
}