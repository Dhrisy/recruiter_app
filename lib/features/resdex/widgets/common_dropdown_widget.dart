import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';

class CommonDropdownWidget extends StatefulWidget {
      final String selectedVariable;
      final List<String> list;
      final String hintText;
      final String labelText;
      final Function(String?)? onChanged;
  const CommonDropdownWidget({ Key? key ,
  required this.hintText,
  required this.labelText,
  required this.list,
  required this.onChanged,
  required this.selectedVariable,
  }) : super(key: key);

  @override
  _CommonDropdownWidgetState createState() => _CommonDropdownWidgetState();
}

class _CommonDropdownWidgetState extends State<CommonDropdownWidget> {
  @override
  Widget build(BuildContext context) {
      return Container(
      constraints: BoxConstraints(
        maxHeight: 55.h,
      ),
      child: DropdownSearch<String>(
        validator: (_) {
          if (widget.selectedVariable == '') {
            return "This field is required";
          }
          return null;
        },
        decoratorProps: DropDownDecoratorProps(
          expands: false,
          baseStyle: AppTheme.bodyText(lightTextColor),
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor),
            ),
          ),
        ),
        items: (filter, infiniteScrollProps) => widget.list,
        selectedItem: widget.selectedVariable.isEmpty ? null : widget.selectedVariable,
        onChanged: widget.onChanged,
        popupProps: PopupProps.menu(
          showSearchBox: true,
          
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTheme.bodyText(greyTextColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: borderColor),
              ),
            ),
          ),
        ),
      ),
    );
  
  }



}