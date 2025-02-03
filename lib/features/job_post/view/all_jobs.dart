import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/job_post/viewmodel.dart/job_posting_provider.dart';
import 'package:recruiter_app/features/navbar/view/animated_navbar.dart';
import 'package:recruiter_app/viewmodels/job_viewmodel.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';
import 'package:recruiter_app/widgets/common_empty_list.dart';
import 'package:recruiter_app/widgets/common_error_widget.dart';
import 'package:recruiter_app/widgets/common_search_widget.dart';
import 'package:recruiter_app/widgets/job_card_widget.dart';
import 'package:recruiter_app/widgets/shimmer_list_loading.dart';

class AllJobs extends StatefulWidget {
  const AllJobs({Key? key}) : super(key: key);

  @override
  _AllJobsState createState() => _AllJobsState();
}

class _AllJobsState extends State<AllJobs> {
  final TextEditingController _searchCont = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobPostingProvider>(context, listen: false).fetchJobLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height.h;
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      child: Material(
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
              SafeArea(
                child: Consumer<JobPostingProvider>(
                    builder: (context, provider, child) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        CommonAppbarWidget(
                          title: "Posted Jobs",
                          isBackArrow: true,
                          backAction: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomBottomNavBar()),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: CommonSearchWidget(
                            controller: _searchCont,
                            onChanged: (query) {
                              provider.setSearchQuery(query);
                            },
                          ),
                        ),
                      
                        provider.jobLists != null && _searchCont.text.isEmpty
                            ? SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 15,
                                    children: List.generate(
                                        provider.jobLists!.length, (index) {
                                      // final job = widget.jobLists[index];
                                      final job = provider.jobLists![index];
                                      final borderColor = index.isEven
                                          ? buttonColor
                                          : secondaryColor;
                                      return JobCardWidget(
                                        job: job,
                                        borderColor: borderColor,
                                      );
                                    }),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        provider.filteredJobs.isNotEmpty &&
                                _searchCont.text.isNotEmpty
                            ? SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 15,
                                    children: List.generate(
                                        provider.filteredJobs.length, (index) {
                                      // final job = widget.jobLists[index];
                                      final job = provider.filteredJobs[index];
                                      final borderColor = index.isEven
                                          ? buttonColor
                                          : secondaryColor;
                                      return JobCardWidget(
                                        job: job,
                                        borderColor: borderColor,
                                      );
                                    }),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
