import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/resdex/email_template_form.dart';
import 'package:recruiter_app/features/resdex/model/email_template_model.dart';
import 'package:recruiter_app/features/resdex/provider/email_template_provider.dart';
import 'package:recruiter_app/features/resdex/widgets/email_template_details.dart';
import 'package:recruiter_app/widgets/common_alertdialogue.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';


class EmailTemplateCard extends StatelessWidget {
  final EmailTemplateModel template;
  final bool? check;
  final Function(bool?)? onChanged;
  final bool? value;
  const EmailTemplateCard({Key? key, required this.template, this.check, this.onChanged, this.value}) : super(key: key);

  String formatDate(String date) {
    print(date);
    // Parse the original date string
    DateTime parsedDate = DateTime.parse(date);

    // Format the date to dd-MM-yyyy
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: OpenContainer(
          transitionType: ContainerTransitionType.fade,
          transitionDuration: const Duration(milliseconds: 500),
          closedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          closedBuilder: (BuildContext context, VoidCallback openContainer) {
            return InkWell(
              onTap: (){
                Navigator.push(context, 
                AnimatedNavigation().scaleAnimation(EmailTemplateDetails(
                  emailTemplate: template,
                )));
              },
              child: AnimatedContainer(
                
                duration: 500.ms,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 5,
                          color: borderColor,
                          offset: const Offset(-2, 1))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      check == true
                      ? Checkbox(value: value ?? false, 
                      onChanged: onChanged ?? (_){}
                      ): const SizedBox.shrink(),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            CustomFunctions.toSentenceCase(
                                template.templateName ?? "N/A"),
                            style: theme.textTheme.titleMedium!.copyWith(
                                fontSize: 14.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Created on : ${formatDate(template.createdOn.toString())}",
                            style: theme.textTheme.titleMedium!.copyWith(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal,
                                color: greyTextColor),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          InkWell(
                            onTap: () {
                              openContainer();
                            },
                            child: Icon(
                              Icons.edit,
                              size: 18.sp,
                              color: const Color.fromARGB(255, 148, 129, 205),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              CustomFunctions().shareContent(
                                  content: "${template.body}",
                                  subject: "${template.subject}");
                            },
                            child: Icon(
                              Icons.share,
                              size: 18.sp,
                              color: const Color.fromARGB(255, 148, 129, 205),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (template.id != null) {
                                _showDeleteDialogue(context, id: template.id!);
                              }
                            },
                            child: Icon(
                              Icons.delete,
                              size: 18.sp,
                              color: const Color.fromARGB(255, 148, 129, 205),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.5, end: 0),
            );
          },
          openBuilder: (BuildContext context, VoidCallback closeContainer) {
            return EmailTemplateForm(
              isEdit: true,
              emailTemplte: template,
            );
          },
        ));
  }

  void _showDeleteDialogue(BuildContext context, {required int id}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CommonAlertDialog(
              title: "Delete",
              message: "Are you sure want to delete this template?",
              cancelButtonText: "No",
              confirmButtonText: "Yes",
              height: 80.h,
              titleColor: Colors.red,
              onConfirm: () async {
                final result = await Provider.of<EmailTemplateProvider>(context,
                        listen: false)
                    .deleteTemplate(id: template.id!);
                if (result == "success") {
                   Navigator.pop(context);
                  CommonSnackbar.show(context,
                      message: "Successfully deleted the template");
                  Provider.of<EmailTemplateProvider>(context, listen: false)
                      .fetchEmailTemplates();
                } else {
                   Navigator.pop(context);
                  CommonSnackbar.show(context, message: result.toString());
                }
              },
              onCancel: () {
                Navigator.pop(context);
              });
          // return AlertDialog(
          //   backgroundColor: Colors.white,
          //   title: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         "Delete",
          //         style: Theme.of(context).textTheme.titleMedium!.copyWith(
          //             color: Colors.red,
          //             fontWeight: FontWeight.bold,
          //             fontSize: 17.sp),
          //       ),
          //     ],
          //   ),
          //   content: AnimatedContainer(
          //       duration: 500.ms,
          //       height: 100.h,
          //       decoration: const BoxDecoration(color: Colors.white),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text("Are you sure want to delete this template?"),
          //           Row(
          //             spacing: 15,
          //             children: [
          //               Expanded(
          //                 child: ReusableButton(
          //                     height: 40,
          //                     textColor: Colors.white,
          //                     action: () {},
          //                     text: "No",
          //                     buttonColor: secondaryColor),
          //               ),
          //               Expanded(
          //                   child: ReusableButton(
          //                 height: 40,
          //                 textColor: Colors.white,
          //                 action: () {},
          //                 text: "Yes",
          //               ))
          //             ],
          //           )
          //         ],
          //       )),
          // ).animate().fadeIn(duration: 200.ms).scale();
        });
  }
}
