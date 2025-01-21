import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/resdex/email_template_form.dart';
import 'package:recruiter_app/features/resdex/model/email_template_model.dart';

class EmailTemplateCard extends StatelessWidget {
  final EmailTemplateModel template;
  const EmailTemplateCard({Key? key, required this.template}) : super(key: key);

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
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          closedBuilder: (BuildContext context, VoidCallback openContainer) {
            return AnimatedContainer(
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
                          onTap: () {},
                          child: Icon(
                            Icons.share,
                            size: 18.sp,
                            color: const Color.fromARGB(255, 148, 129, 205),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
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
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.5, end: 0);
          },
          openBuilder: (BuildContext context, VoidCallback closeContainer) {
            return EmailTemplateForm(
              isEdit: true,
              emailTemplte: template,
              
            );
          },
        ));
  }
}
