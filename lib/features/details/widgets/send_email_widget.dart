import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/features/job_post/viewmodel.dart/job_posting_provider.dart';
import 'package:recruiter_app/features/resdex/model/email_template_model.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';
import 'package:recruiter_app/features/resdex/provider/email_template_provider.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';
import 'package:recruiter_app/widgets/email_template_card.dart';
import 'package:url_launcher/url_launcher.dart';

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

  EmailTemplateModel? selectedTemplate;

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

  // void _showPrevewEmailAlert(
  //     {required BuildContext context,
  //     required EmailTemplateModel template}) async {
  //   final email = await CustomFunctions().retrieveCredentials("email");
  //   final toEmail = widget.seekerData.personalData != null
  //       ? widget.seekerData.personalData!.user.email.toString()
  //       : "";
  //   final TextEditingController _emailCont =
  //       TextEditingController(text: email ?? "");
  //   final TextEditingController _toCont = TextEditingController(text: toEmail);
  //   final TextEditingController _subCont =
  //       TextEditingController(text: template.subject ?? "");
  //   final TextEditingController _msgCont =
  //       TextEditingController(text: template.body ?? "");

  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           backgroundColor: Colors.white,
  //           title: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 "Preview Dialogue",
  //                 style: Theme.of(context).textTheme.titleMedium!.copyWith(
  //                     color: secondaryColor,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 17.sp),
  //               ),
  //             ],
  //           ),
  //           content: AnimatedContainer(
  //             duration: 500.ms,
  //             height: 500.h,
  //             decoration: const BoxDecoration(color: Colors.white),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   spacing: 10,
  //                   children: [
  //                     Text("from"),
  //                     ReusableTextfield(
  //                       controller: _emailCont,
  //                       hintText: "from email",
  //                     ),
  //                     Text("to"),
  //                     ReusableTextfield(
  //                       controller: _toCont,
  //                       hintText: "to email",
  //                     ),
  //                     Text("Subject"),
  //                     ReusableTextfield(
  //                       controller: _subCont,
  //                       hintText: "subject",
  //                       maxLines: 2,
  //                     ),
  //                     Text("Message"),
  //                     ReusableTextfield(
  //                       controller: _msgCont,
  //                       hintText: "message",
  //                       maxLines: 6,
  //                     )
  //                   ],
  //                 ),
  //                 Row(
  //                   spacing: 15,
  //                   children: [
  //                     Expanded(
  //                       child: ReusableButton(
  //                         height: 40,
  //                         textColor: Colors.white,
  //                         action: () {
  //                           Navigator.pop(context);
  //                         },
  //                         text: "Cancel",
  //                         buttonColor: secondaryColor,
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: ReusableButton(
  //                         height: 40,
  //                         textColor: Colors.white,
  //                         action: () {
  //                           sendEmail();
  //                           // sendEmailManually();
  //                         },
  //                         text: "Send",
  //                         // isLoading: isLoading,
  //                       ),
  //                     )
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ),
  //         ).animate().fadeIn(duration: 200.ms).scale();
  //       });
  // }

  Future<void> sendEmailManually() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'ddhrisyal2000@gmail.com',
      queryParameters: {
        'subject': 'Hello from Flutter',
        'body': 'This is a test email from Flutter!',
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      print("Could not open the email client.");
    }
  }

  Future<void> sendEmail(
      {required String body,
      required String subject,
      required String recepients,
      required List<String> cc,
      required List<String> bcc}) async {
    try {
      final Email email = Email(
        body: body,
        subject: subject,
        recipients: [recepients],
        cc: cc,
        bcc: bcc,
        // attachmentPaths: ['/path/to/attachment.zip'],
        isHTML: false,
      );

      await FlutterEmailSender.send(email);
    } catch (e) {
      print(e);
      CommonSnackbar.show(context, message: e.toString());
    }
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
                                          selectedTemplate =
                                              provider.emailTemplate![index];
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            spacing: 8,
                            children: [

                              _buildSelectJob(),
                              const SizedBox(
                                height: 15,
                              ),
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
                                      borderRadius:
                                          BorderRadius.circular(15.r)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius:
                                          BorderRadius.circular(15.r)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius:
                                          BorderRadius.circular(15.r)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
          isTemplate == true
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: secondaryColor),
                            onPressed: () {
                              if (selectedTemplate != null &&
                                  widget.seekerData.personalData != null) {
                                     Navigator.pop(context);
                                sendEmail(
                                    body: selectedTemplate!.body ?? "",
                                    subject: selectedTemplate!.subject ?? "",
                                    recepients: widget
                                        .seekerData.personalData!.user.email
                                        .toString(),
                                    cc: [],
                                    bcc: []);
                              }
                            },
                            label: Text("Preview Email",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.white))),
                      ],
                    ),
                  ),
                )
              : Align(
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

                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context);
                                sendEmail(
                                    body: _desCont.text,
                                    subject: _subjectController.text,
                                    recepients: _toNameController.text,
                                    cc: [],
                                    bcc: []);
                              }
                            },
                            label: Text("Send Email",
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

   Widget _buildSelectJob() {
    return Consumer<JobPostingProvider>(builder: (context, provider, child) {
      List<String> _jobTitleLists = provider.jobLists != null
          ? provider.jobLists!.map((job) {
              return job.title ?? '';
            }).toList()
          : [];
      return Container(
        constraints: BoxConstraints(
          maxHeight: 55.h,
        ),
        child: DropdownSearch<String>(
          validator: (_) {
            if (selectedJob == '') {
              return "This field is required";
            }
            return null;
          },
          decoratorProps: DropDownDecoratorProps(
            expands: false,
            decoration: InputDecoration(
              labelText: "Select job",
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
          items: (filter, infiniteScrollProps) => _jobTitleLists,
          selectedItem: selectedJob.isEmpty ? null : selectedJob,
          onChanged: (selectedTitle) {
            if (selectedTitle != null && provider.jobLists != null) {
              final selectedJobModel = provider.jobLists!.firstWhere(
                (job) => job.title == selectedTitle,
                orElse: () => JobPostModel(),
              );

              if (selectedJobModel.id != null) {
                setState(() {
                  selectedJob = selectedTitle;
                  selectedJobId = selectedJobModel.id!;
                });
              }

              FocusScope.of(context).unfocus();
            }
          },
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search job",
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
            if (value?.isEmpty == true && !_showSalaryDetails) {
              return 'This field is required';
            }
            if (isEmail &&
                value?.isNotEmpty == true &&
                !_isValidEmail(value!)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
      ],
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
