import 'package:animations/animations.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/country_lists.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/core/utils/nationalities.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/details/job_details_provider.dart';
import 'package:recruiter_app/features/details/widgets/send_email_widget.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/features/navbar/view/animated_navbar.dart';
import 'package:recruiter_app/features/resdex/email_template_form.dart';
import 'package:recruiter_app/features/resdex/model/interview_model.dart';
import 'package:recruiter_app/features/resdex/model/invite_seeker_model.dart';
import 'package:recruiter_app/features/resdex/model/job_response_model.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';
import 'package:recruiter_app/features/resdex/provider/interview_provider.dart';
import 'package:recruiter_app/features/seeker_details/seeker_details.dart';
import 'package:recruiter_app/widgets/common_error_widget.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';
import 'package:recruiter_app/widgets/custom_fab_btn_widget.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';
import 'package:recruiter_app/widgets/reusable_textfield.dart';
import 'package:recruiter_app/widgets/shimmer_list_loading.dart';
import 'package:recruiter_app/widgets/shimmer_widget.dart';

class AdditionalDetailsWidget extends StatefulWidget {
  final SeekerModel? seekerData;
  final int? jobId;
  final JobPostModel jobData;
  const AdditionalDetailsWidget(
      {Key? key, this.seekerData, this.jobId, required this.jobData})
      : super(key: key);

  @override
  State<AdditionalDetailsWidget> createState() =>
      _AdditionalDetailsWidgetState();
}

class _AdditionalDetailsWidgetState extends State<AdditionalDetailsWidget> {
  bool _isLoading = true;

  List<String> selectedKeywords = [];
  String _selectedCountry = '';
  String _selectedNationality = '';
  String _selectedEducation = '';

  bool viewMore = true;
  String _selectedGender = '';
  String minExp = '';
  String maxExp = '';
  String minSalary = '';
  String maxSalary = '';
  bool addMoreFilter = false;
  bool isApplyFilter = false;

  final TextEditingController _keywordCont = TextEditingController();
  final TextEditingController _noticePeriodCont = TextEditingController();
  final TextEditingController _expYear = TextEditingController();
  final TextEditingController _expMonth = TextEditingController();

  // bottomsheet form key
  final _bottomSHeetFormKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> experienceOptions = [
    {'label': '0 - 1 Years', 'count': 162381, 'isChecked': false},
    {'label': '1 - 2 Years', 'count': 79676, 'isChecked': false},
    {'label': '2 - 5 Years', 'count': 292654, 'isChecked': false},
    {'label': '5 - 8 Years', 'count': 292429, 'isChecked': false},
    {'label': '8 - 12 Years', 'count': 307632, 'isChecked': false},
  ];
  final List<Map<String, dynamic>> salaryOptions = [
    {'label': '5000 - 10000', 'isChecked': false},
    {'label': '10000 - 20000', 'isChecked': false},
    {'label': '20000 - 50000', 'isChecked': false},
    {'label': '50000 - 100000', 'isChecked': false},
    {'label': '100000 - 150000', 'isChecked': false},
    {'label': '150000 - 200000', 'isChecked': false},
    {'label': '200000+', 'isChecked': false},
  ];

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
            .fetchSeekersInvitedToJob(jobId: widget.jobId);

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

  // Helper method to extract min and max years from label
  (int, int) _extractYearRange(String label) {
    if (label.contains('+')) {
      final number = int.parse(RegExp(r'\d+').firstMatch(label)!.group(0)!);
      return (number, number);
    }

    final numbers = RegExp(r'\d+')
        .allMatches(label)
        .map((m) => int.parse(m.group(0)!))
        .toList();
    return (numbers[0], numbers[1]);
  }

