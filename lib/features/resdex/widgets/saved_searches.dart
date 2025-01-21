import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/resdex/provider/search_seeker_provider.dart';
import 'package:recruiter_app/widgets/common_empty_list.dart';
import 'package:recruiter_app/widgets/seeker_card.dart';

class SavedSearches extends StatefulWidget {
  const SavedSearches({ Key? key }) : super(key: key);

  @override
  _SavedSearchesState createState() => _SavedSearchesState();
}

class _SavedSearchesState extends State<SavedSearches> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
Provider.of<SearchSeekerProvider>(context, listen: false).fetchSavedCandidatesLists();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
      ),
      child: Consumer<SearchSeekerProvider>(
        builder: (context, provider, child) {
          if(provider.bookmarkedSeekers.isEmpty){
            return CommonEmptyList(
              text: "No saved  seekers",
            );
          }

          return Column(
            children: List.generate(provider.bookmarkedSeekers.length, (index){
              final seekerData = provider.bookmarkedSeekers[index];
              return SeekerCard(seekerData: seekerData);
            }),
          );
        }
      ),
    );
  }
}