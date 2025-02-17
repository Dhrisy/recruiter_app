import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';

class ReusableTextfield extends StatefulWidget {
  final String? labelText;
  final TextEditingController controller;
  final String? Function(String?)? validation;
  final TextInputType? keyBoardType;
  final bool? isRequired;
  final void Function(String)? onChanged;
  final int? maxLines;
  final String? hintText;
  final Color? borderColor;
  final void Function(String)? onSubmit;
  final FloatingLabelBehavior? float;
  final int? lengthLimit;
  const ReusableTextfield(
      {Key? key,
      this.labelText,
      required this.controller,
      this.keyBoardType,
      this.validation,
      this.isRequired,
      this.onChanged,
      this.maxLines,
      this.hintText,
      this.onSubmit,
      this.float,
      this.borderColor,
      this.lengthLimit})
      : super(key: key);

  @override
  _ReusableTextfieldState createState() => _ReusableTextfieldState();
}

class _ReusableTextfieldState extends State<ReusableTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validation,
      keyboardType: widget.keyBoardType,
      onChanged: widget.onChanged ?? (_) {},
      onFieldSubmitted: widget.onSubmit ?? (_) {},
      maxLines: widget.maxLines ?? 1,
      style: AppTheme.bodyText(lightTextColor),
      decoration: InputDecoration(
        labelStyle: AppTheme.bodyText(greyTextColor),
        hintStyle: AppTheme.bodyText(greyTextColor),
        errorStyle: AppTheme.bodyText(Colors.red),
        hintText: widget.isRequired == true
            ? "${widget.hintText ?? ""}*"
            : widget.hintText ?? "",
        labelText: widget.labelText ?? "",
        floatingLabelBehavior: widget.float ?? FloatingLabelBehavior.auto,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: widget.borderColor ?? borderColor)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: widget.borderColor ?? borderColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: widget.borderColor ?? borderColor)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.red.shade900)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.red.shade900)),
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(widget.lengthLimit != null ? 10 : 500)
      ],
    );
  }
}
