import 'package:animations/animations.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/country_lists.dart';
import 'package:recruiter_app/core/utils/nationalities.dart';
import 'package:recruiter_app/features/resdex/email_template_form.dart';
import 'package:recruiter_app/features/resdex/provider/search_seeker_provider.dart';
import 'package:recruiter_app/features/resdex/widgets/candidate_invited.dart';
import 'package:recruiter_app/features/resdex/widgets/email_template_widget.dart';
import 'package:recruiter_app/features/resdex/widgets/interview_scheduled_widget.dart';
import 'package:recruiter_app/features/resdex/widgets/saved_cv_widget.dart';
import 'package:recruiter_app/features/resdex/widgets/saved_searches.dart';
import 'package:recruiter_app/features/resdex/widgets/search_cv_form_widget.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';
import 'package:recruiter_app/widgets/custom_fab_btn_widget.dart';
import 'package:recruiter_app/widgets/reusable_textfield.dart';

class Resedex extends StatefulWidget {
  final int? index;
  const Resedex({Key? key, this.index}) : super(key: key);

  @override
  State<Resedex> createState() => _ResedexState();
}

class _ResedexState extends State<Resedex> with SingleTickerProviderStateMixin {
  int currentScreenIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.index != null) {
        setState(() {
          currentScreenIndex = widget.index!;
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height.h;
    final theme = Theme.of(context);
    return Material(
      child: Scaffold(
        floatingActionButton: currentScreenIndex == 0
            ? CustomFabBtnWidget(
                heroTag: "filter_fab",
                icon: Icons.filter_alt,
                onPressed: () {
                  _showAnimatedBottomSheet(theme: theme);
                  // Provider.of<SearchSeekerProvider>(context, listen: false).searchSeeker(keyWords:[ "flutter"]);
                },
              )
            : currentScreenIndex == 5
                ? OpenContainer(
                    transitionType: ContainerTransitionType.fade,
                    transitionDuration: const Duration(milliseconds: 500),
                    closedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    closedBuilder:
                        (BuildContext context, VoidCallback openContainer) {
                      return CustomFabBtnWidget(
                          heroTag: "template_tab",
                          onPressed: () {
                            openContainer();
                          });
                    },
                    openBuilder:
                        (BuildContext context, VoidCallback closeContainer) {
                      return const EmailTemplateForm(
                        isEdit: false,
                      );
                    },
                  )
                : const SizedBox.shrink(),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    CommonAppbarWidget(title: "Resdex"),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                      // spacing: 15,
                      children: [
                        Row(
                          // spacing: 10.w,
                          children: [
                            Expanded(
                                child: _buildOptionContainer(
                                    title: "Search CV's", index: 0)),
                            Expanded(
                                child: _buildOptionContainer(
                                    title: "Invited Candidate", index: 1)),
                            Expanded(
                                child: _buildOptionContainer(
                                    title: "Interview Scheduled ", index: 2))
                          ],
                        ),
                        Row(
                          // spacing: 10.w,
                          children: [
                            Expanded(
                                child: _buildOptionContainer(
                                    title: "Saved CV's", index: 3)),
                            Expanded(
                                child: _buildOptionContainer(
                                    title: "Saved searches", index: 4)),
                            Expanded(
                                child: _buildOptionContainer(
                                    title: "Email templates", index: 5))
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Divider(
                      height: 1,
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    //  serach cv form
                    currentScreenIndex == 0
                        ? SearchCvFormWidget()
                        : SizedBox.shrink(),
                    currentScreenIndex == 1
                        ? CandidateInvited()
                        : SizedBox.shrink(),

                        currentScreenIndex == 2
                        ? InterviewScheduledWidget()
                        : SizedBox.shrink(),
 currentScreenIndex == 3
                        ? SavedCvWidget()
                        : SizedBox.shrink(),


                    currentScreenIndex == 4
                        ? SavedSearches()
                        : const SizedBox.shrink(),

                    currentScreenIndex == 5
                        ? EmailTemplateWidget()
                        : const SizedBox.shrink()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAnimatedBottomSheet({required ThemeData theme}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: _controller,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
        return SlideTransition(
          transformHitTests: true,
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(_animation),
          child: Container(
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
                          // spacing: 15,
                          children: [
                            _buildBottomsheetItem(
                                theme: theme,
                                text: "Search with keywords",
                                validation: (_) {},
                                controller: TextEditingController(),
                                onSubmit: (value) {
                                  if (value != "") {
                                    setState(() {
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
                                      // spacing: 8.w,
                                      // runSpacing: 8.h,
                                      children:
                                          selectedKeywords.map((location) {
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
                              // spacing: 15,
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
                            _buildBottomsheetTitle(
                                theme: theme, text: "Salary"),
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
                                    // spacing: 5,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    // spacing: 5,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // _buildBottomsheetTitle(
                                      //     theme: theme, text: "Nationality"),
                                      _buildDropdownWidget(
                                          theme: theme,
                                          selectedVariable:
                                              _selectedNationality,
                                          list: nationalities,
                                          hintText: "Select nationality",
                                          labelText: "Nationality",
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
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
                              // spacing: 5,
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
                                        setState(() {
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
                              // spacing: 10,
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
                              color: buttonColor,
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
                        // spacing: 15,
                        children: [
                          Expanded(
                            child: _buildBottomsheetBtn(
                              text: "Apply filter",
                              theme: theme,
                              color: buttonColor,
                              action: () {
                                Provider.of<SearchSeekerProvider>(context,
                                        listen: false)
                                    .changeSearchResult(true);
                                if (selectedKeywords.isEmpty &&
                                    _selectedCountry == "" &&
                                    _selectedEducation == "" &&
                                    maxSalary == "" &&
                                    minSalary == "" &&
                                    _expYear.text == "" &&
                                    _expMonth.text == "" &&
                                    _selectedGender == "" &&
                                    _selectedNationality == "") {
                                  Navigator.pop(context);
                                  CommonSnackbar.show(context,
                                      message: "Select any filter");
                                } else {
                                  Provider.of<SearchSeekerProvider>(context,
                                          listen: false)
                                      .searchSeeker(
                                          keyWords: selectedKeywords,
                                          education: _selectedEducation,
                                          experienceMonth: _expMonth.text,
                                          experienceYear: _expYear.text,
                                          gender: _selectedGender,
                                          location: _selectedCountry,
                                          maxiSalary: maxSalary,
                                          miniSalary: minSalary,
                                          nationality: _selectedNationality);
                                  setModalState(() {
                                    isApplyFilter = true;
                                  });
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: _buildBottomsheetBtn(
                              text: "Remove filter",
                              theme: theme,
                              action: () {
                                Provider.of<SearchSeekerProvider>(context,
                                        listen: false)
                                    .changeSearchResult(false);
                                setModalState(() {
                                  selectedKeywords = [];
                                  _selectedCountry == "";
                                  _selectedEducation == "";
                                  maxSalary == "";
                                  minSalary == "";
                                  _expYear.text == "";
                                  _expMonth.text == "";
                                  _selectedGender == "";
                                  _selectedNationality == "";
                                });
                                setState(() {
                                  selectedKeywords = [];
                                  _selectedCountry == "";
                                  _selectedEducation == "";
                                  maxSalary == "";
                                  minSalary == "";
                                  _expYear.clear();
                                  _expMonth.clear();
                                  _selectedGender == "";
                                  _selectedNationality == "";
                                });

                                Provider.of<SearchSeekerProvider>(context,
                                        listen: false)
                                    .fetchAllSeekersLists();
                                Navigator.pop(context);
                                setModalState(() {
                                  isApplyFilter = false;
                                });
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
          ),
        );
      }),
    ).then((_) {
      _controller.reset();
    });
    _controller.forward();
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
      // spacing: 4,
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

  Widget _buildOptionContainer({required String title, required int index}) {
    return InkWell(
      onTap: () {
        setState(() {
          currentScreenIndex = index;
        });
      },
      child: Container(
        height: 42.h,
        decoration: BoxDecoration(
            color: currentScreenIndex == index ? buttonColor : Colors.white,
            border: Border.all(
              color: currentScreenIndex == index
                  ? Colors.transparent
                  : secondaryColor,
            ),
            borderRadius: BorderRadius.circular(10.r)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: currentScreenIndex == index
                        ? Colors.white
                        : lightTextColor,
                    fontWeight: currentScreenIndex == index
                        ? FontWeight.bold
                        : FontWeight.normal),
              ))
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms).scale(duration: 600.ms),
    );
  }



}
