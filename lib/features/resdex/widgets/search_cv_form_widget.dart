import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';
import 'package:recruiter_app/features/resdex/provider/search_seeker_provider.dart';
import 'package:recruiter_app/widgets/common_empty_list.dart';
import 'package:recruiter_app/widgets/common_error_widget.dart';
import 'package:recruiter_app/widgets/common_nodatafound_widget.dart';
import 'package:recruiter_app/widgets/common_search_widget.dart';
import 'package:recruiter_app/widgets/seeker_card.dart';
import 'package:recruiter_app/widgets/shimmer_list_loading.dart';

class SearchCvFormWidget extends StatefulWidget {
  const SearchCvFormWidget({Key? key}) : super(key: key);

  @override
  _SearchCvFormWidgetState createState() => _SearchCvFormWidgetState();
}

class _SearchCvFormWidgetState extends State<SearchCvFormWidget> {
  Future<List<SeekerModel>?>? _seekerLists;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<SearchSeekerProvider>(context, listen: false)
          .initializeBookmarkedStates();
      Provider.of<SearchSeekerProvider>(context, listen: false)
          .fetchAllSeekersLists()
          .then((_) async {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _seekerLists =
                Provider.of<SearchSeekerProvider>(context, listen: false).lists;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchSeekerProvider>(builder: (context, provider, child) {
      return SizedBox(
        width: double.infinity,
        child: Column(
          // spacing: 15,
          children: [
            Text(
              "Browse through the list of candidates and manage their details efficiently. Use filters to narrow down your search and find the right candidate quickly.",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: greyTextColor),
            ),
            // provider.searchResultEmpty == false
            // ?  CommonSearchWidget(onChanged: (_){
            //   provider.searchSeeker(keyWords: [],
            //   );
            // })
            // : const SizedBox.shrink(),
            Column(
              children: [
                // if (_isLoading) ShimmerListLoading(),
                FutureBuilder<List<SeekerModel>?>(
                    future: provider.lists,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ShimmerListLoading();
                      } else if (snapshot.hasError || snapshot.data == null) {
                        return CommonErrorWidget();
                      } else if (provider.searchResultEmpty == true &&
                          snapshot.data!.isEmpty) {
                        return CommonNodatafoundWidget();
                      } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                        return CommonEmptyList();
                      } else {
                        return Column(
                          // spacing: 10,
                          children:
                              List.generate(snapshot.data!.length, (index) {
                            final seekerData = snapshot.data![index];
                            final borderColor =
                                index.isEven ? buttonColor : secondaryColor;
                            final isBookmarked = provider.bookmarkedStates[
                                    seekerData.personalData?.personal.id] ??
                                false;

                            return SeekerCard(
                              isBookmarked: isBookmarked,
                              seekerData: seekerData,
                              borderColor: borderColor,
                              onBookmarkToggle: () {
                                provider.toggleBookmark(seekerData, context);
                              },
                            );
                          }),
                        );
                      }
                    }),
              ],
            ),
          ],
        ),
      );
    });
  }
}
