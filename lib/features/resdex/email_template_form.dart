import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/resdex/model/email_template_model.dart';
import 'package:recruiter_app/features/resdex/provider/email_template_provider.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';
import 'package:recruiter_app/widgets/reusable_textfield.dart';

class EmailTemplateForm extends StatefulWidget {
  final Function(String, String, String, String)? onSubmit;
  final EmailTemplateModel? emailTemplte;
  final bool isEdit;

  const EmailTemplateForm(
      {Key? key, this.onSubmit, this.emailTemplte, required this.isEdit})
      : super(key: key);

  @override
  State<EmailTemplateForm> createState() => _EmailTemplateFormState();
}

class _EmailTemplateFormState extends State<EmailTemplateForm> {
  final _formKey = GlobalKey<FormState>();
  final _templateNameController = TextEditingController();
  final _fromEmailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _salaryController = TextEditingController();
  final _currencyController = TextEditingController();
  final _periodicityController = TextEditingController();
  late QuillController _quillController;
  bool _showSalaryDetails = false;

  /// const colors aayt replace
  final primaryColor = const Color(0xFFFF5722);
  final secondaryColor = const Color(0xFFFBE9E7);
  final backgroundColor = const Color(0xFFFAFAFA);

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
    setEmail();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.emailTemplte != null) {
        _templateNameController.text =
            widget.emailTemplte!.templateName.toString();
        _fromEmailController.text = widget.emailTemplte!.email.toString();
        _subjectController.text = widget.emailTemplte!.subject.toString();
        // final document = Document.fromJson(widget.emailTemplte!.body as List);
        // _quillController = QuillController(
        //   document: document,
        //   selection: const TextSelection.collapsed(offset: 0),
        // );
         // Handle the body text
          if (widget.emailTemplte!.body != null) {
            try {
              // First attempt: Try parsing as JSON string
              final bodyData = jsonDecode(widget.emailTemplte!.body as String);
              if (bodyData is List) {
                final document = Document.fromJson(bodyData);
                setState(() {
                  _quillController = QuillController(
                    document: document,
                    selection: const TextSelection.collapsed(offset: 0),
                  );
                });
              } else {
                // If not a List, treat as plain text
                _quillController.document.insert(0, widget.emailTemplte!.body as String);
              }
            } catch (e) {
              // If JSON parsing fails, treat as plain text
              _quillController.document.insert(0, widget.emailTemplte!.body as String);
            }
          }
      }
    });
  }

  void setEmail() async {
    _fromEmailController.text =
        await CustomFunctions().retrieveCredentials("email") ?? "N/A";
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        // color: const Color.fromARGB(255, 228, 228, 228),
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
                    const SizedBox(height: 20),
                    _buildEditor(),
                  ],
                ),
              ),
            ),
            Consumer<EmailTemplateProvider>(
                builder: (context, provider, child) {
              return ReusableButton(
                  isLoading: provider.isLoading,
                  action: () async {
                    if (_formKey.currentState!.validate()) {
                      if (widget.isEdit == true && widget.emailTemplte != null) {
                        final template = EmailTemplateModel(
                            body: _quillController.document.toPlainText(),
                            jobId: "28",
                            subject: _subjectController.text,
                            email: _fromEmailController.text,
                            templateName: _templateNameController.text,
                            id: widget.emailTemplte!.id
                            );
                        final result =
                            await provider.updateTemaplte(template: template);

                        if (result == "success") {
                          Navigator.pop(context);
                          CommonSnackbar.show(context,
                              message: "Successfully saved the changes");
                        } else {
                          CommonSnackbar.show(context,
                              message: result.toString());
                        }
                      } else {
                        final template = EmailTemplateModel(
                            body: _quillController.document.toPlainText(),
                            jobId: "28",
                            subject: _subjectController.text,
                            email: _fromEmailController.text,
                            templateName: _templateNameController.text);
                        final result =
                            await provider.createTemplate(template: template);

                        if (result == "success") {
                          Navigator.pop(context);
                          CommonSnackbar.show(context,
                              message: "Successfully created email template");
                        } else {
                          CommonSnackbar.show(context,
                              message: result.toString());
                        }
                      }
                    }
                  },
                  textColor: Colors.white,
                  text: widget.isEdit ? "Save Template" : "Create Template",
                  buttonColor: secondaryColor);
            })
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryToggle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          setState(() {
            _showSalaryDetails = !_showSalaryDetails;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _showSalaryDetails
                ? primaryColor.withOpacity(0.1)
                : backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _showSalaryDetails ? primaryColor : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.monetization_on_outlined,
                size: 20,
                color: _showSalaryDetails ? primaryColor : Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                'Add Salary Details',
                style: TextStyle(
                  color: _showSalaryDetails ? primaryColor : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                _showSalaryDetails ? Icons.remove : Icons.add,
                size: 20,
                color: _showSalaryDetails ? primaryColor : Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalaryFields() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _showSalaryDetails ? null : 0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _showSalaryDetails ? 1.0 : 0.0,
        child: _showSalaryDetails
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      spacing: 16,
                      children: [
                        _buildInputField(
                          controller: _salaryController,
                          label: 'Salary Amount',
                          hint: 'Enter salary amount',
                          icon: Icons.attach_money,
                        ),
                        _buildInputField(
                          controller: _currencyController,
                          label: 'Currency',
                          hint: 'Enter currency (e.g., USD)',
                          icon: Icons.currency_exchange,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const SizedBox(),
      ),
    );
  }

  Widget _buildBasicFields() {
    return Column(
      spacing: 16,
      children: [
        _buildInputField(
          controller: _templateNameController,
          label: 'Template Name',
          hint: 'Enter template name',
          icon: Icons.description_outlined,
        ),
        _buildInputField(
          controller: _fromEmailController,
          label: 'From Email',
          hint: 'Enter email address',
          icon: Icons.email_outlined,
          isEmail: true,
        ),
        _buildInputField(
          controller: _subjectController,
          label: 'Subject',
          hint: 'Enter email subject',
          icon: Icons.subject,
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
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
        ReusableTextfield(
          float: FloatingLabelBehavior.never,
          controller: controller,
          hintText: hint,
          labelText: label,
          validation: (_) {
            if (controller.text.trim().isEmpty) {
              return "This field is required";
            }
            return null;
          },
          keyBoardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text,
        )
      ],
    );
  }

  Widget _buildEditor() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: _quillController,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('en'),
                ),
                multiRowsDisplay: false,
                showDividers: false,
                showFontFamily: false,
                showFontSize: false,
                showBoldButton: true,
                showItalicButton: true,
                showSmallButton: false,
                showUnderLineButton: false,
                showStrikeThrough: false,
                showInlineCode: false,
                showColorButton: false,
                showBackgroundColorButton: false,
                showClearFormat: false,
                showAlignmentButtons: false,
                showLeftAlignment: false,
                showCenterAlignment: false,
                showRightAlignment: false,
                showJustifyAlignment: false,
                showHeaderStyle: false,
                showListNumbers: true,
                showListBullets: true,
                showListCheck: false,
                showCodeBlock: false,
                showQuote: false,
                showIndent: false,
                showLink: false,
                showUndo: true,
                showRedo: true,
                showSubscript: false,
                showSuperscript: false,
                showSearchButton: false,
              ),
            ),
          ),
          Container(
            height: 300,
            padding: const EdgeInsets.all(20),
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: _quillController,
                // readOnly: false,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('en'),
                ),
                placeholder: 'Write your email content here...',
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveTemplate() {
    if (_formKey.currentState!.validate()) {
      String salaryDetails = '';
      if (_showSalaryDetails) {
        salaryDetails = '''
Salary: ${_salaryController.text}
Currency: ${_currencyController.text}
Periodicity: ${_periodicityController.text}
''';
      }

      widget.onSubmit?.call(
        _templateNameController.text,
        _fromEmailController.text,
        _subjectController.text,
        _quillController.document.toPlainText() +
            (_showSalaryDetails ? '\n\n$salaryDetails' : ''),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Template saved successfully!'),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(20),
        ),
      );
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  void dispose() {
    _templateNameController.dispose();
    _fromEmailController.dispose();
    _subjectController.dispose();
    _salaryController.dispose();
    _currencyController.dispose();
    _periodicityController.dispose();
    _quillController.dispose();
    super.dispose();
  }
}
