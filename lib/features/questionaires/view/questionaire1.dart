import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/city_lists.dart';
import 'package:recruiter_app/core/utils/country_lists.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
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
import 'package:recruiter_app/services/api_lists.dart';
import 'package:recruiter_app/services/refresh_token_service.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';
import 'package:recruiter_app/widgets/reusable_textfield.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

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
  // File? _selectedImage;

  File? _image;
  final ImagePicker _picker = ImagePicker();
  final Dio _dio = Dio();

  // Pick image from gallery or camera
  // Future<void> _pickImage(ImageSource source) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: source);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _selectedImage = File(pickedFile.path);
  //     });
  //   } else {
  //     print("No image selected.");
  //   }
  // }

  // Function to pick image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to upload the image
  Future<bool?> _uploadImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an image")),
      );
      return null;
    }

    // final result = await QuestionaireRepository().logoPosting(image: _image);
    // if (result == "success") {
    //   return true;
    // } else {
    //   return false;
    // }

    String url =
        "${ApiLists.baseUrl}/company/company/logo"; // Replace with actual API URL
    var request = http.MultipartRequest("POST", Uri.parse(url));
    final token = await CustomFunctions().retrieveCredentials("access_token");
    request.headers.addAll({
      'Authorization': 'Bearer ${token.toString()}',
      "Content-Type": "multipart/form-data",
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        'logo',
        _image!.path,
        filename: path.basename(_image!.path),
      ),
    );

    try {
      var response = await request.send();
      print(response.statusCode);
      var responseBody =
          await response.stream.bytesToString(); // Convert stream to string

      print("Status Code: ${response.statusCode}");
      print("Response Body: $responseBody");
      if (response.statusCode == 200) {
       return true;
      } else if(response.statusCode
       == 401){
        await RefreshTokenService.refreshToken();

      return _uploadImage();
      }
    } catch (e) {
     return false;
    }
  }

  // Function to upload image
//   Future<void> _uploadImage() async {
//     if (_image == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please select an image")),
//       );
//       return;
//     }

//     String url = "${ApiLists.baseUrl}/company/company/logo"; // Replace with actual API

//     FormData formData = FormData.fromMap({
//       "logo": await MultipartFile.fromFile(_image!.path, filename: "company_logo.jpg"),
//     });

// final token = await CustomFunctions().retrieveCredentials("access_token");
//     try {
//       final response = await http.post(
//         url,
//         data: formData,
//         options: Options(
//           headers: {
//             "Authorization": token.toString(), // Replace with actual token if required
//             "Content-Type": "multipart/form-data",
//           },
//         ),
//       );

