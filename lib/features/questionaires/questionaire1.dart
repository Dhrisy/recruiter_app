import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/city_lists.dart';
import 'package:recruiter_app/core/utils/country_lists.dart';
import 'package:recruiter_app/core/utils/functional_area_lists.dart';
import 'package:recruiter_app/core/utils/industry_lists.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';
import 'package:recruiter_app/widgets/reusable_textfield.dart';

class Questionaire1 extends StatefulWidget {
  const Questionaire1({super.key});

  @override
  State<Questionaire1> createState() => _Questionaire1State();
}

class _Questionaire1State extends State<Questionaire1> {
  String _selectedIndustry = '';
  String _selectedFunctionalArea = '';
  String _selectedCity = '';
  String _selectedCountry = '';

  final TextEditingController _companyWesiteCont = TextEditingController();
  final TextEditingController _addressCont = TextEditingController();
  final TextEditingController _postalCodeCont = TextEditingController();

  PageController _pageController = PageController();
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      child: SafeArea(
          child: Scaffold(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  LinearProgressBar(
                    maxSteps: 9,
                    progressType: LinearProgressBar.progressTypeLinear,
                    currentStep: _currentIndex + 1,
                    progressColor: buttonColor,
                    backgroundColor: greyTextColor,
                    dotsAxis: Axis.horizontal, // OR Axis.vertical
                    dotsActiveSize: 10,
                    dotsInactiveSize: 10,
                    dotsSpacing: EdgeInsets.only(
                        right: 10), // also can use any EdgeInsets.
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    semanticsLabel: "Label",
                    semanticsValue: "Value",
                    minHeight: 10,
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  Expanded(
                      child: PageView(
                    controller: _pageController,
                    onPageChanged: (value) {
                      setState(() {
                        _currentIndex = value;
                      });
                    },
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _buildCompanyDetailWidget(theme: theme),
                      _buildLocationDetailsWidget(theme: theme)
                    ],
                  ))
                  /*             Text("Company details", style: theme.textTheme.headlineMedium),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 140.h,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60.r,
                          backgroundColor: Colors.red,
                          backgroundImage:
                              const AssetImage("assets/images/default_logo.webp"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete)
                            // Text("Edit"), const SizedBox(
                            //   width: 10,
                            // ),
                            // SvgPicture.asset("assets/svgs/edit_pen.svg")
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                
                  ReusableTextfield(
                    controller: TextEditingController(),
                    labelText: "Company website",
                    isRequired: true,
                    validation: (_) {
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ReusableTextfield(
                    controller: TextEditingController(),
                    labelText: "About your company",
                    // maxLines: 4,
                    isRequired: true,
                    validation: (_) {
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 45.h,
                    // color: Colors.green,
                    child: DropdownSearch<String>(
                      decoratorProps: DropDownDecoratorProps(
                        expands: true,
                        decoration: InputDecoration(
                          labelText: 'Industry',
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
                      items: (filter, infiniteScrollProps) => industryLists,
                      selectedItem:
                          _selectedIndustry.isEmpty ? null : _selectedIndustry,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedIndustry = newValue ?? "";
                        });
                      },
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search industry...',
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
                  ),
              
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 45.h,
                    // color: Colors.green,
                    child: DropdownSearch<String>(
                      decoratorProps: DropDownDecoratorProps(
                        expands: true,
                        decoration: InputDecoration(
                          labelText: 'Functional area',
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
                      items: (filter, infiniteScrollProps) => functionalAreaLists,
                      selectedItem: _selectedFunctionalArea.isEmpty
                          ? null
                          : _selectedFunctionalArea,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedFunctionalArea = newValue ?? "";
                        });
                      },
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search area...',
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
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ReusableTextfield(
                    controller: _addressCont,
                    isRequired: true,
                    labelText: "Address",
                    maxLines: 2,
                    validation: (_) {
                      if (_addressCont.text.trim().isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        height: 45.h,
                        // color: Colors.green,
                        child: DropdownSearch<String>(
                          decoratorProps: DropDownDecoratorProps(
                            expands: true,
                            decoration: InputDecoration(
                              labelText: 'City',
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
                          items: (filter, infiniteScrollProps) => cities,
                          selectedItem:
                              _selectedCity.isEmpty ? null : _selectedCity,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCity = newValue ?? "";
                            });
                          },
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                hintText: 'Search city...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: borderColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Container(
                        height: 45.h,
                        // color: Colors.green,
                        child: DropdownSearch<String>(
                          decoratorProps: DropDownDecoratorProps(
                            expands: true,
                            decoration: InputDecoration(
                              labelText: 'Country',
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
                          items: (filter, infiniteScrollProps) => countryLists,
                          selectedItem:
                              _selectedCountry.isEmpty ? null : _selectedCountry,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCountry = newValue ?? "";
                            });
                          },
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                hintText: 'Search country...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: borderColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
              
                  const SizedBox(
                  height: 15,
                ),
              */
                  // ReusableTextfield(controller: controller)
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildCompanyDetailWidget({required ThemeData theme}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Ok, let's set up your company account! Provide the details below",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge!
                .copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: Text("These details will be displayed to job seekers",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall!
                        .copyWith(color: greyTextColor)),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 140.h,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60.r,
                  backgroundColor: Colors.red,
                  backgroundImage:
                      const AssetImage("assets/images/default_logo.webp"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete)
                    // Text("Edit"), const SizedBox(
                    //   width: 10,
                    // ),
                    // SvgPicture.asset("assets/svgs/edit_pen.svg")
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          ReusableTextfield(
            controller: TextEditingController(),
            labelText: "Company website",
            isRequired: true,
            validation: (_) {
              return null;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          ReusableTextfield(
            controller: TextEditingController(),
            labelText: "About your company",
            // maxLines: 4,
            isRequired: true,
            validation: (_) {
              return null;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 45.h,
            // color: Colors.green,
            child: DropdownSearch<String>(
              decoratorProps: DropDownDecoratorProps(
                expands: true,
                decoration: InputDecoration(
                  labelText: 'Industry',
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
              items: (filter, infiniteScrollProps) => industryLists,
              selectedItem:
                  _selectedIndustry.isEmpty ? null : _selectedIndustry,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedIndustry = newValue ?? "";
                });
              },
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'Search industry...',
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
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 45.h,
            // color: Colors.green,
            child: DropdownSearch<String>(
              decoratorProps: DropDownDecoratorProps(
                expands: true,
                decoration: InputDecoration(
                  labelText: 'Functional area',
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
              items: (filter, infiniteScrollProps) => functionalAreaLists,
              selectedItem: _selectedFunctionalArea.isEmpty
                  ? null
                  : _selectedFunctionalArea,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFunctionalArea = newValue ?? "";
                });
              },
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'Search area...',
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
          ),
          const SizedBox(
            height: 15,
          ),
          const SizedBox(
            height: 35,
          ),
          ReusableButton(
              action: () {
                _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              text: "Next",
              textSize: 16.sp,
              textColor: Colors.white,
              height: 40.h,
              buttonColor: buttonColor)
        ],
      ),
    );
  }

  Widget _buildLocationDetailsWidget({required ThemeData theme}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.arrow_back),
              const SizedBox(width: 20,),
              Text(
                "Hi Emergio games",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge!
                    .copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
                "Provide your company location details",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge!
                    .copyWith(color: greyTextColor),
              ),
              const SizedBox(
            height: 25,
          ),
          Center(
            child: SizedBox(
              child: Column(
                children: [
                  ReusableTextfield(
                    controller: TextEditingController(),
                    labelText: "Address",
                    maxLines: 3,
                    isRequired: true,
                    validation: (_){},
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                            children: [
                              Expanded(
                                  child: Container(
                                height: 45.h,
                                // color: Colors.green,
                                child: DropdownSearch<String>(
                                  decoratorProps: DropDownDecoratorProps(
                                    expands: true,
                                    decoration: InputDecoration(
                                      labelText: 'City',
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
                                  items: (filter, infiniteScrollProps) => cities,
                                  selectedItem:
                                      _selectedCity.isEmpty ? null : _selectedCity,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedCity = newValue ?? "";
                                    });
                                  },
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        hintText: 'Search city...',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide:
                                              const BorderSide(color: borderColor),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide:
                                              const BorderSide(color: borderColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Container(
                                height: 45.h,
                                // color: Colors.green,
                                child: DropdownSearch<String>(
                                  decoratorProps: DropDownDecoratorProps(
                                    expands: true,
                                    decoration: InputDecoration(
                                      labelText: 'Country',
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
                                  items: (filter, infiniteScrollProps) => countryLists,
                                  selectedItem:
                                      _selectedCountry.isEmpty ? null : _selectedCountry,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedCountry = newValue ?? "";
                                    });
                                  },
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        hintText: 'Search country...',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide:
                                              const BorderSide(color: borderColor),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide:
                                              const BorderSide(color: borderColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                            ],
                          ),
                  
                          const SizedBox(
                    height: 15,
                  ),
                  ReusableTextfield(controller: TextEditingController(),
                  labelText: "Postal code",),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
              
          InkWell(
              onTap: () {
                _pageController.previousPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              child: Text("qqqqqqqqqqqqqqqqq"))
        ],
      ),
    );
  }
}
