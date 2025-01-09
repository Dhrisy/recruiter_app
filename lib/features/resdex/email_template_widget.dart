import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailTemplateForm extends StatefulWidget {
  final Function(String, String, String, String)? onSubmit;

  const EmailTemplateForm({Key? key, this.onSubmit}) : super(key: key);

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
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      color: const Color.fromARGB(255, 228, 228, 228),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 228, 228, 228),
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
                      children: [
                        _buildInputField(
                          controller: _salaryController,
                          label: 'Salary Amount',
                          hint: 'Enter salary amount',
                          icon: Icons.attach_money,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: _currencyController,
                          label: 'Currency',
                          hint: 'Enter currency (e.g., USD)',
                          icon: Icons.currency_exchange,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: _periodicityController,
                          label: 'Periodicity',
                          hint: 'Enter periodicity (e.g., Annual)',
                          icon: Icons.calendar_today,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              )
            : const SizedBox(),
      ),
    );
  }

  Widget _buildBasicFields() {
    return Column(
      children: [
        _buildInputField(
          controller: _templateNameController,
          label: 'Template Name',
          hint: 'Enter template name',
          icon: Icons.description_outlined,
        ),
        const SizedBox(height: 16),
        _buildInputField(
          controller: _fromEmailController,
          label: 'From Email',
          hint: 'Enter email address',
          icon: Icons.email_outlined,
          isEmail: true,
        ),
        const SizedBox(height: 16),
        _buildInputField(
          controller: _subjectController,
          label: 'Subject',
          hint: 'Enter email subject',
          icon: Icons.subject,
        ),
        const SizedBox(height: 16),
        _buildSalaryToggle(),
        _buildSalaryFields(),
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
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon:
                Icon(icon, color: primaryColor.withOpacity(0.7), size: 20),
            filled: true,
            fillColor: backgroundColor,
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
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) {
            if (value?.isEmpty == true && !_showSalaryDetails) {
              return '$label is required';
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
