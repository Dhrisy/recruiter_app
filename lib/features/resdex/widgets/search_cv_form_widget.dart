import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/resdex/provider/search_seeker_provider.dart';
import 'package:recruiter_app/widgets/common_empty_list.dart';
import 'package:recruiter_app/widgets/seeker_card.dart';
import 'package:recruiter_app/widgets/shimmer_list_loading.dart';

class SearchCvFormWidget extends StatefulWidget {
  const SearchCvFormWidget({Key? key}) : super(key: key);

  @override
  _SearchCvFormWidgetState createState() => _SearchCvFormWidgetState();
}

class _SearchCvFormWidgetState extends State<SearchCvFormWidget> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchSeekerProvider>(context, listen: false)
          .fetchAllSeekersLists();
          
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child:
          Consumer<SearchSeekerProvider>(builder: (context, provider, child) {
        return Column(
          children: [

            provider.isLoading 
            ? ShimmerListLoading()
            : SizedBox.shrink(),
            Column(
              children: List.generate(provider.seekersLists.length, (index) {
                final seekerData = provider.seekersLists[index];
                return SeekerCard(seekerData: seekerData,);
              }),
            ),
          ],
        );
      }),
    );
  }
}