  // Method to update min and max experience based on selected checkboxes
  void _updateSalaryRange({
    required String minCont,
    required String maxiCont,
    required List<Map<String, dynamic>> lists,
  }) {
    List<Map<String, dynamic>> selectedOptions =
        lists.where((option) => option['isChecked'] == true).toList();

    if (selectedOptions.isEmpty) {
      minCont = '';
      maxiCont = '';
      setState(() {
        minExp = '';
        maxExp = '';
      });
      return;
    }

    // Extract min and max years for all selected options
    List<int> minSalaryList = selectedOptions.map((option) {
      final (min, _) = _extractYearRange(option['label']);
      return min;
    }).toList();

    List<int> maxSalaryList = selectedOptions.map((option) {
      final (_, max) = _extractYearRange(option['label']);
      return max;
    }).toList();

    // Handle cases with a single selection or multiple selections
    int minYears =
        minSalaryList.reduce((min, current) => min < current ? min : current);
    int maxYears =
        maxSalaryList.reduce((max, current) => max > current ? max : current);

    setState(() {
      minExp = minYears.toString();
      maxExp = maxYears.toString();
      minSalary = minYears.toString();
      maxSalary = maxYears.toString();
    });

    print(minYears);
    print(maxYears);
  }

  void updateCheckboxState(
      int index, bool? value, List<Map<String, dynamic>> lists) {
    setState(() {
      lists[index]['isChecked'] = value;
    });
  }

