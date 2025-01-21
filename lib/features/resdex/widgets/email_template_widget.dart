import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/resdex/provider/email_template_provider.dart';
import 'package:recruiter_app/widgets/common_empty_list.dart';
import 'package:recruiter_app/widgets/common_error_widget.dart';
import 'package:recruiter_app/widgets/email_template_card.dart';
import 'package:recruiter_app/widgets/shimmer_list_loading.dart';

class EmailTemplateWidget extends StatefulWidget {
  const EmailTemplateWidget({Key? key}) : super(key: key);

  @override
  _EmailTemplateWidgetState createState() => _EmailTemplateWidgetState();
}

class _EmailTemplateWidgetState extends State<EmailTemplateWidget> {
bool loading = true;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmailTemplateProvider>(context, listen: false)
          .fetchEmailTemplates();
    });
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Easily manage and customize email templates for various job roles and communication needs. Use these templates to streamline your workflow and maintain consistent, professional communication with candidates",
          textAlign: TextAlign.justify,
          style: theme.textTheme.bodyMedium?.copyWith(color: greyTextColor),
        ),
        const SizedBox(height: 20), // Replace spacing parameter with SizedBox
        Text(
          "Email Templates",
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Consumer<EmailTemplateProvider>(builder: (context, provider, child) {
          if (provider.emailTemplate == null ) {
            return const Text("");
          }
          if (loading == true) {
            return const ShimmerListLoading();
          } else if (provider.emailTemplate != null &&
              provider.emailTemplate!.isEmpty &&
              loading == false) {
            return const CommonEmptyList(
              text: "The lists of seekers are currently empty",
            );
          } else if (provider.emailTemplate!.isNotEmpty) {
            return Column(
              children: List.generate(provider.emailTemplate!.length, (index) {
                final template = provider.emailTemplate![index];
                final borderColor = index.isEven ? buttonColor : secondaryColor;
                return EmailTemplateCard(template: template);
              }),
            );
          } else {
            return const CommonErrorWidget();
          }
        }),
      ],
    );
  }
}
