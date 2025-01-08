import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/country_lists.dart';
import 'package:recruiter_app/core/utils/nationalities.dart';
import 'package:recruiter_app/features/resdex/widgets/search_cv_form_widget.dart';
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

  final TextEditingController _keywordCont = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width.w;
    final screenHeight = MediaQuery.of(context).size.height.h;
    final theme = Theme.of(context);
    return Material(
      child: Scaffold(
        floatingActionButton: currentScreenIndex == 0
            ? FloatingActionButton(
                onPressed: () {
                  _showAnimatedBottomSheet(theme: theme);
                },
                child: Icon(Icons.filter),
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
                        : SizedBox.shrink()
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
      builder: (context) => SlideTransition(
        transformHitTests: true,
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(_animation),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
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
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Filter candidates',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                        Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: _buildBottomsheetItem(
                                  theme: theme,
                                  text: "Minimum Experience",
                                  validation: (_) {},
                                  controller: TextEditingController()),
                            ),
                            Expanded(
                              child: _buildBottomsheetItem(
                                  theme: theme,
                                  text: "Maximum Experience",
                                  validation: (_) {},
                                  controller: TextEditingController()),
                            )
                          ],
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: _buildBottomsheetItem(
                                  theme: theme,
                                  text: "Minimum Salary",
                                  validation: (_) {},
                                  controller: TextEditingController()),
                            ),
                            Expanded(
                              child: _buildBottomsheetItem(
                                  theme: theme,
                                  text: "Maximum Salary",
                                  validation: (_) {},
                                  controller: TextEditingController()),
                            )
                          ],
                        ),
                        Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Country",
                            ),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Country",
                            ),
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
                      ],
                    ),
                  ),
                )

                // Content
                // Expanded(
                //   child: ListView.builder(
                //     padding: const EdgeInsets.all(16),
                //     itemCount: 15,
                //     itemBuilder: (context, index) {
                //       return Card(
                //         elevation: 2,
                //         margin: const EdgeInsets.only(bottom: 12),
                //         child: ListTile(
                //           leading: CircleAvatar(
                //             backgroundColor: Colors.blue.shade100,
                //             child: Text('${index + 1}'),
                //           ),
                //           title: Text('Item ${index + 1}'),
                //           subtitle: const Text('Tap for action'),
                //           trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                //           onTap: () {
                //             // Add your action here
                //           },
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    ).then((_) {
      // Reset the animation controller when bottom sheet is closed
      _controller.reset();
    });

    // Start the animation
    _controller.forward();
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
        height: 40.h,
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
              ))
            ],
          ),
        ),
      ),
    );
  }
}