  String? selectedValue = "Job Responses";
  List<String> items = [
    'Job Responses',
    'Interview Scheduled',
    'Invitation Sent'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildApplicationResponses(
                  theme: theme, seekerData: widget.seekerData)
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 20),
            child: SpeedDial(
              activeBackgroundColor: secondaryColor,
              backgroundColor: secondaryColor,
              activeChild: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              children: <SpeedDialChild>[
                SpeedDialChild(
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: buttonColor,
                  label: "Invite  for job",
                  onTap: () {
                    Navigator.push(
                        context,
                        AnimatedNavigation()
                            .slideAnimation(const CustomBottomNavBar(
                          index: 1,
                        )));
                  },
                ),
              ],
              child: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildApplicationResponses({
    required ThemeData theme,
    SeekerModel? seekerData,
  }) {
    return Consumer<JobDetailsProvider>(builder: (context, provider, child) {
      if (_isLoading == true) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(
                width: MediaQuery.of(context).size.width * 0.4.w,
                height: 20.h,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r)),
              ),
              const RowListShimmerLoadingWidget(),
              ShimmerWidget(
                width: MediaQuery.of(context).size.width * 0.4.w,
                height: 20.h,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r)),
              ),
              const RowListShimmerLoadingWidget(),
              ShimmerWidget(
                width: MediaQuery.of(context).size.width * 0.4.w,
                height: 20.h,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r)),
              ),
              const RowListShimmerLoadingWidget(),
            ],
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedValue,
              hint: const Text('Select an option'),
              isExpanded: true,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                print(widget.jobId);
                setState(() {
                  selectedValue = newValue;
                  print(selectedValue);
                });

                if (selectedValue == "Interview Scheduled") {
                  provider.fetchInterviewScheduledSeekers(jobId: widget.jobId);
                }
                if (selectedValue == "Invitation Sent") {
                  provider.fetchSeekersInvitedToJob(jobId: widget.jobId);
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            selectedValue == "Job Responses"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Text(
                        "Job applications received to this job",
                        style: theme.textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "The following job seekers have responded to this job posting. Their applications have been submitted for review, and they are being considered based on their skills and experience",
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: greyTextColor),
                      ),
                      selectedValue == "Job Responses"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (isApplyFilter == true) {
                                      Provider.of<JobDetailsProvider>(context,
                                              listen: false)
                                          .fetchSeekersJobApplied(
                                              jobId: widget.jobId);

                                      setState(() {});
                                      (() {
                                        isApplyFilter = false;
                                      });
                                    } else {
                                      _showAnimatedBottomSheet(theme: theme);
                                    }
                                  },
                                  child: SizedBox(
                                    child: Text(
                                      isApplyFilter
                                          ? "Remove Filter"
                                          : "Advanced Filter",
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(
                                              color: secondaryColor,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : const SizedBox.shrink(),
                      if (provider.message != '')
                        _buildEmpty(theme: theme, text: "No seeker"),
                      if (provider.message == "" &&
                          provider.filteredSeekerLists == null)
                        CommonErrorWidget(),
                      if (provider.filteredSeekerLists != null &&
                          provider.message == "" &&
                          provider.filteredSeekerLists!.isEmpty)
                        _buildEmpty(theme: theme, text: "No seeker"),
                      if (provider.filteredSeekerLists != null &&
                          provider.filteredSeekerLists!.isNotEmpty &&
                          provider.message == "")
                        SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              provider.filteredSeekerLists!.length,
                              (index) {
                                return _buildSeekercardWidget(
                                  responseData:
                                      provider.filteredSeekerLists![index],
                                  theme: theme,
                                  isResponse: true,
                                  seekerData: provider
                                      .filteredSeekerLists![index].seeker,
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  )
                : const SizedBox.shrink(),
            selectedValue == "Interview Scheduled"
                ? Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Interview scheduled for this position",
                        style: theme.textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "The following job seekers have been scheduled for an interview for this position. Their applications have been reviewed, and they have been shortlisted based on their qualifications and experience",
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: greyTextColor),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (provider.interviewMessage != '')
                        _buildEmpty(theme: theme, text: "No seeker"),
                      if (provider.interviewMessage == "" &&
                          provider.interviewedSeekerLists == null)
                        CommonErrorWidget(),
                      if (provider.interviewedSeekerLists != null &&
                          provider.interviewMessage == "" &&
                          provider.interviewedSeekerLists!.isEmpty)
                        _buildEmpty(theme: theme, text: "No seeker"),
                      if (provider.interviewedSeekerLists != null &&
                          provider.interviewedSeekerLists!.isNotEmpty &&
                          provider.interviewMessage == "")
                        SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              provider.interviewedSeekerLists!.length,
                              (index) {
                                return _buildSeekercardWidget(
                                  interviewedData:
                                      provider.interviewedSeekerLists![index],
                                  isInterViewScheduled: true,
                                  theme: theme,
                                  seekerData: provider
                                      .interviewedSeekerLists![index]
                                      .seekerData,
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  )
                : const SizedBox.shrink(),
            selectedValue == "Invitation Sent"
                ? Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Invited seekers for this position",
                        style: theme.textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "The following job seekers have been invited to apply for this position. They have been selected based on their skills and experience relevant to the job requirements",
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: greyTextColor),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (provider.invitedMessage != '')
                        _buildEmpty(theme: theme, text: "No seeker"),
                      if (provider.invitedMessage == "" &&
                          provider.invitedSeekerLists == null)
                        CommonErrorWidget(),
                      if (provider.invitedSeekerLists != null &&
                          provider.invitedMessage == "" &&
                          provider.invitedSeekerLists!.isEmpty)
                        _buildEmpty(theme: theme, text: "No seeker"),
                      if (provider.invitedSeekerLists != null &&
                          provider.invitedSeekerLists!.isNotEmpty &&
                          provider.invitedMessage == "")
                        SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              provider.invitedSeekerLists!.length,
                              (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _buildSeekercardWidget(
                                    isInvited: true,
                                    invitedData:
                                        provider.invitedSeekerLists![index],
                                    theme: theme,
                                    seekerData: provider
                                        .invitedSeekerLists![index].seeker,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  )
                : const SizedBox.shrink(),
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

  Widget _buildSeekercardWidget(
      {required ThemeData theme,
      SeekerModel? seekerData,
      InterviewModel? interviewedData,
      bool? isInterViewScheduled,
      InvitedSeekerWithJob? invitedData,
      JobResponseModel? responseData,
      bool? isResponse,
      bool? isInvited}) {
    final date = DateTime.parse(interviewedData != null
        ? interviewedData.scheduledOn.toString()
        : DateTime.now().toString());
    if (seekerData != null) {}
    return AnimatedContainer(
      duration: 500.ms,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // Removes divider lines
        ),
        child: ExpansionTile(
          showTrailingIcon: false,
          title: Row(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                        image:
                            AssetImage("assets/images/default_profile.webp"))),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "👤  ${CustomFunctions.toSentenceCase(seekerData?.personalData?.user.name ?? "N/A")}",
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "👔  ${CustomFunctions.toSentenceCase(seekerData?.personalData?.user.role ?? "N/A")}",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "💼  ${seekerData?.personalData?.personal.totalExperienceYears ?? 0}yr ${seekerData?.personalData?.personal.totalExperienceMonths ?? 0}m",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      spacing: 15,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "📍  ${seekerData?.personalData?.personal.city ?? "N/A"}",
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "CTC:  ${seekerData?.employmentData?.isNotEmpty == true ? CustomFunctions().formatCTC(seekerData!.employmentData!.first.ctc) : "N/A"}",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
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
          children: [
            isInterViewScheduled == true && interviewedData != null
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Scheduled Date : ",
                                      style:
                                          theme.textTheme.bodyMedium!.copyWith(
                                        color: greyTextColor,
                                      ),
                                    ),
                                    Text(
                                        DateFormat("MMM, dd yyyy").format(date))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Scheduled Time : ",
                                      style:
                                          theme.textTheme.bodyMedium!.copyWith(
                                        color: greyTextColor,
                                      ),
                                    ),
                                    Text(DateFormat("hh:mm a").format(date))
                                  ],
                                ),
                              ],
                            ),
                            Wrap(
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {
                                    if (seekerData != null) {
                                      Navigator.push(
                                          context,
                                          AnimatedNavigation().fadeAnimation(
                                              SeekerDetails(
                                                  fromInterview: true,
                                                  seekerData: seekerData)));
                                    }
                                  },
                                  icon: Icon(Icons.visibility),
                                  label: Text(
                                    "View",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: secondaryColor),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                : isInvited == true && invitedData != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Wrap(
                              spacing: 15,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Add invite action
                                  },
                                  label: Text(
                                    invitedData.read == true
                                        ? "Read"
                                        : "Unread",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: secondaryColor),
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    if (seekerData != null) {
                                      Navigator.push(
                                          context,
                                          AnimatedNavigation().fadeAnimation(
                                              SeekerDetails(
                                                  isInvited: true,
                                                  seekerData: seekerData)));
                                    }
                                  },
                                  icon: Icon(Icons.visibility),
                                  label: Text(
                                    "View Details",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: secondaryColor),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : Column(
                        children: [
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 10,
                                  children: [
                                    OpenContainer(
                                      closedColor: Colors.white,
                                      closedElevation: 0,
                                      transitionType:
                                          ContainerTransitionType.fade,

                                      transitionDuration:
                                          const Duration(milliseconds: 500),
                                      // closedShape: RoundedRectangleBorder(
                                      //     borderRadius:
                                      //         BorderRadius.circular(25)),
                                      closedBuilder: (BuildContext context,
                                          VoidCallback openContainer) {
                                        return ElevatedButton.icon(
                                          onPressed: () {
                                            openContainer();
                                          },
                                          icon: const Icon(
                                            Icons.send,
                                            color: secondaryColor,
                                          ),
                                          label: Text(
                                            "Email",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                    color: secondaryColor),
                                          ),
                                        );
                                      },
                                      openBuilder: (BuildContext context,
                                          VoidCallback closeContainer) {
                                        if (seekerData != null) {
                                          return SendEmailWidget(
                                            seekerData: seekerData!,
                                          );
                                        } else {
                                          return const Center(
                                            child: CommonErrorWidget(),
                                          );
                                        }
                                      },
                                    ),
                                    Consumer<InterviewProvider>(
                                      builder:
                                          (context, interviewProvider, child) {
                                        bool isSeekerInList =
                                            interviewProvider.seekerLists !=
                                                    null
                                                ? interviewProvider.seekerLists!
                                                    .any((item) {
                                                    return item
                                                            .seeker
                                                            .personalData
                                                            ?.personal
                                                            .id ==
                                                        widget
                                                            .seekerData
                                                            ?.personalData
                                                            ?.personal
                                                            .id;
                                                  })
                                                : false;

                                        return ElevatedButton.icon(
                                          onPressed: () {
                                            if (seekerData != null &&
                                                seekerData.personalData !=
                                                    null) {
                                              _showInterviewScheduleSheet(
                                                name: seekerData
                                                    .personalData!.user.name
                                                    .toString(),
                                                seekerData: seekerData,
                                                seekerId: seekerData
                                                    .personalData!.personal.id,
                                                theme: theme,
                                              );
                                            }
                                          },
                                          icon: Icon(Icons.calendar_month),
                                          label: Text(
                                            isSeekerInList
                                                ? "Schedule Interview"
                                                : "Already Scheduled",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                    color: secondaryColor),
                                          ),
                                        );
                                      },
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        // Add invite action
                                      },
                                      icon: Icon(Icons.download),
                                      label: Text(
                                        "Download CV",
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(color: secondaryColor),
                                      ),
                                    ),
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        if (seekerData != null) {
                                          Navigator.push(
                                              context,
                                              AnimatedNavigation()
                                                  .fadeAnimation(SeekerDetails(
                                                      // jobData: widget.jobData,
                                                      // responseData: responseData,
                                                      fromResponse: true,
                                                      seekerData: seekerData)));
                                        }
                                      },
                                      icon: const Icon(Icons.visibility),
                                      label: Text(
                                        "View Details",
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(color: secondaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.5, end: 0);
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

  void _showAnimatedBottomSheet({required ThemeData theme}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
        return Container(
          // height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _bottomSHeetFormKey,
              child: Column(
                children: [
                  // Drag Handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Title
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter candidates',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close))
                      ],
                    ),
                  ),
                  Divider(
                    endIndent: 15,
                    indent: 15,
                  ),

                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 15,
                        children: [
                          _buildBottomsheetItem(
                              theme: theme,
                              text: "Search with keywords",
                              validation: (_) {},
                              controller: TextEditingController(),
                              onSubmit: (value) {
                                if (value != "") {
                                  setModalState(() {
                                    selectedKeywords.add(value);
                                    _keywordCont.clear();
                                  });
                                }
                              }),
                          if (selectedKeywords.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Selected skills:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Wrap(
                                    spacing: 8.w,
                                    runSpacing: 8.h,
                                    children: selectedKeywords.map((location) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: buttonColor.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              location,
                                              style: AppTheme.mediumTitleText(
                                                  lightTextColor),
                                            ),
                                            SizedBox(width: 4.w),
                                            GestureDetector(
                                              onTap: () {
                                                setModalState(() {
                                                  selectedKeywords
                                                      .remove(location);
                                                });
                                                print(selectedKeywords);
                                              },
                                              child: Icon(
                                                Icons.close,
                                                size: 16.sp,
                                                color: greyTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),

                          _buildBottomsheetTitle(
                              theme: theme, text: "Experience"),

                          Row(
                            spacing: 15,
                            children: [
                              Expanded(
                                  child: ReusableTextfield(
                                controller: _expYear,
                                labelText: "Years",
                                hintText: "0",
                                keyBoardType: TextInputType.number,
                              )),
                              Expanded(
                                  child: ReusableTextfield(
                                controller: _expMonth,
                                labelText: "Months",
                                hintText: "0",
                                keyBoardType: TextInputType.number,
                              ))
                            ],
                          ),

                          // salary
                          _buildBottomsheetTitle(theme: theme, text: "Salary"),
                          Column(
                            children:
                                List.generate(salaryOptions.length, (index) {
                              final option = salaryOptions[index];
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        activeColor: secondaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3.r)),
                                        value: option['isChecked'],
                                        onChanged: (value) {
                                          setModalState(() {
                                            updateCheckboxState(
                                                index, value, salaryOptions);
                                          });

                                          _updateSalaryRange(
                                              maxiCont: maxSalary,
                                              minCont: minSalary,
                                              lists: salaryOptions);

                                          print(minSalary);
                                          print(maxSalary);
                                        },
                                      ),
                                      Text(option['label']),
                                    ],
                                  ),
                                ],
                              );
                            }),
                          ),

                          Divider(),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  spacing: 5,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // _buildBottomsheetTitle(
                                    //     theme: theme, text: "Country"),
                                    _buildDropdownWidget(
                                        theme: theme,
                                        selectedVariable: _selectedCountry,
                                        list: countryLists,
                                        hintText: "Select country",
                                        labelText: "Country",
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              _selectedCountry = value;
                                            });
                                          }
                                        }),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  spacing: 5,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // _buildBottomsheetTitle(
                                    //     theme: theme, text: "Nationality"),
                                    _buildDropdownWidget(
                                        theme: theme,
                                        selectedVariable: _selectedNationality,
                                        list: nationalities,
                                        hintText: "Select nationality",
                                        labelText: "Nationality",
                                        onChanged: (value) {
                                          if (value != null) {
                                            setModalState(() {
                                              _selectedNationality = value;
                                            });
                                          }
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                              // _buildBottomsheetTitle(
                              //     theme: theme, text: "Gender"),
                              Container(
                                height: 45.h,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(color: borderColor),
                                    borderRadius:
                                        BorderRadius.circular(borderRadius)),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: DropdownButton<String>(
                                    value: _selectedGender.isEmpty
                                        ? null
                                        : _selectedGender,
                                    isExpanded: true,
                                    hint: const Text("Select gender"),
                                    underline: const SizedBox(),
                                    borderRadius: BorderRadius.circular(15.r),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    items: [
                                      "Male",
                                      "Female",
                                      "Other",
                                    ]
                                        .map((String value) =>
                                            DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            ))
                                        .toList(),
                                    onChanged: (String? newValue) {
                                      setModalState(() {
                                        _selectedGender = newValue ?? '';
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // additional filters
                  addMoreFilter
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              Text(
                                "Additional filters",
                                style: theme.textTheme.bodyLarge!
                                    .copyWith(color: greyTextColor),
                              ),
                              _buildDropdownWidget(
                                  theme: theme,
                                  selectedVariable: _selectedEducation,
                                  list: [
                                    "Primary education",
                                    "Secondary education or high school",
                                    "Graduation",
                                    "Vocational qualification",
                                    "Bachelor's degree",
                                    "Master's degree",
                                    "Doctorate or higher"
                                  ],
                                  hintText: "Select education",
                                  labelText: "Education",
                                  onChanged: (value) {
                                    setModalState(() {
                                      _selectedEducation = value ?? '';
                                    });
                                  }),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildBottomsheetTitle(
                                      theme: theme, text: "Notice period"),
                                  ReusableTextfield(
                                    controller: _noticePeriodCont,
                                    hintText: "Enter the notice period",
                                    keyBoardType: TextInputType.number,
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),

                  InkWell(
                      onTap: () {
                        setModalState(() {
                          addMoreFilter = !addMoreFilter;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: buttonColor.withValues(alpha: 0.3),
                            borderRadius:
                                BorderRadiusDirectional.circular(8.r)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            addMoreFilter
                                ? "Remove additional filter"
                                : "Click here to add more filter",
                            style: theme.textTheme.bodyMedium!.copyWith(
                                color: buttonColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),

                  const SizedBox(
                    height: 20,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      spacing: 15,
                      children: [
                        Expanded(
                          child: _buildBottomsheetBtn(
                            text: "Apply filter",
                            theme: theme,
                            color: buttonColor,
                            action: () {
                              Provider.of<JobDetailsProvider>(context,
                                      listen: false)
                                  .filterSeekers(gender: "male");

                              setModalState(() {
                                isApplyFilter = true;
                              });

                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Expanded(
                          child: _buildBottomsheetBtn(
                            text: "Remove filter",
                            theme: theme,
                            action: () {
                              Provider.of<JobDetailsProvider>(context,
                                      listen: false)
                                  .fetchSeekersJobApplied(jobId: widget.jobId);

                              setModalState(() {
                                isApplyFilter = false;
                              });

                              Navigator.pop(context);
                            },
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBottomsheetBtn({
    required String text,
    required ThemeData theme,
    required VoidCallback action,
    required Color color,
  }) {
    return InkWell(
        onTap: action,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadiusDirectional.circular(8.r)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildBottomsheetTitle(
      {required ThemeData theme, required String text}) {
    return Text(
      text,
      style: theme.textTheme.bodyLarge,
    );
  }

  Widget _buildDropdownWidget(
      {required ThemeData theme,
      required String selectedVariable,
      required List<String> list,
      required String hintText,
      required String labelText,
      required Function(String?)? onChanged}) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 55.h,
      ),
      child: DropdownSearch<String>(
        validator: (_) {
          if (selectedVariable == '') {
            return "This field is required";
          }
          return null;
        },
        decoratorProps: DropDownDecoratorProps(
          expands: false,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor),
            ),
          ),
        ),
        items: (filter, infiniteScrollProps) => list,
        selectedItem: selectedVariable.isEmpty ? null : selectedVariable,
        onChanged: onChanged,
        popupProps: PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: borderColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomsheetItem({
    required ThemeData theme,
    required String text,
    required String? Function(String?)? validation,
    required TextEditingController controller,
    Function(String)? onSubmit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          text,
          style: theme.textTheme.bodyLarge,
        ),
        ReusableTextfield(
          controller: controller,
          onSubmit: onSubmit,
        )
      ],
    );
  }

  void _showInterviewScheduleSheet(
      {required ThemeData theme,
      required String name,
      required int seekerId,
      required SeekerModel seekerData}) {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                height: 330.h,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 2,
                            width: 90,
                            decoration: BoxDecoration(color: borderColor),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Schedule interview with ",
                                style: theme.textTheme.titleMedium!.copyWith(),
                              ),
                              Text(
                                " ${CustomFunctions.toSentenceCase(seekerData.personalData!.user.name.toString())}",
                                style: theme.textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: buttonColor),
                              )
                            ],
                          )
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideX(begin: -0.3, end: 0),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Select a job from the list below to schedule interview with the candidate and match them with the right opportunity",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: greyTextColor),
                          )
                              .animate()
                              .fadeIn(duration: 700.ms)
                              .slideX(begin: -0.4, end: 0),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Schedule inter for", //  "Select job from below:",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: greyTextColor),
                          )
                              .animate()
                              .fadeIn(duration: 700.ms)
                              .slideX(begin: -0.4, end: 0),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            CustomFunctions.toSentenceCase(
                                widget.jobData.title.toString()),
                            style: theme.textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Please select the date and time for the interview schedule",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: greyTextColor),
                          )
                              .animate()
                              .fadeIn(duration: 700.ms)
                              .slideX(begin: -0.4, end: 0),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(selectedDate == null
                                  ? "Select Date"
                                  : "${selectedDate!.toLocal()}".split(' ')[0]),
                              InkWell(
                                  onTap: () async {
                                    final DateTime? pickedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (pickedDate != null) {
                                      setModalState(() {
                                        selectedDate = pickedDate;
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    Icons.calendar_month,
                                    color: buttonColor,
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedTime == null
                                    ? "Select Time"
                                    : "Time : ${selectedTime!.format(context)}",
                              ),
                              InkWell(
                                  onTap: () async {
                                    final TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      setModalState(() {
                                        selectedTime = pickedTime;
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    Icons.alarm,
                                    color: buttonColor,
                                  )),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Consumer<InterviewProvider>(
                            builder: (context, provider, child) {
                          return ReusableButton(
                                  textColor: Colors.white,
                                  buttonColor: selectedTime != null &&
                                          selectedDate != null
                                      ? secondaryColor
                                      : secondaryColor.withValues(alpha: 0.6),
                                  action: () async {
                                    if (widget.jobId != null &&
                                        seekerData.personalData != null) {
                                      final DateTime combinedDateTime =
                                          DateTime(
                                        selectedDate!.year,
                                        selectedDate!.month,
                                        selectedDate!.day,
                                        selectedTime!.hour,
                                        selectedTime!.minute,
                                      );

                                      // Format the date-time
                                      final formattedDateTime = DateFormat(
                                              "yyyy-MM-ddTHH:mm:ss.SSS'Z'")
                                          .format(combinedDateTime);

                                      final result =
                                          await provider.scheduleInterview(
                                              candidateId: seekerData
                                                  .personalData!.personal.id,
                                              jobId: widget.jobId!,
                                              date: formattedDateTime);

                                      if (result == true) {
                                        Navigator.pop(context);

                                        CommonSnackbar.show(context,
                                            message:
                                                "Invitation to seeker sent successfully!");
                                      } else {
                                        Navigator.pop(context);
                                        CommonSnackbar.show(context,
                                            message: "${provider.message}!");
                                      }
                                    } else {
                                      print("llllllllllllllllllllll");
                                    }
                                  },
                                  text: "Schedule Interview")
                              .animate()
                              .fadeIn(duration: 500.ms)
                              .slideY(begin: 0.5, end: 0);
                        }),
                      )
                    ],
                  ),
                ),
              );
            }));
  }

  void _showInviteSheet(
      {required ThemeData theme,
      required String name,
      required int seekerId,
      required SeekerModel seekerData}) {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                height: 330.h,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 2,
                            width: 90,
                            decoration: BoxDecoration(color: borderColor),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Schedule interview with ",
                                style: theme.textTheme.titleMedium!.copyWith(),
                              ),
                              Text(
                                " ${CustomFunctions.toSentenceCase(seekerData.personalData!.user.name.toString())}",
                                style: theme.textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: buttonColor),
                              )
                            ],
                          )
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideX(begin: -0.3, end: 0),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Select a job from the list below to schedule interview with the candidate and match them with the right opportunity",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: greyTextColor),
                          )
                              .animate()
                              .fadeIn(duration: 700.ms)
                              .slideX(begin: -0.4, end: 0),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Schedule inter for", //  "Select job from below:",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: greyTextColor),
                          )
                              .animate()
                              .fadeIn(duration: 700.ms)
                              .slideX(begin: -0.4, end: 0),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            CustomFunctions.toSentenceCase(
                                widget.jobData.title.toString()),
                            style: theme.textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Please select the date and time for the interview schedule",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: greyTextColor),
                          )
                              .animate()
                              .fadeIn(duration: 700.ms)
                              .slideX(begin: -0.4, end: 0),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(selectedDate == null
                                  ? "Select Date"
                                  : "${selectedDate!.toLocal()}".split(' ')[0]),
                              InkWell(
                                  onTap: () async {
                                    final DateTime? pickedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (pickedDate != null) {
                                      setModalState(() {
                                        selectedDate = pickedDate;
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    Icons.calendar_month,
                                    color: buttonColor,
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedTime == null
                                    ? "Select Time"
                                    : "Time : ${selectedTime!.format(context)}",
                              ),
                              InkWell(
                                  onTap: () async {
                                    final TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      setModalState(() {
                                        selectedTime = pickedTime;
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    Icons.alarm,
                                    color: buttonColor,
                                  )),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Consumer<InterviewProvider>(
                            builder: (context, provider, child) {
                          return ReusableButton(
                                  textColor: Colors.white,
                                  buttonColor: selectedTime != null &&
                                          selectedDate != null
                                      ? secondaryColor
                                      : secondaryColor.withValues(alpha: 0.6),
                                  action: () async {
                                    if (widget.jobId != null &&
                                        seekerData.personalData != null) {
                                      final DateTime combinedDateTime =
                                          DateTime(
                                        selectedDate!.year,
                                        selectedDate!.month,
                                        selectedDate!.day,
                                        selectedTime!.hour,
                                        selectedTime!.minute,
                                      );

                                      // Format the date-time
                                      final formattedDateTime = DateFormat(
                                              "yyyy-MM-ddTHH:mm:ss.SSS'Z'")
                                          .format(combinedDateTime);

                                      final result =
                                          await provider.scheduleInterview(
                                              candidateId: seekerData
                                                  .personalData!.personal.id,
                                              jobId: widget.jobId!,
                                              date: formattedDateTime);

                                      if (result == true) {
                                        Navigator.pop(context);

                                        CommonSnackbar.show(context,
                                            message:
                                                "Invitation to seeker sent successfully!");
                                      } else {
                                        Navigator.pop(context);
                                        CommonSnackbar.show(context,
                                            message: "${provider.message}!");
                                      }
                                    } else {
                                      print("llllllllllllllllllllll");
                                    }
                                  },
                                  text: "Schedule Interview")
                              .animate()
                              .fadeIn(duration: 500.ms)
                              .slideY(begin: 0.5, end: 0);
                        }),
                      )
                    ],
                  ),
                ),
              );
            }));
  }
}
