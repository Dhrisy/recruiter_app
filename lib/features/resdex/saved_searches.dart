import 'package:flutter/material.dart';
import 'package:recruiter_app/core/constants.dart';

class SavedSearches extends StatefulWidget {
  const SavedSearches({ Key? key }) : super(key: key);

  @override
  _SavedSearchesState createState() => _SavedSearchesState();
}

class _SavedSearchesState extends State<SavedSearches> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: buttonColor
      ),
      child: Column(
        children: List.generate(10, (index){
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
              height: 100,
              width: double.infinity,
              color: secondaryColor,
            ),
          );
        }),
      ),
    );
  }
}