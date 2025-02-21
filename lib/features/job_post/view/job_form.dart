import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/city_lists.dart';
import 'package:recruiter_app/core/utils/country_lists.dart';
import 'package:recruiter_app/core/utils/currency_lists.dart';
import 'package:recruiter_app/core/utils/functional_area_lists.dart';
import 'package:recruiter_app/core/utils/industry_lists.dart';
import 'package:recruiter_app/core/utils/nationalities.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/core/utils/states.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/features/job_post/view/all_jobs.dart';
import 'package:recruiter_app/features/job_post/viewmodel.dart/job_posting_provider.dart';
import 'package:recruiter_app/features/job_post/viewmodel.dart/jobpost_provider.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';
import 'package:recruiter_app/widgets/reusable_textfield.dart';

class JobForm extends StatefulWidget {
  final JobPostModel? jobData;
  final bool? isEdit;
  const JobForm({Key? key, this.jobData, this.isEdit}) : super(key: key);

  @override
  _JobFormState createState() => _JobFormState();
}

class _JobFormState extends State<JobForm> {
  final TextEditingController _titleCont = TextEditingController();
  final TextEditingController _descriptionCont = TextEditingController();
  final TextEditingController _vaccancyCont = TextEditingController();
  final TextEditingController _minExpCont = TextEditingController();
  final TextEditingController _maxExpCont = TextEditingController();
  final TextEditingController _minSalaryCont = TextEditingController();
  final TextEditingController _maxSalaryCont = TextEditingController();
  final TextEditingController _skillCont = TextEditingController();
  final TextEditingController _roleDescriptionCont = TextEditingController();
  final TextEditingController _questionCont = TextEditingController();
  bool addQuestion = false;
  List<String> customQuestionSLists = [];

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
  final _questionsForm = GlobalKey<FormState>();

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _fetchStates();
    setFields();
  }

  void setFields() {
    if (widget.jobData != null) {
      setState(() {
        _titleCont.text = widget.jobData!.title ?? "";

        _vaccancyCont.text = widget.jobData!.vaccancy.toString();
        _minExpCont.text = widget.jobData!.minimumExperience.toString();
        _maxExpCont.text = widget.jobData!.maximumExperience.toString();
        _minSalaryCont.text = widget.jobData!.minimumSalary.toString();
        _maxSalaryCont.text = widget.jobData!.maximumSalary.toString();

        String fullText = widget.jobData!.description ?? "";
        List<String> sections = fullText.split('Candidate\'s desired profile:');

        if (sections.length == 2) {
          // Remove the "Roles and responsibilities:" prefix and trim whitespace
          _descriptionCont.text = sections[0]
              .replaceFirst('Roles and responsibilities:', '')
              .trim();

          // Trim whitespace from the candidate profile section
          _roleDescriptionCont.text = sections[1].trim();
        } else {
          // If the text doesn't contain the expected split, set both to empty or handle as needed
          _descriptionCont.text = fullText;
          _roleDescriptionCont.text = '';
        }

        // Selected dropdowns
        _selectedIndustry = widget.jobData!.industry ?? '';
        _selectedFunctionalArea = widget.jobData!.functionalArea ?? '';
        _selectedCity = widget.jobData!.city ?? '';
        _selectedCountry = widget.jobData!.country ?? '';
        _selectedGender = widget.jobData!.gender ?? '';
        _selectedNationality = widget.jobData!.nationality ?? '';
        _selectedType = widget.jobData!.jobType ?? '';
        _selectedEducation = widget.jobData!.education ?? '';
        _selectedCurrency = widget.jobData!.currency ?? 'INR';
        if (widget.jobData!.skills != null) {
          selectedSkills = List<String>.from(widget.jobData!.skills!);
        }
        if (widget.jobData!.customQuestions != null) {
          customQuestionSLists =
              List<String>.from(widget.jobData!.customQuestions!);
        }

        if (widget.jobData!.candidateLocation != null) {
          selectedLocations =
              List<String>.from(widget.jobData!.candidateLocation!);
        }
      });
    }
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
      case 3:
        return _questionsForm.currentState?.validate() ?? false;
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

    print(validateCurrentStep());
  }

  void submitForm() async {
    if (widget.isEdit == true && widget.jobData != null) {
      final job = JobPostModel(
          id: widget.jobData!.id,
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
          requirements: "nnnnnnnnn",
          benefits: "benefits",
          customQuestions: customQuestionSLists,
          currency: _selectedCurrency,
          skills: selectedSkills);
      final result =
          await Provider.of<JobPostingProvider>(context, listen: false)
              .editJobPost(job: job);
      if (result == "success") {
        Navigator.pushReplacement(
            context, AnimatedNavigation().fadeAnimation(AllJobs()));
        CommonSnackbar.show(context, message: "Chnages saved successfully!");
        Provider.of<JobPostingProvider>(context, listen: false).fetchJobLists();
      } else {
        CommonSnackbar.show(context, message: result.toString());
      }
    } else {
      try {
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
            requirements: "nnnnnnnnn",
            benefits: "benefits",
            customQuestions: customQuestionSLists,
            currency: _selectedCurrency,
            skills: selectedLocations);
        final result =
            await Provider.of<JobPostingProvider>(context, listen: false)
                .postJob(jobData: job);
        if (result == "success") {
          Provider.of<JobPostingProvider>(context, listen: false)
              .fetchJobLists();
          Navigator.pop(context);
          CommonSnackbar.show(context, message: "Job posted successfuly!");
        } else {
          CommonSnackbar.show(context, message: result.toString());
        }
      } catch (e) {
        print(e);
      }
    }
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
      Step(
        title: const Text('Confirm'),
        content: _buildCustomQuestions(theme: theme),
        isActive: _currentStep >= 3,
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
          if (index < 3) _buildDivider(), // Don't add divider after last step
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
                        children: List.generate(4, (index) {
                          bool isActive = _currentStep >= index;
                          StepState state = _currentStep > index
                              ? StepState.complete
                              : StepState.indexed;
                          return _buildStep(
                            index,
                            [
                              'Personal',
                              'Address',
                              'Confirm',
                              'Questions'
                            ][index],
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
                                  ),
                                ),
                              if (_currentStep > 0) const SizedBox(width: 16),
                              Expanded(
                                child: ReusableButton(
                                  // isLoading: ,
                                  action: () async {
                                    print("pppppppppppppppp");
                                    handleNext(theme);
                                  },
                                  text:
                                      _currentStep < getSteps(theme).length - 1
                                          ? 'NEXT'
                                          : widget.isEdit == true
                                              ? "SAVE"
                                              : 'FINISH',
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildJobDetailsForm({required ThemeData theme}) {
    print(selectedSkills.length);
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
                labelText: "Select location",
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

  Widget _buildCustomQuestions({required ThemeData theme}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _questionsForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            children: [
              _buildHeadingWidget(
                  theme: theme,
                  heading: "Questions",
                  subHeading:
                      "Add relevant questions to assess candidates' qualifications and suitability for the role"),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customQuestionSLists.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: List.generate(customQuestionSLists.length,
                              (index) {
                            return Text(
                                "${index + 1}. ${customQuestionSLists[index]}?");
                          }),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 15,
                  ),
                  addQuestion == true
                      ? 
                          ReusableTextfield(
                            controller: _questionCont,
                            validation: (_) {
                              if (_questionCont.text.trim().isEmpty) {
                                return "This field is required";
                              }
                              return null;
                            },
                            maxLines: 3,
                            hintText: "Enter your question here...",
                            labelText: "Question",
                            float: FloatingLabelBehavior.never,
                          )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      addQuestion == true
                          ? InkWell(
                              onTap: () {
                                // if (_questionsForm.currentState!.validate()) {
                                setState(() {
                                  addQuestion = false;
                                  customQuestionSLists.add(_questionCont.text);
                                  _questionCont.clear();
                                });
                                // }
                              },
                              child: Text(
                                "Add",
                                style: theme.textTheme.bodyMedium!
                                    .copyWith(color: Colors.blue),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  addQuestion = true;
                                });
                              },
                              child: Text(
                                "+Add questions",
                                style: theme.textTheme.bodyMedium!
                                    .copyWith(color: Colors.blue),
                              ),
                            ),
                    ],
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
          if (labelText == "Select location") {
            return null;
          } else {
            if (selectedVariable == '') {
              return "This field is required";
            }
            return null;
          }
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
