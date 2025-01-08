import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/city_lists.dart';
import 'package:recruiter_app/core/utils/country_lists.dart';
import 'package:recruiter_app/core/utils/currency_lists.dart';
import 'package:recruiter_app/core/utils/functional_area_lists.dart';
import 'package:recruiter_app/core/utils/industry_lists.dart';
import 'package:recruiter_app/core/utils/nationalities.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/core/utils/skills.dart';
import 'package:recruiter_app/core/utils/states.dart';
import 'package:recruiter_app/features/job_post/data/job_post_repository.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/features/job_post/view/preview_job.dart';
import 'package:recruiter_app/features/job_post/viewmodel.dart/jobpost_provider.dart';
import 'package:recruiter_app/features/navbar/view/navbar.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';
import 'package:recruiter_app/widgets/reusable_textfield.dart';

class JobPostForm extends StatefulWidget {
  const JobPostForm({Key? key}) : super(key: key);

  @override
  _JobPostFormState createState() => _JobPostFormState();
}

class _JobPostFormState extends State<JobPostForm> {
  final TextEditingController _titleCont = TextEditingController();
  final TextEditingController _descriptionCont = TextEditingController();
  final TextEditingController _vaccancyCont = TextEditingController();
  final TextEditingController _countryCont = TextEditingController();
  final TextEditingController _industryCont = TextEditingController();
  final TextEditingController _areaCont = TextEditingController();
  final TextEditingController _genderCont = TextEditingController();
  final TextEditingController _minExpCont = TextEditingController();
  final TextEditingController _maxExpCont = TextEditingController();
  final TextEditingController _nationalityCont = TextEditingController();
  final TextEditingController _preferredLocationsCont = TextEditingController();
  final TextEditingController _educationCont = TextEditingController();
  final TextEditingController _minSalaryCont = TextEditingController();
  final TextEditingController _maxSalaryCont = TextEditingController();
  final TextEditingController _skillCont = TextEditingController();
  final TextEditingController _roleDescriptionCont = TextEditingController();

  String _selectedIndustry = '';
  String _selectedFunctionalArea = '';
  String _selectedCity = '';
  String _selectedCountry = '';
  String _selectedGender = '';
  String _selectedNationality = '';
  String _selectedType = '';
  String _selectedEducation = '';
  String _selectedSkill = '';
  String _selectedLocation = '';
  String _selectedCurrency = 'INR';

  List<String> selectedLocations = [];
  List<String> _states = [];
  List<String> selectedSkills = [];

  bool isLoading = false;

