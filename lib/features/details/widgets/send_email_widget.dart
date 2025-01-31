import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';
import 'package:recruiter_app/features/resdex/provider/email_template_provider.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';
import 'package:recruiter_app/widgets/common_empty_list.dart';
import 'package:recruiter_app/widgets/email_template_card.dart';
import 'package:recruiter_app/widgets/reusable_textfield.dart';
import 'package:recruiter_app/widgets/shimmer_list_loading.dart';

class SendEmailWidget extends StatefulWidget {
  final SeekerModel seekerData;
  const SendEmailWidget({Key? key, required this.seekerData}) : super(key: key);

  @override
  _SendEmailWidgetState createState() => _SendEmailWidgetState();
}

class _SendEmailWidgetState extends State<SendEmailWidget> {
  final _formKey = GlobalKey<FormState>();
  final _toNameController = TextEditingController();
  final _fromEmailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _desCont = TextEditingController();
  final _currencyController = TextEditingController();
  final _periodicityController = TextEditingController();
  final _jobNameCont = TextEditingController();
  late QuillController _quillController;
  bool _showSalaryDetails = false;
  String selectedJob = '';
  int? selectedJobId;
  String email = '';

  bool isTemplate = false;
  bool isSelect = false;

  @override
  void initState() {
    super.initState();
    setEmail();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmailTemplateProvider>(context, listen: false)
          .fetchEmailTemplates();
    });
  }

  void setEmail() async {
    _fromEmailController.text =
        await CustomFunctions().retrieveCredentials("email") ?? "N/A";
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
            SafeArea(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Consumer<EmailTemplateProvider>(
                  builder: (context, provider, child) {
                return Form(
                  child: Column(
                    spacing: 20,
                    children: [
                      CommonAppbarWidget(
                          isBackArrow: true, title: "Send Email"),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: _buildBasicFields(),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildBasicFields() {
    return Consumer<EmailTemplateProvider>(builder: (context, provider, child) {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              spacing: 15,
              children: [
                isTemplate == true
                    ? Column(
                        children: [
                          if (provider.emailTemplate == null) const Text(""),
                          if (provider.emailTemplate != null &&
                              provider.emailTemplate!.isEmpty)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isTemplate = false;
                                });
                              },
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_rounded,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          color: borderColor,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Create Template",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: greyTextColor),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          if (provider.emailTemplate!.isNotEmpty)
                            SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                    provider.emailTemplate!.length, (index) {
                                  final template =
                                      provider.emailTemplate![index];
                                  final borderColor = index.isEven
                                      ? buttonColor
                                      : secondaryColor;
                                  return EmailTemplateCard(
                                      check: true,
                                      onChanged: (value) {
                                        setState(() {
                                          isSelect = value ?? false;
                                        });
                                      },
                                      value: isSelect,
                                      template: template);
                                }),
                              ),
                            )
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          spacing: 8,
                          children: [
                            _buildInputField(
                              controller: _fromEmailController,
                              label: 'From Email',
                              hint: 'Enter email address',
                              isEmail: true,
                            ),
                            _buildInputField(
                              controller: _toNameController,
                              label: 'To',
                              hint: '',
                              isEmail: true,
                            ),
                            _buildInputField(
                              maxLines: 2,
                              controller: _subjectController,
                              label: 'Subject',
                              hint: 'Enter email subject',
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _desCont,
                              maxLines: 10,
                              decoration: InputDecoration(
                                hintText: "Write a message...",
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: greyTextColor,
                                    ),
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15.r)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15.r)),
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15.r)),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor),
                      onPressed: () {
                        setState(() {
                          isTemplate = false;
                        });
                      },
                      label: Text("Create Email",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white))),
                  Text("or"),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor),
                      onPressed: () {
                        setState(() {
                          isTemplate = true;
                        });
                      },
                      label: Text(
                        "Select from template",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white),
                      ))
                ],
              ),
            ),
          )
        ],
      );
    });
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    bool isEmail = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) {
            // if (value?.isEmpty == true && !_showSalaryDetails) {
            //   return '$label is required';
            // }
            // if (isEmail && value?.isNotEmpty == true && !_isValidEmail(value!)) {
            //   return 'Please enter a valid email';
            // }
            // return null;
          },
        ),
      ],
    );
  }

  // Widget _buildInputField({
  //   required TextEditingController controller,
  //   required String label,
  //   required String hint,
  //   required IconData icon,
  //   bool isEmail = false,
  //   int maxLines = 1,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(left: 4, bottom: 8),
  //         child: Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.grey[700],
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //       ),
  //       ReusableTextfield(
  //         maxLines: maxLines,
  //         float: FloatingLabelBehavior.never,
  //         controller: controller,
  //         hintText: hint,

  //         labelText: "",
  //         validation: (_) {
  //           if (controller.text.trim().isEmpty) {
  //             return "This field is required";
  //           }
  //           return null;
  //         },
  //         keyBoardType:
  //             isEmail ? TextInputType.emailAddress : TextInputType.text,
  //       )
  //     ],
  //   );
  // }
}
