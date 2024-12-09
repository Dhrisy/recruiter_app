import 'package:flutter/material.dart';
import 'package:recruiter_app/core/constants.dart';

class ReusableTextfield extends StatefulWidget {
  final String? labelText;
  final TextEditingController controller;
  final String? Function(String?)? validation;
  final TextInputType? keyBoardType;
  final bool? isRequired;
  const ReusableTextfield(
      {Key? key,
      this.labelText,
      required this.controller,
      this.keyBoardType,
      this.validation,
      this.isRequired})
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
      decoration: InputDecoration(
          hintText: widget.isRequired == true
              ? "${widget.labelText ?? ""}*"
              : widget.labelText ?? "",
          labelText: widget.labelText ?? "",
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: borderColor
        )
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius)
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius)
      ),
      ),
    );
  }
}