  final _jobDetailsForm = GlobalKey<FormState>();
  final _candidateDetailsForm = GlobalKey<FormState>();
  final _salaryDetailsForm = GlobalKey<FormState>();

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _fetchStates();
  }

  void _fetchStates() {
    for (var item in states) {
      _states.add(item["name"]);
    }
  }

  bool validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _jobDetailsForm.currentState?.validate() ?? false;
      case 1:
        return _candidateDetailsForm.currentState?.validate() ?? false;
      case 2:
        return _salaryDetailsForm.currentState?.validate() ?? false;
      default:
        return false;
    }
  }

  void handleNext(ThemeData theme) async {
    if (validateCurrentStep()) {
      setState(() {
        if (_currentStep < getSteps(theme).length - 1) {
          _currentStep++;
        } else {
          submitForm();
        }
      });
    }
  }

  void submitForm() {
    final job = JobPostModel(
      candidateLocation: [_selectedLocation],
      city: _selectedCity,
      country: _selectedCountry,
      description: 
          "Roles and responsibilities:${_roleDescriptionCont.text}\nCandidate's desired profile:\n${_descriptionCont.text}",
      education: _selectedEducation,
      functionalArea: _selectedFunctionalArea,
      gender: _selectedGender,
      industry: _selectedIndustry,
      jobType: _selectedType,
      maximumExperience: int.parse(_minExpCont.text),
      maximumSalary: int.parse(_maxSalaryCont.text),
      minimumExperience: int.parse(_minExpCont.text),
      minimumSalary: int.parse(_minSalaryCont.text),
      nationality: _selectedNationality,
      title: _titleCont.text,
      vaccancy: int.parse(_vaccancyCont.text),
    );

    context.read<JobPostBloc>().add(JobPostFormEvent(job: job));
  }

  List<Step> getSteps(ThemeData theme) {
    return [
      Step(
        title: const Text('Personal'),
        content: _buildJobDetailsForm(theme: theme),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Address'),
        content: _buildCandidateProfile(theme: theme),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Confirm'),
        content: _buildSalaryDetailsForm(theme: theme),
        isActive: _currentStep >= 2,
      ),
    ];
  }

  Widget _buildStep(int index, String title, bool isActive, StepState state) {
    return Container(
      child: Row(
        children: [
          // Circle with number
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isActive ? secondaryColor : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: state == StepState.complete
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
            ),
          ),
          if (index < 2) _buildDivider(), // Don't add divider after last step
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 70,
      height: 1,
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
        child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 237, 237),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              "assets/svgs/group_circle.svg",
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          bool isActive = _currentStep >= index;
                          StepState state = _currentStep > index
                              ? StepState.complete
                              : StepState.indexed;
                          return _buildStep(
                            index,
                            ['Personal', 'Address', 'Confirm'][index],
                            isActive,
                            state,
                          );
                        }),
                      ),
                    ),
                    Column(
                      children: [
                        getSteps(theme)[_currentStep].content,
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_currentStep > 0)
                                Expanded(
                                  child: ReusableButton(
                                      action: () {
                                        setState(() {
                                          if (_currentStep > 0) {
                                            _currentStep--;
                                          }
                                        });
                                      },
                                      text: "BACK",
                                      buttonColor: buttonColor),
                                ),
                              if (_currentStep > 0) const SizedBox(width: 16),

                              Expanded(
                                child: ReusableButton(
                                    action: () async {
                                      handleNext(theme);
                                    },
                                    text: _currentStep <
                                            getSteps(theme).length - 1
                                        ? 'NEXT'
                                        : 'FINISH',
                                    buttonColor: buttonColor),
                              ),

                              // ElevatedButton(
                              //   onPressed: () {
                              //     setState(() {
                              //       if (_currentStep < getSteps(theme).length - 1) {
                              //         _currentStep++;
                              //       }
                              //     });
                              //   },
                              //   child: Text(
                              //     _currentStep < getSteps(theme).length - 1
                              //         ? 'NEXT'
                              //         : 'FINISH',
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // child: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     // job details input
                //     _buildJobDetailsForm(theme: theme),

                //     const SizedBox(
                //       height: 20,
                //     ),
                //     // candidate profile
                //     _buildCandidateProfile(theme: theme),
                //     const SizedBox(
                //       height: 20,
                //     ),
                //     //  salary details of job
                //     _buildSalaryDetailsForm(theme: theme),
                //     const SizedBox(
                //       height: 20,
                //     ),
                //     _buildQuestionsWidget(theme: theme),

                //     BlocConsumer<JobPostBloc, JobPostState>(
                //         listener: (context, state) {
                //       if (state is JobSubmitSuccess) {
                //         CommonSnackbar.show(context,
                //             message: "Job posted successfully");
                //         Navigator.pushReplacement(context,
                //             AnimatedNavigation().slideAnimation(Navbar()));
                //       }

                //       if (state is JobSubmitFailure) {
                //         CommonSnackbar.show(context,
                //             message:
                //                 "Failed to create job. Please try again later");
                //       }
                //     }, builder: (context, state) {
                //       return ReusableButton(
                //           isLoading: state is JobPostLoading,
                //           textColor: Colors.white,
                //           action: () async {
                //             if (_jobDetailsForm.currentState!.validate() &&
                //                 _candidateDetailsForm.currentState!
                //                     .validate() &&
                //                 _salaryDetailsForm.currentState!.validate()) {
                //               final job = JobPostModel(
                //                 candidateLocation: _selectedLocation,
                //                 city: _selectedCity,
                //                 country: _selectedCountry,
                //                 description:
                //                     "Roles and responsibilities:\n${_roleDescriptionCont.text}\nCandidate's desired profile:\n${_descriptionCont.text}",
                //                 education: _selectedEducation,
                //                 functionalArea: _selectedFunctionalArea,
                //                 gender: _selectedGender,
                //                 industry: _selectedIndustry,
                //                 jobType: _selectedType,
                //                 maximumExperience: int.parse(_minExpCont.text),
                //                 maximumSalary: int.parse(_maxSalaryCont.text),
                //                 minimumExperience: int.parse(_minExpCont.text),
                //                 minimumSalary: int.parse(_minSalaryCont.text),
                //                 nationality: _selectedNationality,
                //                 title: _titleCont.text,
                //                 vaccancy: int.parse(_vaccancyCont.text),
                //               );

                //               // Navigator.push(context, AnimatedNavigation().slideAnimation(PreviewJob(jobData: job)));

                //               // context
                //               //     .read<JobPostBloc>()
                //               //     .add(JobPostFormEvent(job: job));
                //             }
                //           },
                //           text: "Post job",
                //           buttonColor: buttonColor);
                //     })
                //   ],
                // ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildJobDetailsForm({required ThemeData theme}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _jobDetailsForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeadingWidget(
                  theme: theme,
                  heading: "Enter job details",
                  subHeading: "Enter the basic job details"),
              const SizedBox(
                height: 15,
              ),
              _buildTitleWidget(
                  theme: theme, title: "Job title", isSubtitle: false),
              const SizedBox(
                height: 10,
              ),
              Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableTextfield(
                    controller: _titleCont,
                    labelText: "job title",
                    hintText: "Enter the job title that matches the job role",
                    validation: (_) {
                      if (_titleCont.text.trim().isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  _buildDescriptionWidget(theme: theme),
                  _buildTitleWidget(
                      theme: theme,
                      title: "Candidate Skills",
                      isSubtitle: true,
                      subTitle: "Choose the skills required for this job role"),
                  ReusableTextfield(
                    controller: _skillCont,
                    labelText: "Skills",
                    validation: (_) {
                      if (selectedSkills.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                    float: FloatingLabelBehavior.never,
                    hintText: "Enter the skills associated with this job",
                    onSubmit: (value) {
                      if (value.isNotEmpty && !selectedSkills.contains(value)) {
                        setState(() {
                          _selectedSkill = value;
                          selectedSkills.add(value);
                          _skillCont.clear();
                        });
                      }
                    },
                  ),
                  if (selectedSkills.isNotEmpty)
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
                            children: selectedSkills.map((location) {
                              return Container(
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
                                    Text(
                                      location,
                                      style: AppTheme.mediumTitleText(
                                          lightTextColor),
                                    ),
                                    SizedBox(width: 4.w),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedSkills.remove(location);
                                        });
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
                  _buildTitleWidget(
                      theme: theme,
                      title: "Job type",
                      isSubtitle: true,
                      subTitle: "Select the type of employment for this role"),
                  _buildDropdownWidget(
                    theme: theme,
                    selectedVariable: _selectedType,
                    list: [
                      "On site",
                      "Work from home",
                      "Internship",
                      "Contract",
                      "Remote",
                    ],
                    hintText: "Select job type...",
                    labelText: "Job type",
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType = newValue ?? "";
                      });
                    },
                  ),
                  _buildTitleWidget(
                      theme: theme,
                      title: "Vaccancies",
                      isSubtitle: true,
                      subTitle:
                          "Indicate the number of positions available for this role"),
                  ReusableTextfield(
                    controller: _vaccancyCont,
                    labelText: "vaccanies",
                    hintText: "Enter number of vaccancy",
                    keyBoardType: TextInputType.number,
                    float: FloatingLabelBehavior.never,
                    validation: (_) {
                      if (_vaccancyCont.text.trim().isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  _buildTitleWidget(
                      theme: theme, title: "Job Location", isSubtitle: false),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownWidget(
                          theme: theme,
                          selectedVariable: _selectedCity,
                          list: cities,
                          hintText: "Search city...",
                          labelText: "City",
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCity = newValue ?? "";
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: _buildDropdownWidget(
                          theme: theme,
                          selectedVariable: _selectedCountry,
                          list: countryLists,
                          hintText: "Search country...",
                          labelText: "Country",
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCountry = newValue ?? "";
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  _buildDropdownWidget(
                    theme: theme,
                    selectedVariable: _selectedIndustry,
                    list: industryLists,
                    hintText: "Search industry...",
                    labelText: "Industry",
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedIndustry = newValue ?? "";
                      });
                    },
                  ),
                  _buildDropdownWidget(
                    theme: theme,
                    selectedVariable: _selectedFunctionalArea,
                    list: functionalAreaLists,
                    hintText: "Select area...",
                    labelText: "Functional area",
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedFunctionalArea = newValue ?? "";
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionWidget({required ThemeData theme}) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidget(
            theme: theme,
            title: "Job Description",
            isSubtitle: true,
            subTitle:
                "Begin creating a compelling job description that stands out!"),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(10.r)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text("Roles and Responsibilities",
                    style: theme.textTheme.titleLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(
                  "Outline the key activities and responsibilities that define the role and showcase its impact!",
                  style:
                      theme.textTheme.bodySmall!.copyWith(color: greyTextColor),
                ),
                ReusableTextfield(
                  controller: _roleDescriptionCont,
                  maxLines: 10,
                  validation: (_) {
                    if (_roleDescriptionCont.text.trim().isEmpty) {
                      return "This field is required";
                    }
                    return null;
                  },
                  borderColor: Colors.transparent,
                ),
                Text("Desired Candidate Profile",
                    style: theme.textTheme.titleLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(
                  "Highlight the ideal candidate's skills, relevant experience, certifications, and qualifications to excel in the role!",
                  style:
                      theme.textTheme.bodySmall!.copyWith(color: greyTextColor),
                ),
                ReusableTextfield(
                  controller: _descriptionCont,
                  maxLines: 10,
                  validation: (_) {
                    if (_descriptionCont.text.trim().isEmpty) {
                      return "This field is required";
                    }
                    return null;
                  },
                  borderColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCandidateProfile({required ThemeData theme}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _candidateDetailsForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            children: [
              _buildHeadingWidget(
                  theme: theme,
                  heading: "Enter desired candidate profile details",
                  subHeading: "Choose your candidate preferences"),
              _buildTitleWidget(
                  theme: theme, title: "Gender", isSubtitle: false),
              Container(
                height: 45.h,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(borderRadius)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: DropdownButton<String>(
                    value: _selectedGender.isEmpty ? null : _selectedGender,
                    isExpanded: true,
                    hint: const Text("Select gender"),
                    underline: const SizedBox(),
                    borderRadius: BorderRadius.circular(15.r),
                    style: Theme.of(context).textTheme.bodyLarge,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    items: [
                      "Male",
                      "Female",
                      "Other",
                    ]
                        .map((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue ?? '';
                      });
                    },
                  ),
                ),
              ),
              Row(
                spacing: 10.w,
                children: [
                  Expanded(
                    child: ReusableTextfield(
                      controller: _minExpCont,
                      labelText: "Min experience",
                      keyBoardType: TextInputType.number,
                      validation: (_) {
                        if (_minExpCont.text.trim().isEmpty) {
                          return "This field is required";
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                      child: ReusableTextfield(
                    controller: _maxExpCont,
                    labelText: "Max experience",
                    keyBoardType: TextInputType.number,
                    validation: (_) {
                      if (_maxExpCont.text.trim().isEmpty) {
                        return "This field is required";
                      } else if (int.parse(_maxExpCont.text) <
                          int.parse(_minExpCont.text)) {
                        return "Maximum experience is must be greater than minimum experience";
                      }
                      return null;
                    },
                  )),
                ],
              ),
              _buildDropdownWidget(
                theme: theme,
                selectedVariable: _selectedNationality,
                list: nationalities,
                hintText: "Select nationality",
                labelText: "Nationality",
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedNationality = newValue ?? "";
                  });
                },
              ),
              _buildDropdownWidget(
                theme: theme,
                selectedVariable: _selectedLocation,
                list: _states,
                hintText: "Select area...",
                labelText: "Functional area",
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLocation = newValue ?? "";
                    selectedLocations.add(newValue.toString());
                  });
                },
              ),
              if (selectedLocations.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selected Locations:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: selectedLocations.map((location) {
                          return Container(
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
                                Text(
                                  location,
                                  style:
                                      AppTheme.mediumTitleText(lightTextColor),
                                ),
                                SizedBox(width: 4.w),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedLocations.remove(location);
                                    });
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
                hintText: "Select education...",
                labelText: "Qualification",
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedEducation = newValue ?? "";
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalaryDetailsForm({required ThemeData theme}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _salaryDetailsForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            children: [
              _buildHeadingWidget(
                  theme: theme,
                  heading: "Salary Details",
                  subHeading:
                      "Add monthly salary associated with this job role"),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      height: 45.h,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(borderRadius)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: DropdownButton<String>(
                          value: _selectedCurrency.isEmpty
                              ? null
                              : _selectedCurrency,
                          isExpanded: true,
                          hint: const Text("INR"),
                          underline: const SizedBox(),
                          borderRadius: BorderRadius.circular(15.r),
                          style: Theme.of(context).textTheme.bodyLarge,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          items: currencyCodes
                              .map((String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCurrency = newValue ?? '';
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      // flex: 1,
                      child: ReusableTextfield(
                    controller: _minSalaryCont,
                    labelText: "Min salary",
                    validation: (_) {
                      if (_minSalaryCont.text.trim().isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  )),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    // flex: 1,
                    child: ReusableTextfield(
                      controller: _maxSalaryCont,
                      labelText: 'Max salary',
                      validation: (_) {
                        if (_maxSalaryCont.text.trim().isEmpty) {
                          return "This field is required";
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionsWidget({required ThemeData theme}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            _buildTitleWidget(
                theme: theme,
                title: "Custom questions for candidate",
                isSubtitle: true,
                subTitle:
                    "You can add questions that candidates can answer while applying for this job."),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {},
                    child: Text(
                      "+ Add question",
                      style: theme.textTheme.bodyMedium!.copyWith(
                          color: secondaryColor, fontWeight: FontWeight.bold),
                    )),
                Text(
                  "You can add upto 5 questions",
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: greyTextColor,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleWidget(
      {required ThemeData theme,
      required String title,
      required bool isSubtitle,
      String? subTitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 3,
          children: [
            Text(title,
                style: theme.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text("*",
                style: theme.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.red))
          ],
        ),
        isSubtitle == true
            ? Text(
                subTitle ?? "",
                style:
                    theme.textTheme.bodyMedium!.copyWith(color: greyTextColor),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildHeadingWidget(
      {required ThemeData theme,
      required String heading,
      required String subHeading}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: theme.textTheme.headlineMedium,
        ),
        Text(
          subHeading,
          style: theme.textTheme.bodyMedium!.copyWith(color: greyTextColor),
        ),
      ],
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
      // height: 54.h,
      // color: Colors.green,
      constraints: BoxConstraints(
        maxHeight: 55.h, // Adjust this value as needed
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
}