//       print(response.statusCode);
//       // print()

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Logo uploaded successfully!")),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Failed to upload logo")),
//         );
//       }
//     } catch (e) {
//       print("Upload Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error uploading logo")),
//       );
//     }
//   }

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
    // final theme = Theme.of(context);
    return PopScope(
      canPop: false, // Prevents accidental exits
      onPopInvoked: (didPop) async {
        if (didPop) return;
        Navigator.of(context).pop();
      },
      child: Material(
        child: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: widget.isEdit == true ? true : false,
          ),
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
                        child:
                            BlocConsumer<QuestionaireBloc, QuestionaireState>(
                                listener: (context, state) {
                      if (state is QuestionaireFailure) {
                        return CommonSnackbar.show(context,
                            message: state.error);
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
                          _buildCompanyDetailWidget(),
                          _buildLocationDetailsWidget(),
                          _buildContactDetails(),
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
      ),
    );
  }

  Widget _buildCompanyDetailWidget() {
    return SingleChildScrollView(
      child: Form(
        key: _comapnyFormKey,
        child: Column(
          children: [
            Text(
                "Ok, let's set up your company account! Provide the details below",
                textAlign: TextAlign.center,
                style: AppTheme.headingText(lightTextColor)
                    .copyWith(fontSize: 20.sp, fontWeight: FontWeight.w100)),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: Text("These details will be displayed to job seekers",
                      textAlign: TextAlign.center,
                      style: AppTheme.bodyText(greyTextColor)
                          .copyWith(fontSize: 12.sp)),
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
                  widget.isEdit == true && widget.accountData != null && _image == null
                      ? InkWell(
                          onTap: () {
                            _pickImage();
                          },
                          child: CircleAvatar(
                              radius: 60.r,
                              backgroundColor: Colors.transparent,
                              backgroundImage: widget.accountData!.logo != null
                                  ? NetworkImage(
                                      widget.accountData!.logo.toString(),
                                      )
                                  : const AssetImage(
                                      "assets/images/default_logo.webp")),
                        )
                      : InkWell(
                          onTap: () {
                            _pickImage();
                          },
                          child: CircleAvatar(
                            radius: 60.r,
                            backgroundColor: Colors.transparent,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : const AssetImage(
                                    "assets/images/default_logo.webp"),
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
                            // _uploadImage();
                            setState(() {
                              _image = null;
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
            // Container(
            //   height: 45.h,
            //   // color: Colors.green,
            //   child: DropdownSearch<String>(
            //     decoratorProps: DropDownDecoratorProps(
            //       expands: true,
            //       baseStyle: AppTheme.bodyText(lightTextColor),
            //       decoration: InputDecoration(
            //         labelText: 'Industry',
            //         labelStyle: AppTheme.bodyText(greyTextColor),
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(10),
            //           borderSide: const BorderSide(color: borderColor),
            //         ),
            //         focusedBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(10),
            //           borderSide: const BorderSide(color: borderColor),
            //         ),
            //         enabledBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(10),
            //           borderSide: const BorderSide(color: borderColor),
            //         ),
            //       ),
            //     ),
            //     items: (filter, infiniteScrollProps) => industryLists,
            //     selectedItem:
            //         _selectedIndustry.isEmpty ? null : _selectedIndustry,
            //     onChanged: (String? newValue) {
            //       setState(() {
            //         _selectedIndustry = newValue ?? "";
            //       });
            //     },
            //     popupProps: PopupProps.menu(
            //       showSearchBox: true,
            //       searchFieldProps: TextFieldProps(
            //         decoration: InputDecoration(
            //           labelStyle: AppTheme.bodyText(lightTextColor),
            //           hintText: 'Search industry...',
            //           hintStyle: AppTheme.bodyText(lightTextColor),
            //           border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(10),
            //             borderSide: const BorderSide(color: borderColor),
            //           ),
            //           focusedBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(10),
            //             borderSide: const BorderSide(color: borderColor),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // industryError
            //     ? Row(
            //         children: [
            //           Text(
            //             "This field is required",
            //             style: AppTheme.bodyText(Colors.red)
            //                 .copyWith(fontSize: 12.sp),
            //           ),
            //         ],
            //       )
            //     : const SizedBox.shrink(),
            // const SizedBox(
            //   height: 15,
            // ),
            Container(
              height: 50.h,
              // color: Colors.green,
              child: DropdownSearch<String>(
                validator: (_) {
                  if (_selectedFunctionalArea == '') {
                    return "This field is required";
                  }
                  return null;
                },
                decoratorProps: DropDownDecoratorProps(
                  expands: true,
                  baseStyle: AppTheme.bodyText(lightTextColor),
                  decoration: InputDecoration(
                    labelText: 'Functional area',
                    labelStyle: AppTheme.bodyText(greyTextColor),
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
                      hintStyle: AppTheme.bodyText(lightTextColor),
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
                        style: AppTheme.bodyText(Colors.red)
                            .copyWith(fontSize: 12.sp),
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
                  FocusScope.of(context).unfocus();
                  _pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }
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

  Widget _buildLocationDetailsWidget() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _locationFormKey,
            child: Column(
              children: [
                Text("Hi Emergio games",
                    textAlign: TextAlign.center,
                    style: AppTheme.headingText(lightTextColor).copyWith(
                        fontSize: 20.sp, fontWeight: FontWeight.normal)),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Provide your company location details",
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyText(greyTextColor),
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
                                  baseStyle: AppTheme.bodyText(lightTextColor),
                                  decoration: InputDecoration(
                                    labelText: 'City',
                                    labelStyle:
                                        AppTheme.bodyText(greyTextColor),
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
                                      hintStyle:
                                          AppTheme.bodyText(lightTextColor),
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
                                  baseStyle: AppTheme.bodyText(lightTextColor)
                                      .copyWith(),
                                  decoration: InputDecoration(
                                    labelText: 'Country',
                                    labelStyle:
                                        AppTheme.bodyText(greyTextColor),
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
                                      hintStyle:
                                          AppTheme.bodyText(lightTextColor),
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
                                    style: AppTheme.bodyText(Colors.red),
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

  Widget _buildContactDetails() {
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
                    Text("Contact information",
                        textAlign: TextAlign.center,
                        style: AppTheme.headingText(lightTextColor).copyWith(
                            fontSize: 20.sp, fontWeight: FontWeight.normal)),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Provide your contact details",
                        textAlign: TextAlign.center,
                        style: AppTheme.bodyText(greyTextColor)),
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
                  lengthLimit: 10,
                  keyBoardType: TextInputType.number,
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
                  keyBoardType: TextInputType.number,
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
                    listener: (context, state) async{
                  if (widget.isFromHome == true) {
                    if (state is QuestionaireSuccess) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          AnimatedNavigation()
                              .scaleAnimation(SuccessfullyRegisteredScreen()),
                          (Route<dynamic> route) => false);
                      // Navigator.pop(context);
                      CommonSnackbar.show(context, message: "");
                    }
                    if (state is QuestionaireFailure) {
                      CommonSnackbar.show(context,
                          message: "Failed to post job");
                    }
                  }else{
                  if(state is QuestionaireSuccess){

                    Navigator.pushAndRemoveUntil(
                          context,
                          AnimatedNavigation()
                              .scaleAnimation(SuccessfullyRegisteredScreen()),
                          (Route<dynamic> route) => false);
                      CommonSnackbar.show(context, message: "Successfully added company details");
                    
                  }else{
                    CommonSnackbar.show(context, message: "Failed to upload logo");
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
                          final account = AccountData(
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

                              if(_image != null){
                                final result = await _uploadImage();
                                if(result == false){
                                  CommonSnackbar.show(context, message: "Failed to upload logo");
                                  return;
                                }
                              }

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
                                    logo: _image,
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
                                    website: _companyWesiteCont.text,
                                    landline: _landlineNumberCont.text));


                            // Navigator.pushAndRemoveUntil(
                            //     context,
                            //     AnimatedNavigation().scaleAnimation(
                            //         SuccessfullyRegisteredScreen()),
                            //     (Route<dynamic> route) => false);
                          }
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
