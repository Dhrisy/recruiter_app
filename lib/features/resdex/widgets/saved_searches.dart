import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';
import 'package:recruiter_app/features/resdex/provider/search_seeker_provider.dart';
import 'package:recruiter_app/widgets/common_empty_list.dart';
import 'package:recruiter_app/widgets/common_error_widget.dart';
import 'package:recruiter_app/widgets/seeker_card.dart';
import 'package:recruiter_app/widgets/shimmer_list_loading.dart';

class SavedSearches extends StatefulWidget {
  const SavedSearches({Key? key}) : super(key: key);

  @override
  _SavedSearchesState createState() => _SavedSearchesState();
}

class _SavedSearchesState extends State<SavedSearches> {
  bool _isLoading = true;
  Future<List<SeekerModel>?>? _seekerLists;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchSeekerProvider>(context, listen: false)
          .fetchSavedCandidatesLists()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // spacing: 20,
      children: [
        Text(
          "View and manage the candidates you’ve saved for future reference. Easily access their profiles and keep track of potential prospects",
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: greyTextColor),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(),
          child: Consumer<SearchSeekerProvider>(
              builder: (context, provider, child) {
            if (_isLoading == true) {
              return ShimmerListLoading();
            }

            if (provider.bookMarkedLists == null) {
              return CommonErrorWidget();
            }
            if (provider.bookMarkedLists!.isEmpty) {
              return CommonEmptyList();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text("(Saved seekeres count :  ${provider.bookMarkedLists!.length} )",
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight:FontWeight.bold,
                            color: secondaryColor
                          ),),
                          const SizedBox(
                            height: 10,
                          ),
                Column(
                  // spacing: 10,
                  children:
                      List.generate(provider.bookMarkedLists!.length, (index) {
                    final seekerData = provider.bookMarkedLists![index];
                    final isBookmarked = provider.bookmarkedStates[
                            seekerData.personalData?.personal.id] ??
                        false;
                
                    return SeekerCard(
                        seekerData: seekerData,
                        isBookmarked: isBookmarked,
                        onBookmarkToggle: () {
                          provider.toggleBookmark(seekerData, context);
                        });
                  }),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
