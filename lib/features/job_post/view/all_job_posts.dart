import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/features/job_post/viewmodel.dart/search_job_provider.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';
import 'package:recruiter_app/widgets/common_search_widget.dart';
import 'package:recruiter_app/widgets/job_card_widget.dart';

class AllJobPosts extends StatefulWidget {
  final List<JobPostModel> jobLists;
  const AllJobPosts({Key? key, required this.jobLists}) : super(key: key);

  @override
  _AllJobPostsState createState() => _AllJobPostsState();
}

class _AllJobPostsState extends State<AllJobPosts> {


@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
Provider.of<SearchJobProvider>(context, listen: false).setJobList(widget.jobLists);
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height.h;
    final theme = Theme.of(context);
    
    return Material(
      child: Scaffold(
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
            Consumer<SearchJobProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    CommonAppbarWidget(
                      title: "Posted Jobs",
                      isBackArrow: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: CommonSearchWidget(
                        onChanged: (query){
                          provider.searchJobs(query);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 15,
                          children:
                              List.generate(provider.filteredJobs.length, (index) {
                                // final job = widget.jobLists[index];
                                final job = provider.filteredJobs[index];
                                final borderColor = index.isEven ? buttonColor : secondaryColor;
                            return JobCardWidget(job: job, borderColor: borderColor,);
                          }),
                        ),
                      ),
                    )
                  ],
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
