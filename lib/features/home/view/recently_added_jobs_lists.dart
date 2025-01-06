import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/viewmodels/job_viewmodel.dart';
import 'package:recruiter_app/widgets/common_empty_list.dart';
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
    context.read<JobBloc>().add(JobFetchEvent());
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
        const SizedBox(
          height: 15,
        ),
        BlocConsumer<JobBloc, JobsState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is JobLoading) {
                return ShimmerListLoading();
              } else if (state is JobEmpty) {
                return CommonEmptyList();
              } else if (state is JobFetchSuccess) {
                return SizedBox(
                  height: 320.h,
                  child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {

                        final job = state.jobs[index];
                        return JobCardWidget(job: job,);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: 3),
                );
              } else {
                return Column(
                  children: [Text("aaaaaaaaaaaa")],
                );
              }
            }),
      ],
    );
  }
}
