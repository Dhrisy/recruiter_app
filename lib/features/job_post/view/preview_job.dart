

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import '../../../core/constants.dart';

// class PreviewJob extends StatefulWidget {
//   final JobPostModel? jobData;
//   const PreviewJob({Key? key, this.jobData}) : super(key: key);

//   @override
//   State<PreviewJob> createState() => _PreviewJobState();
// }

// class _PreviewJobState extends State<PreviewJob> {
//   bool isFresher = true;
//   final TextEditingController emailController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: SafeArea(
//         child: Scaffold(
//           appBar: AppBar(
//             centerTitle: true,
//             leading: Padding(
//               padding: EdgeInsets.only(left: 14.w),
//               child: IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: Icon(Icons.arrow_back_ios)),
//             ),
//             actions: [
//               SizedBox(
//                 height: 20.h,
//                 child: Icon(Icons.bookmark_outline),
//               ),
//               SizedBox(
//                 width: 20.w,
//               ),
//             ],
//           ),
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: Column(
//                 spacing: 15,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [

//                 ],
//                 // children: [
//                 //   JobListingCard(),
                 

//                 //   // Dropdown fields
//                 //   _headingText(
//                 //       text: "Job Details",
//                 //       alignment: MainAxisAlignment.start),
                 
//                 //   _basicDetails(),
//                 //   SizedBox(height: 20.h),
//                 //   Column(
//                 //     crossAxisAlignment: CrossAxisAlignment.start,
//                 //     children: [
//                 //       _headingText(
//                 //           text: "Proffesional Details", color: darkTextColor),
//                 //       SizedBox(
//                 //         height: 20.h,
//                 //       ),
//                 //       proffesionalDetails(
//                 //           benefits:
//                 //               "Lorem ipsum dolor sit amet consectetur. Tristique arcu nam nunc ullamcorper donec aliquam interdum. Dui et eget id aliquet. Vitae libero tellus rhoncus morbi mattis quam. Eget aliquam diam elit velit tempor volutpat eu.",
//                 //           lightDescription:
//                 //               "Lorem ipsum dolor sit amet consectetur. Tristique arcu nam nunc ullamcorper donec aliquam interdum. Dui et eget id aliquet. Vitae libero tellus rhoncus morbi mattis quam. Eget aliquam diam elit velit tempor volutpat eu.",
//                 //           requirements:
//                 //               "Lorem ipsum dolor sit amet consectetur. Tristique arcu nam nunc ullamcorper donec aliquam interdum. Dui et eget id aliquet. Vitae libero tellus rhoncus morbi mattis quam. Eget aliquam diam elit velit tempor volutpat Lorem ipsum dolor sit amet consectetur. Tristique arcu nam nunc ullamcorper donec aliquam interdum. Dui et eget id aliquet. Vitae libero tellus rhoncus morbi mattis quam. Eget aliquam diam elit velit tempor volutpat ",
//                 //           rolesAndResponsibilities:
//                 //               "Lorem ipsum dolor sit amet consectetur. Tristique arcu nam nunc ullamcorper donec aliquam interdum. Dui et eget id aliquet. Vitae libero tellus rhoncus morbi mattis quam. Eget aliquam diam elit velit tempor volutpat Lorem ipsum dolor sit amet consectetur. Tristique arcu nam nunc ullamcorper donec aliquam interdum. Dui et eget id aliquet. Vitae libero tellus rhoncus morbi mattis quam. Eget aliquam diam elit velit tempor volutpat ")
//                 //     ],
//                 //   ),

//                 //   SizedBox(height: 10.h),

//                 //   Column(
//                 //     crossAxisAlignment: CrossAxisAlignment.start,
//                 //     children: [
//                 //       _headingText(text: "About Company", color: darkTextColor),
//                 //       SizedBox(
//                 //         height: 10.h,
//                 //       ),
//                 //       aboutCompany(
//                 //         location: "Hyderabad, India",
//                 //         companyName: "Jaguar pvt.ltd",
//                 //         description:
//                 //             "Lorem ipsum dolor sit amet consectetur. Tristique arcu nam nunc ullamcorper donec aliquam interdum. Dui et eget id aliquet. Vitae libero tellus rhoncus morbi mattis quam. Eget aliquam diam elit velit tempor volutpat eu.",
//                 //       )
//                 //     ],
//                 //   ),
//                 //   SizedBox(
//                 //     height: 20.h,
//                 //   ),
//                 //   // Buttons
//                 // ],
              
              
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _headingText(
//       {String? text,
//       Color? color,
//       MainAxisAlignment alignment = MainAxisAlignment.start}) {
//     return Row(
//       mainAxisAlignment: alignment,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: 10.w),
//           child: Text(
//             text ?? "No Text",
//             style: AppTheme.headingText(color ?? secondaryColor).copyWith(
//               fontWeight: FontWeight.w600,
//               fontSize: 16.sp,
//               decoration: TextDecoration.combine([]),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _basicDetails({
//     String? currentndustry,
//     String? role,
//     String? jobRole,
//     String? department,
//     String? category,
//     String? experience,
//     String? salary,
//     String? location,
//     String? email,
//     String? phone,
//     String? availability,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//           color: lightTextColor,
//           borderRadius: BorderRadius.circular(16.0),
//           border: Border.all(color: secondaryColor),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 2,
//               blurRadius: 2,
//               offset: Offset(0, 3),
//             ),
//           ]),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Industry Type',
//                 style: AppTheme.smallText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 5.h,
//             ),
//             Text(currentndustry ?? "No Data",
//                 style: AppTheme.mediumTitleText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 15.h,
//             ),
//             Text('Role Category',
//                 style: AppTheme.smallText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 5.h,
//             ),
//             Text(role ?? "No Data",
//                 style: AppTheme.mediumTitleText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 15.h,
//             ),
//             Text('Department',
//                 style: AppTheme.smallText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 5.h,
//             ),
//             Text(department ?? "No Data",
//                 style: AppTheme.mediumTitleText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 15.h,
//             ),
//             Text('Job Role',
//                 style: AppTheme.smallText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 5.h,
//             ),
//             Text(jobRole ?? "No Data",
//                 style: AppTheme.mediumTitleText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 15.h,
//             ),
//             Text('Must Have Skills',
//                 style: AppTheme.smallText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 5.h,
//             ),
//             Text(jobRole ?? "No Data",
//                 style: AppTheme.mediumTitleText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 20.h,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 20.h,
//                   child: Image(image: AssetImage("assets/SuitcaseImage.png")),
//                 ),
//                 SizedBox(
//                   width: 20.w,
//                 ),
//                 Text(experience ?? "No Data",
//                     style: AppTheme.mediumTitleText(
//                       darkTextColor,
//                     ).copyWith(fontWeight: FontWeight.w500)),
//               ],
//             ),
//             SizedBox(
//               height: 10.h,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 20.h,
//                   child: Image(image: AssetImage("assets/locationImage.png")),
//                 ),
//                 SizedBox(
//                   width: 20.w,
//                 ),
//                 Text(location ?? "No Data",
//                     style: AppTheme.mediumTitleText(
//                       darkTextColor,
//                     ).copyWith(fontWeight: FontWeight.w500)),
//               ],
//             ),
//             SizedBox(
//               height: 10.h,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 20.h,
//                   child: Image(image: AssetImage("assets/rupeeImage.png")),
//                 ),
//                 SizedBox(
//                   width: 20.w,
//                 ),
//                 Text(salary ?? "No Data",
//                     style: AppTheme.mediumTitleText(
//                       darkTextColor,
//                     ).copyWith(fontWeight: FontWeight.w500)),
//               ],
//             ),
//             SizedBox(
//               height: 10.h,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget proffesionalDetails({
//     String? lightDescription,
//     String? requirements,
//     String? rolesAndResponsibilities,
//     String? benefits,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//           color: lightTextColor,
//           borderRadius: BorderRadius.circular(16.0),
//           border: Border.all(color: buttonColor),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 2,
//               blurRadius: 2,
//               offset: Offset(0, 3),
//             ),
//           ]),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('What you\'ll do',
//                 style: AppTheme.mediumTitleText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 5.h,
//             ),
//             Text(lightDescription ?? "No Data",
//                 style: AppTheme.smallText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 15.h,
//             ),
//             Text('Requirements',
//                 style: AppTheme.mediumTitleText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 5.h,
//             ),
//             Text(requirements ?? "No Data",
//                 style: AppTheme.smallText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 15.h,
//             ),
//             Text('Roles and Responsibilities',
//                 style: AppTheme.mediumTitleText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 5.h,
//             ),
//             Text(rolesAndResponsibilities ?? "No Data",
//                 style: AppTheme.smallText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 15.h,
//             ),
//             Text('Benefits',
//                 style: AppTheme.mediumTitleText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 5.h,
//             ),
//             Text(benefits ?? "No Data",
//                 style: AppTheme.smallText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 15.h,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget aboutCompany({
//     String? description,
//     String? companyName,
//     String? location,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//           color: lightTextColor,
//           borderRadius: BorderRadius.circular(16.0),
//           border: Border.all(color: secondaryColor),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 2,
//               blurRadius: 2,
//               offset: Offset(0, 3),
//             ),
//           ]),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(description ?? "No Data",
//                 style: AppTheme.smallText(
//                   darkTextColor,
//                 ).copyWith()),
//             SizedBox(
//               height: 15.h,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 20.h,
//                   child: Image(image: AssetImage("assets/SuitcaseImage.png")),
//                 ),
//                 SizedBox(
//                   width: 20.w,
//                 ),
//                 Text(companyName ?? "No Data",
//                     style: AppTheme.mediumTitleText(
//                       darkTextColor,
//                     ).copyWith(fontWeight: FontWeight.w500)),
//               ],
//             ),
//             SizedBox(
//               height: 10.h,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 20.h,
//                   child: Image(image: AssetImage("assets/locationImage.png")),
//                 ),
//                 SizedBox(
//                   width: 20.w,
//                 ),
//                 Text(location ?? "No Data",
//                     style: AppTheme.mediumTitleText(
//                       darkTextColor,
//                     ).copyWith(fontWeight: FontWeight.w500)),
//               ],
//             ),
//             SizedBox(
//               height: 10.h,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class JobListingCard extends StatelessWidget {
//   const JobListingCard({
//     Key? key,
//     this.onTap,
//   }) : super(key: key);

//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return InkWell(
//       onTap: onTap,
//       child: Row(
//         children: [
//           // Company Logo
//           Container(
//             height: 100.h,
//             width: 100.w,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: const Color(0xFF6D28D9),
//             ),
//             child: const Center(
//               child: Text(
//                 'zepto',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),

//           // Job Details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Job Title
//                 Text(
//                   'Senior Software Engineer',
//                   style: theme.textTheme.titleLarge!
//                       .copyWith(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),

//                 // Company Name
//                 const Text(
//                   'Compnay name',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class StepperScreen extends StatefulWidget {
  const StepperScreen({Key? key}) : super(key: key);

  @override
  _StepperScreenState createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  int _currentStep = 0;
  String? name;
  String? email;
  String? address;

  Widget _buildDivider() {
    return Container(
      width: 70,
      height: 1,
      color: Colors.grey,
    );
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
              color: isActive ? Colors.blue : Colors.grey,
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

  List<Step> getSteps() {
    return [
      Step(
        title: const Text('Personal'),
        content: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Enter your name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => name = value),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => email = value),
                ),
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Address'),
        content: Container(
          margin: const EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Enter your address',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
            onChanged: (value) => setState(() => address = value),
          ),
        ),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Confirm'),
        content: Container(
          margin: const EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${name ?? "Not provided"}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: ${email ?? "Not provided"}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Address: ${address ?? "Not provided"}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
        isActive: _currentStep >= 2,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horizontal Stepper'),
        centerTitle: true,
      ),
      body: Column(
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  getSteps()[_currentStep].content,
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_currentStep > 0)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (_currentStep > 0) {
                                  _currentStep--;
                                }
                              });
                            },
                            child: const Text('BACK'),
                          ),
                        if (_currentStep > 0)
                          const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_currentStep < getSteps().length - 1) {
                                _currentStep++;
                              }
                            });
                          },
                          child: Text(
                            _currentStep < getSteps().length - 1
                                ? 'NEXT'
                                : 'FINISH',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}