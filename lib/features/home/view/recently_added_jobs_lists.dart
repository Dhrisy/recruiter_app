import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/job_post/view/all_jobs.dart';
import 'package:recruiter_app/features/job_post/viewmodel.dart/job_posting_provider.dart';
import 'package:recruiter_app/features/job_post/viewmodel.dart/search_job_provider.dart';
import 'package:recruiter_app/viewmodels/job_viewmodel.dart';
import 'package:recruiter_app/widgets/common_empty_list.dart';
import 'package:recruiter_app/widgets/common_error_widget.dart';
import 'package:recruiter_app/widgets/job_card_widget.dart';
import 'package:recruiter_app/widgets/shimmer_list_loading.dart';

class RecentlyAddedJobsLists extends StatefulWidget {
  const RecentlyAddedJobsLists({Key? key}) : super(key: key);

  @override
  State<RecentlyAddedJobsLists> createState() => _RecentlyAddedJobsListsState();
}

class _RecentlyAddedJobsListsState extends State<RecentlyAddedJobsLists> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobPostingProvider>(context, listen: false).fetchJobLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Recently added job posts",
              style: theme.textTheme.titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            )
          ],
        ),
        Row(
          children: [
            Text(
              "Here is the lists of recently added jobs by you",
              style: theme.textTheme.bodyMedium!.copyWith(color: greyTextColor),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
                onTap: () {
                  Navigator.push(context, AnimatedNavigation().fadeAnimation(AllJobs()));
                  // final state = context.read<JobBloc>().state;
                  // print("Attempting to navigate... Current state: $state");

                  // if (state is JobFetchSuccess) {
                  //   print("Navigating to AllJobPosts...");
                  //   Navigator.push(
                  //     context,
                  //     AnimatedNavigation().slideAnimation(AllJobPosts(
                  //       jobLists: state.jobs,
                  //     )),
                  //   ).then((_) {
                  //     print("Returned from AllJobPosts");
                  //   });
                  // }
                },
                child: Text(
                  "View All",
                  style: theme.textTheme.bodyMedium!.copyWith(
                      color: buttonColor, fontWeight: FontWeight.bold),
                ))
          ],
        ),

        Consumer<JobPostingProvider>(builder: (context, provider, child) {
          if (provider.jobLists != null) {
            return SizedBox(
              height: 290.h,
              child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final job = provider.jobLists![index];
                    final borderColor =
                        index.isEven ? buttonColor : secondaryColor;
                    return JobCardWidget(
                      job: job,
                      borderColor: borderColor,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: provider.jobLists!.length
                  // state.jobs.length >= 3 ? 3 : state.jobs.length
                  ),
            );
          } else {
            return Text("null");
          }
        })

        // CommonErrorWidget(),
        // BlocConsumer<JobBloc, JobsState>(
        //     listener: (context, state) {},
        //     builder: (context, state) {
        //       if (state is JobLoading) {
        //         return ShimmerListLoading();
        //       } else if (state is JobEmpty) {
        //         return CommonEmptyList();
        //       } else if (state is JobFetchSuccess) {
        //         return SizedBox(
        //           height: 320.h,
        //           child: ListView.separated(
        //               physics: const NeverScrollableScrollPhysics(),
        //               itemBuilder: (context, index) {
        //                 final job = state.jobs[index];
        //                 final borderColor =
        //                     index.isEven ? buttonColor : secondaryColor;
        //                 return JobCardWidget(
        //                   job: job,
        //                   borderColor: borderColor,
        //                 );
        //               },
        //               separatorBuilder: (context, index) {
        //                 return const SizedBox(
        //                   height: 10,
        //                 );
        //               },
        //               itemCount:
        //                   state.jobs.length >= 3 ? 3 : state.jobs.length),
        //         );
        //       } else {
        //         return Column(
        //           children: [CommonErrorWidget()],
        //         );
        //       }
        //     }),
      ],
    );
  }
}
