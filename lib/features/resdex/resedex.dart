import 'package:animations/animations.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/country_lists.dart';
import 'package:recruiter_app/core/utils/nationalities.dart';
import 'package:recruiter_app/features/resdex/email_template_widget.dart';
import 'package:recruiter_app/features/resdex/saved_searches.dart';
import 'package:recruiter_app/features/resdex/widgets/search_cv_form_widget.dart';
import 'package:recruiter_app/widgets/custom_fab_btn_widget.dart';
import 'package:recruiter_app/widgets/reusable_textfield.dart';

class Resedex extends StatefulWidget {
  const Resedex({Key? key}) : super(key: key);

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
  final String minExp = '';
  final String maxExp = '';
  final String minSalary = '';
  final String maxSalary = '';
  bool addMoreFilter = false;
  bool isApplyFilter = false;

  final TextEditingController _keywordCont = TextEditingController();
  final TextEditingController _noticePeriodCont = TextEditingController();

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

  void _addRows() {
    setState(() {
      experienceOptions.addAll([
        {'label': '12 - 15 Years', 'count': 500000, 'isChecked': false},
        {'label': '15 - 20 Years', 'count': 350000, 'isChecked': false},
        {'label': '20 - 25 Years', 'count': 350000, 'isChecked': false},
        {'label': '25 - 30 Years', 'count': 350000, 'isChecked': false},
        {'label': '30+ Years', 'count': 350000, 'isChecked': false},
      ]);
    });
  }

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
  void _updateExperienceRange(
      {required String minCont,
      required String maxiCont,
      required List<Map<String, dynamic>> lists}) {
    List<Map<String, dynamic>> selectedOptions =
        lists.where((option) => option['isChecked'] == true).toList();

    if (selectedOptions.isEmpty) {
      minCont = '';
      maxiCont = '';
      return;
    }

    int minYears = selectedOptions.map((option) {
      final (min, _) = _extractYearRange(option['label']);
      return min;
    }).reduce((min, current) => min < current ? min : current);

    int maxYears = selectedOptions.map((option) {
      final (_, max) = _extractYearRange(option['label']);
      return max;
    }).reduce((max, current) => max > current ? max : current);

    setState(() {
      minCont = minYears.toString();
      maxiCont = maxYears.toString();
    });
  }

