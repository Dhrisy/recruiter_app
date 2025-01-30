import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recruiter_app/core/constants.dart';

class CommonSearchWidget extends StatefulWidget {
  final void Function(String)? onChanged;
  final TextEditingController controller;
  const CommonSearchWidget({Key? key, required this.onChanged, required this.controller}) : super(key: key);

  @override
  _CommonSearchWidgetState createState() => _CommonSearchWidgetState();
}

class _CommonSearchWidgetState extends State<CommonSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40.h,
      decoration: BoxDecoration(
        color: lightContainerColor,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 8.r,
            color: borderColor,
            offset: const Offset(1, 1)
          )
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: "Search",
            
            hintStyle: GoogleFonts.wixMadeforDisplay(),
            filled: true,
            fillColor: lightContainerColor,
            suffixIcon: const Icon(CupertinoIcons.search),
            border: InputBorder.none,  
            
          ),
        ),
      ),
    );
  }
}
