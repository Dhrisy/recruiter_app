import 'package:flutter/material.dart';
import 'package:recruiter_app/core/constants.dart';

class SearchCvFormWidget extends StatefulWidget {
  const SearchCvFormWidget({ Key? key }) : super(key: key);

  @override
  _SearchCvFormWidgetState createState() => _SearchCvFormWidgetState();
}

class _SearchCvFormWidgetState extends State<SearchCvFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      color: buttonColor,
    );
  }
}