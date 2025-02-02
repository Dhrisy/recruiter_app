import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/city_lists.dart';
import 'package:recruiter_app/core/utils/country_lists.dart';
import 'package:recruiter_app/core/utils/functional_area_lists.dart';
import 'package:recruiter_app/core/utils/industry_lists.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/account/account_data.dart';
import 'package:recruiter_app/features/account/account_provider.dart';
import 'package:recruiter_app/features/navbar/view/animated_navbar.dart';
import 'package:recruiter_app/features/questionaires/bloc/questionaire_bloc.dart';
import 'package:recruiter_app/features/questionaires/bloc/questionaire_event.dart';
import 'package:recruiter_app/features/questionaires/bloc/questionaire_state.dart';
import 'package:recruiter_app/features/questionaires/data/questionaire_repository.dart';
import 'package:recruiter_app/features/questionaires/model/questionaire_model.dart';
import 'package:recruiter_app/features/questionaires/view/successfully_registered_screen.dart';
import 'package:recruiter_app/services/account/account_service.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';
import 'package:recruiter_app/widgets/reusable_textfield.dart';
import 'package:path/path.dart' as path;

class Questionaire1 extends StatefulWidget {
  final bool? isFromHome;
  final bool? isEdit;
  final AccountData? accountData;
  final int? index;
  const Questionaire1(
      {super.key, this.isFromHome, this.isEdit, this.accountData, this.index});

  @override
  State<Questionaire1> createState() => _Questionaire1State();
}

class _Questionaire1State extends State<Questionaire1> {
  String _selectedIndustry = '';
  String _selectedFunctionalArea = '';
  String _selectedCity = '';
  String _selectedCountry = '';
  bool industryError = false;
  bool areaError = false;
  bool cityError = false;
  bool countryError = false;

  final TextEditingController _companyWesiteCont = TextEditingController();
  final TextEditingController _companyNameCont = TextEditingController();
  final TextEditingController _aboutCont = TextEditingController();
  final TextEditingController _addressCont = TextEditingController();
  final TextEditingController _postalCodeCont = TextEditingController();
  final TextEditingController _personNameCont = TextEditingController();
  final TextEditingController _mobileNumberCont = TextEditingController();
  final TextEditingController _landlineNumberCont = TextEditingController();
  final TextEditingController _designationCont = TextEditingController();

  PageController _pageController = PageController();
  int _currentIndex = 1;

  final _comapnyFormKey = GlobalKey<FormState>();
  final _locationFormKey = GlobalKey<FormState>();
  final _contactFormKey = GlobalKey<FormState>();
  File? _selectedImage;

  // Pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      print("No image selected.");
    }
  }

  // Navigate to a specific index
  void _navigateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300), // Adjust duration as needed
      curve: Curves.easeInOut, // Smooth animation
    );
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToPage(widget.index ?? 0);

      if (widget.accountData != null) {
        _designationCont.text = widget.accountData!.designation.toString();
        _landlineNumberCont.text =
            widget.accountData!.contactLandNumber.toString();
        _mobileNumberCont.text =
            widget.accountData!.contactMobileNumber.toString();
        _personNameCont.text = widget.accountData!.name.toString();
        _postalCodeCont.text = widget.accountData!.postalCode.toString();
        _addressCont.text = widget.accountData!.address != null
            ? widget.accountData!.address!.map((item) => item).join(", ")
            : "N/A";

        _aboutCont.text = widget.accountData!.about.toString();
        _companyWesiteCont.text = widget.accountData!.website.toString();
        _companyNameCont.text = widget.accountData!.name.toString();

        _selectedCountry = widget.accountData!.country.toString();
        _selectedCity = widget.accountData!.city.toString();
        _selectedFunctionalArea = widget.accountData!.functionalArea.toString();
        _selectedIndustry = widget.accountData!.industry.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(),
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
                    maxSteps: 3,
                    progressType: LinearProgressBar.progressTypeLinear,
                    currentStep: _currentIndex + 1,
                    progressColor: buttonColor,
                    backgroundColor: borderColor,
                    valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                    semanticsLabel: "Label",
                    semanticsValue: "Value",
                    minHeight: 11,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                      child: BlocConsumer<QuestionaireBloc, QuestionaireState>(
                          listener: (context, state) {
                    if (state is QuestionaireFailure) {
                      return CommonSnackbar.show(context, message: state.error);
                    }

                    if (state is QuestionaireSuccess) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          AnimatedNavigation()
                              .scaleAnimation(SuccessfullyRegisteredScreen()),
                          (Route<dynamic> route) => false);
                    }
                  }, builder: (context, state) {
                    return PageView(
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
                        _buildLocationDetailsWidget(theme: theme),
                        _buildContactDetails(theme: theme),
                        // _buildSuccessfullWidget(theme: theme)
                      ],
                    );
                  }))
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
      child: Form(
        key: _comapnyFormKey,
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
                  InkWell(
                    onTap: () {
                      _pickImage(ImageSource.camera);
                    },
                    child: CircleAvatar(
                      radius: 60.r,
                      backgroundColor: Colors.transparent,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : const AssetImage("assets/images/default_logo.webp"),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                          child: Icon(Icons.delete))
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
            widget.isEdit == true
                ? ReusableTextfield(
                    controller: _companyNameCont,
                    hintText: "Company name",
                    labelText: "Compnay name",
                    validation: (_) {
                      if (_companyNameCont.text.trim().isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  )
                : const SizedBox.shrink(),
            const SizedBox(
              height: 15,
            ),
            ReusableTextfield(
              controller: _companyWesiteCont,
              labelText: "Company website",
              validation: (_) {
                // final websiteRegex =
                //     "^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/[\w\-._~:\/?#[\]@!&'()*+,;=]*)?";

                final websiteRegex =
                    r"^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/[\w\-._~:\/?#[\]@!&\'()*+,;=]*)?";

                final RegExp regex = RegExp(websiteRegex);
                if (_companyWesiteCont.text.trim().isEmpty) {
                  return "This field is required";
                } else if (!regex.hasMatch(_companyWesiteCont.text)) {
                  return "Enter valid url";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            ReusableTextfield(
              controller: _aboutCont,
              labelText: "About your company",
              maxLines: 4,
              validation: (_) {
                if (_aboutCont.text.trim().isEmpty) {
                  return "This field id required";
                } else if (_aboutCont.text.length < 50) {
                  return "This field contain minimum 50 characters";
                }
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
            industryError
                ? Row(
                    children: [
                      Text(
                        "This field is required",
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: Colors.red.shade900),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 45.h,
              // color: Colors.green,
              child: DropdownSearch<String>(
                validator: (_) {
                  if (_selectedIndustry == '') {
                    return "This field is required";
                  }
                  return null;
                },
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
            areaError
                ? Row(
                    children: [
                      Text(
                        "This field is required",
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: Colors.red.shade900),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(
              height: 35,
            ),
            ReusableButton(
              action: () {
                if (_comapnyFormKey.currentState!.validate()) {
                  if (_selectedIndustry == '') {
                    setState(() {
                      industryError = true;
                    });
                  } else if (_selectedFunctionalArea == '') {
                    setState(() {
                      areaError = true;
                      industryError = false;
                    });
                  } else {
                    setState(() {
                      industryError = false;
                      areaError = false;
                    });
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  }
                }

                FocusScope.of(context).unfocus();
              },
              text: "Next",
              textSize: 16.sp,
              textColor: Colors.white,
              height: 40.h,
            ),
            const SizedBox(
              height: 35,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationDetailsWidget({required ThemeData theme}) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _locationFormKey,
            child: Column(
              children: [
                Text(
                  "Hi Emergio games",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge!
                      .copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Provide your company location details",
                  textAlign: TextAlign.center,
                  style:
                      theme.textTheme.bodyLarge!.copyWith(color: greyTextColor),
                ),
                const SizedBox(
                  height: 25,
                ),
                Center(
                  child: SizedBox(
                    child: Column(
                      children: [
                        ReusableTextfield(
                          controller: _addressCont,
                          labelText: "Address",
                          maxLines: 3,
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
                                      borderSide:
                                          const BorderSide(color: borderColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: borderColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: borderColor),
                                    ),
                                  ),
                                ),
                                items: (filter, infiniteScrollProps) => cities,
                                selectedItem: _selectedCity.isEmpty
                                    ? null
                                    : _selectedCity,
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
                                        borderSide: const BorderSide(
                                            color: borderColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: borderColor),
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
                                      borderSide:
                                          const BorderSide(color: borderColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: borderColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: borderColor),
                                    ),
                                  ),
                                ),
                                items: (filter, infiniteScrollProps) =>
                                    countryLists,
                                selectedItem: _selectedCountry.isEmpty
                                    ? null
                                    : _selectedCountry,
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
                                        borderSide: const BorderSide(
                                            color: borderColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: borderColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ))
                          ],
                        ),
                        cityError == true || countryError == true
                            ? Row(
                                children: [
                                  Text(
                                    "City and country is required",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: Colors.red.shade900),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(
                          height: 15,
                        ),
                        ReusableTextfield(
                          controller: _postalCodeCont,
                          labelText: "Postal code",
                          keyBoardType: TextInputType.number,
                          validation: (_) {
                            if (_postalCodeCont.text.trim().isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                ReusableButton(
                  action: () {
                    if (_locationFormKey.currentState!.validate()) {
                      if (_selectedCity == '') {
                        setState(() {
                          cityError = true;
                        });
                      } else if (_selectedCountry == '') {
                        setState(() {
                          countryError = true;
                        });
                      } else {
                        setState(() {
                          cityError = false;
                          countryError = false;
                        });
                        _pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                        FocusScope.of(context).unfocus();
                      }
                    }
                  },
                  textSize: 18.sp,
                  height: 40.h,
                  text: "Next",
                  textColor: Colors.white,
                )
              ],
            ),
          ),
        ),
        _buildArrowWidget()
      ],
    );
  }

  Widget _buildContactDetails({required ThemeData theme}) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _contactFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Contact information",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge!.copyWith(
                          fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Provide your contact details",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge!
                          .copyWith(color: greyTextColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                ReusableTextfield(
                  controller: _personNameCont,
                  labelText: "Contact person name",
                  validation: (_) {
                    if (_personNameCont.text.trim().isEmpty) {
                      return "This field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                ReusableTextfield(
                  controller: _mobileNumberCont,
                  labelText: "Mobile number",
                  validation: (_) {
                    if (_mobileNumberCont.text.trim().isEmpty) {
                      return "This field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                ReusableTextfield(
                  controller: _landlineNumberCont,
                  labelText: "Landline number",
                  isRequired: false,
                ),
                const SizedBox(
                  height: 15,
                ),
                ReusableTextfield(
                  controller: _designationCont,
                  labelText: "Designation",
                  validation: (_) {
                    if (_designationCont.text.trim().isEmpty) {
                      return "This field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 55,
                ),
                BlocConsumer<QuestionaireBloc, QuestionaireState>(
                    listener: (context, state) {
                  if (widget.isFromHome == true) {
                    if (state is QuestionaireSuccess) {
                      Navigator.pop(context);
                      CommonSnackbar.show(context,
                          message: "Job posted successfully");
                    }
                    if (state is QuestionaireFailure) {
                      CommonSnackbar.show(context,
                          message: "Failed to post job");
                    }
                  }
                }, builder: (context, state) {
                  return Consumer<AccountProvider>(
                      builder: (context, provider, child) {
                    return ReusableButton(
                      isLoading: provider.isLoading,
                      action: () async {
                        if (widget.isEdit == true &&
                            widget.accountData != null) {
                          print(_selectedImage != null
                              ? _selectedImage!.path.toString()
                              : "kkkkk");
                          String fullPath =
                              _selectedImage !=null ? _selectedImage!.path.toString() : "";
                          String fileName = path.basename(fullPath);

                         

                          final account = AccountData(
                              logo: fileName,
                              id: widget.accountData!.id,
                              contactLandNumber: _landlineNumberCont.text,
                              about: _aboutCont.text,
                              address: [_addressCont.text],
                              city: _selectedCity,
                              contactMobileNumber: _mobileNumberCont.text,
                              contactName: _personNameCont.text,
                              country: _selectedCountry,
                              designation: _designationCont.text,
                              functionalArea: _selectedFunctionalArea,
                              industry: _selectedIndustry,
                              name: "Emergio games",
                              website: _companyWesiteCont.text,
                              postalCode: _postalCodeCont.text);

                          final result = await Provider.of<AccountProvider>(
                                  context,
                                  listen: false)
                              .editCompanyDetails(account: account);

                          if (result == "success") {
                            Navigator.pushAndRemoveUntil(
                                context,
                                AnimatedNavigation()
                                    .fadeAnimation(CustomBottomNavBar(
                                  index: 3,
                                )),
                                (Route<dynamic> route) => false);

                            Provider.of<AccountProvider>(context, listen: false)
                                .fetchAccountData();
                            CommonSnackbar.show(context,
                                message: "Chnage saved successfully");
                          } else {
                            CommonSnackbar.show(context,
                                message: result.toString());
                          }
                        } else {
                          if (_contactFormKey.currentState!.validate()) {
                            context.read<QuestionaireBloc>().add(
                                QuestionaireSubmitEvent(
                                    aboutCompany: _aboutCont.text,
                                    address: _addressCont.text,
                                    city: _selectedCity,
                                    contactPersonName: _personNameCont.text,
                                    country: _selectedCountry,
                                    designation: _designationCont.text,
                                    functionalArea: _selectedFunctionalArea,
                                    industry: _selectedIndustry,
                                    mobilePhn: _mobileNumberCont.text,
                                    postalCode: _postalCodeCont.text,
                                    website: _companyWesiteCont.text));
                          }
                          Navigator.pushAndRemoveUntil(
                              context,
                              AnimatedNavigation().scaleAnimation(
                                  SuccessfullyRegisteredScreen()),
                              (Route<dynamic> route) => false);
                        }
                      },
                      textSize: 18.sp,
                      height: 40.h,
                      text: widget.isEdit == true ? "Save changes" : "Save",
                      textColor: Colors.white,
                    );
                  });
                })
              ],
            ),
          ),
        ),
        _buildArrowWidget()
      ],
    );
  }

  Widget _buildArrowWidget() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: buttonColor, width: 1.w),
              borderRadius: BorderRadius.circular(50.r)),
          onPressed: () {
            _pageController.previousPage(
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          },
          child: Icon(
            Icons.keyboard_arrow_up_outlined,
            size: 30.sp,
          ),
        ),
      ),
    );
  }

  Future<void> _submitQuestionaire({
    required QuestionaireModel questionaire,
  }) async {
    try {
      final result = await QuestionaireRepository()
          .questionaireSubmission(questionaire: questionaire);
      print(result);
    } catch (e) {
      print(e);
    }
  }
}
