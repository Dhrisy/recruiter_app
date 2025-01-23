import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/resdex/model/email_template_model.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';

class EmailTemplateDetails extends StatefulWidget {
  final EmailTemplateModel emailTemplate;
  const EmailTemplateDetails({Key? key,
  required this.emailTemplate
  }) : super(key: key);

  @override
  State<EmailTemplateDetails> createState() => _EmailTemplateDetailsState();
}

class _EmailTemplateDetailsState extends State<EmailTemplateDetails> {
  final QuillController _controller = QuillController.basic();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final FocusNode _editorFocusNode = FocusNode();
  late QuillController _quillController;

  @override
  void initState() {
    super.initState();

    _quillController = QuillController.basic();
    setEmail();
  }

  void setEmail() async {
    final email = await CustomFunctions().retrieveCredentials("email");
    setState(() {
      _fromController.text = email.toString();
      _subjectController.text = widget.emailTemplate.subject.toString();
      
      if (widget.emailTemplate!.body != null) {
          try {
            // First attempt: Try parsing as JSON string
            final bodyData = jsonDecode(widget.emailTemplate!.body as String);
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
              _quillController.document
                  .insert(0, widget.emailTemplate!.body as String);
            }
          } catch (e) {
            // If JSON parsing fails, treat as plain text
            _quillController.document
                .insert(0, widget.emailTemplate!.body as String);
          }
        }

    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _toController.dispose();
    _subjectController.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          // appBar: AppBar(
          //   title: Text(
          //     'Email template',
          //     style: Theme.of(context).textTheme.titleMedium!.copyWith(
          //       fontWeight: FontWeight.bold
          //     ),
          //   ),
          //   // actions: [
          //   //   IconButton(
          //   //     icon: const Icon(Icons.attachment),
          //   //     onPressed: () {
          //   //       // Handle attachment
          //   //     },
          //   //   ),
          //   //   IconButton(
          //   //     icon: const Icon(Icons.send),
          //   //     onPressed: () {
          //   //       // Handle send email
          //   //     },
          //   //   ),
          //   // ],
          // ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                CommonAppbarWidget(
                  isBackArrow: true,
                  title: "Email template",
                  icon: Icons.send,
                  action: (){
                    print("wwwwwwwwwwwwwwwwww");
                  },
                  ),
        
        
                _buildFromField(),
                _buildRecipientField(),
                _buildSubjectField(),
                const Divider(height: 1),
                _buildEditor(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFromField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Text("From : ",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 14.sp, color: Colors.grey
          ),),
          Expanded(
            child: TextField(
              controller: _fromController,
              decoration: InputDecoration(
                hintText: 'From',
                hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15.h),
              ),
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipientField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TextField(
        controller: _toController,
        decoration: InputDecoration(
          hintText: 'To',
          hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15.h),
        ),
        style: TextStyle(fontSize: 14.sp),
      ),
    );
  }

  Widget _buildSubjectField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Text("Subject : ",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 14.sp, color: Colors.grey
          ),),
          Expanded(
            child: TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                hintText: 'Subject',
                hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15.h),
              ),
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
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
        ));
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
}
