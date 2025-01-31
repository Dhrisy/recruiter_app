import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/resdex/provider/interview_provider.dart';
import 'package:recruiter_app/features/resdex/provider/search_seeker_provider.dart';
import 'package:recruiter_app/widgets/seeker_card.dart';

class InterviewScheduledWidget extends StatefulWidget {
  const InterviewScheduledWidget({Key? key}) : super(key: key);

  @override
  _InterviewScheduledWidgetState createState() =>
      _InterviewScheduledWidgetState();
}

class _InterviewScheduledWidgetState extends State<InterviewScheduledWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InterviewProvider>(context, listen: false)
          .fetchScheduleInterview();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      child: Consumer<InterviewProvider>(builder: (context, provider, child) {
        return Column(
          spacing: 15,
          children: [
            Text(
              "Schedule an interview with the seekers who have applied to the jobs. You can review their applications and select the candidates for the next step",
              style: theme.textTheme.bodyMedium!.copyWith(
                color: greyTextColor,
              ),
            ),
            provider.seekerLists != null
                ? Column(
                    children:
                        List.generate(provider.seekerLists!.length, (index) {
                      final seekerData = provider.seekerLists![index];
                      return Consumer<SearchSeekerProvider>(
                          builder: (context, provider, child) {
                        final isBookmarked = provider.bookmarkedStates[
                                seekerData.seeker.personalData?.personal.id] ??
                            false;
                        return SeekerCard(
                          responseData: seekerData,
                            fromINterview: true,
                            jobData: seekerData.job,
                            seekerData: seekerData.seeker,
                            isBookmarked: isBookmarked,
                            onBookmarkToggle: () {
                              provider.toggleBookmark(
                                  seekerData.seeker, context);
                            });
                      });
                    }),
                  )
                : const SizedBox.shrink()
          ],
        );
      }),
    );
  }
}