  // Method to handle checkbox state changes
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
              icon: Icons.filter_alt,
               onPressed: () {
                  _showAnimatedBottomSheet(theme: theme);
                },
            )
            : currentScreenIndex == 5
                ? OpenContainer(

                    transitionType: ContainerTransitionType.fade,
                    transitionDuration: const Duration(milliseconds: 500),
                    closedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                    ),
                    closedBuilder:
                        (BuildContext context, VoidCallback openContainer) {
                      return CustomFabBtnWidget(onPressed: () {
                        openContainer();
                      });
                    },
                    openBuilder:
                        (BuildContext context, VoidCallback closeContainer) {
                      return EmailTemplateForm();
                    },
                  )

                // FloatingActionButton(
                //   backgroundColor: secondaryColor,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(50)
                //   ),
                //   elevation: 0,
                //     heroTag: "template_fab",
                //     onPressed: () {
                //       _showTemplateBottomsheet();
                //     },
                //     child: const Icon(Icons.add, color: Colors.white,),
                //   )
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
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Icon(Icons.arrow_back_ios),
                        const SizedBox(
                          width: 40,
                        ),
                        Text(
                          "Resdex",
                          style: theme.textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 20.sp),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                      spacing: 15,
                      children: [
                        Row(
                          spacing: 10.w,
                          children: [
                            Expanded(
                                child: _buildOptionContainer(
                                    title: "Search CV's", index: 0)),
                            Expanded(
                                child: _buildOptionContainer(
                                    title: "Application Response", index: 1)),
                            Expanded(
                                child: _buildOptionContainer(
                                    title: "Schedule Interview ", index: 2))
                          ],
                        ),
                        Row(
                          spacing: 10.w,
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
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    //  serach cv form
                    currentScreenIndex == 0
                        ? SearchCvFormWidget()
                        : SizedBox.shrink(),

                    currentScreenIndex == 4
                    ? SavedSearches(): const SizedBox.shrink()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTemplateBottomsheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        transitionAnimationController: _controller,
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return EmailTemplateForm();
            }));
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
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
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
                                setState(() {
                                  selectedKeywords.add(value);
                                  _keywordCont.clear();
                                });
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
                                                setState(() {
                                                  selectedKeywords
                                                      .remove(location);
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
                          _buildBottomsheetTitle(
                              theme: theme, text: "Experience"),
                          Column(
                            children: List.generate(experienceOptions.length,
                                (index) {
                              final option = experienceOptions[index];
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
                                            updateCheckboxState(index, value,
                                                experienceOptions);
                                          });

                                          _updateExperienceRange(
                                              maxiCont: minExp,
                                              minCont: maxExp,
                                              lists: experienceOptions);
                                        },
                                      ),
                                      Text(option['label']),
                                    ],
                                  ),
                                ],
                              );
                            }),
                          ),
                          InkWell(
                              onTap: () {
                                if (viewMore) {
                                  setModalState(() {
                                    experienceOptions.addAll([
                                      {
                                        'label': '12 - 15 Years',
                                        'count': 500000,
                                        'isChecked': false
                                      },
                                      {
                                        'label': '15 - 20 Years',
                                        'count': 350000,
                                        'isChecked': false
                                      },
                                      {
                                        'label': '20 - 25 Years',
                                        'count': 350000,
                                        'isChecked': false
                                      },
                                      {
                                        'label': '25 - 30 Years',
                                        'count': 350000,
                                        'isChecked': false
                                      },
                                      {
                                        'label': '30+ Years',
                                        'count': 350000,
                                        'isChecked': false
                                      },
                                    ]);

                                    viewMore = !viewMore;
                                  });
                                } else {
                                  setModalState(() {
                                    // Remove the last 5 items from the list
                                    experienceOptions.removeRange(
                                        experienceOptions.length - 5,
                                        experienceOptions.length);
                                    viewMore = !viewMore;
                                  });
                                }
                              },
                              child: Text(
                                viewMore ? "View more" : "View less",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                    color: buttonColor,
                                    fontWeight: FontWeight.bold),
                              )),

                          Divider(),

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

                                          _updateExperienceRange(
                                              maxiCont: maxSalary,
                                              minCont: minSalary,
                                              lists: salaryOptions);
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
                      children: [
                        isApplyFilter == false
                            ? Expanded(
                                child: _buildBottomsheetBtn(
                                  text: "Apply filter",
                                  theme: theme,
                                  color: buttonColor.withValues(alpha: 0.3),
                                  action: () {
                                    setModalState(() {
                                      isApplyFilter = true;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              )
                            : Expanded(
                                child: _buildBottomsheetBtn(
                                  text: "Remove filter",
                                  theme: theme,
                                  action: () {
                                    setModalState(() {
                                      isApplyFilter = false;
                                    });
                                  },
                                  color: buttonColor,
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
    ).then((_) {
      // Reset the animation controller when bottom sheet is closed
      _controller.reset();
    });

    // Start the animation
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
              color: buttonColor,
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

  Widget _buildCheckboxListWidget({
    required ThemeData theme,
    required List<Map<String, dynamic>> list,
    required void Function(bool?)? onChnaged,
  }) {
    return Column(
      children: List.generate(list.length, (index) {
        final option = list[index];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  activeColor: secondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.r)),
                  value: option['isChecked'],
                  onChanged: onChnaged,
                ),
                Text(option['label']),
              ],
            ),
          ],
        );
      }),
    );
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
                  color: currentScreenIndex == index ? Colors.white : lightTextColor,
                  fontWeight: currentScreenIndex == index ? FontWeight.bold : FontWeight.normal
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
