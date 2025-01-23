import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';
import 'package:recruiter_app/features/resdex/provider/search_seeker_provider.dart';
import 'package:recruiter_app/widgets/common_empty_list.dart';
import 'package:recruiter_app/widgets/common_error_widget.dart';
import 'package:recruiter_app/widgets/seeker_card.dart';
import 'package:recruiter_app/widgets/shimmer_list_loading.dart';

class CandidateInvited extends StatefulWidget {
  
  const CandidateInvited({ Key? key }) : super(key: key);

  @override
  _CandidateInvitedState createState() => _CandidateInvitedState();
}

class _CandidateInvitedState extends State<CandidateInvited> {


  bool _isLoading = true;
  Future<List<SeekerModel>?>? _seekerLists;



  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchSeekerProvider>(context, listen: false)
          .fetchInvitedCandidates().then((_){
            setState(() {
              _isLoading = false;
_seekerLists = Provider.of<SearchSeekerProvider>(context, listen: false).lists;
            });
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Text("Manage and track the candidates you’ve invited. Review their details, status, and take necessary actions to move forward",
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: greyTextColor
        ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(),
          child:
              Consumer<SearchSeekerProvider>(builder: (context, provider, child) {
            if(_isLoading == true){
              return ShimmerListLoading();
            }

            
        
            return FutureBuilder<List<SeekerModel>?>(
              future: _seekerLists,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return ShimmerListLoading();
                }

                if(snapshot.hasError || snapshot.data == null){
                  return CommonErrorWidget();
                }

                if(snapshot.hasData && snapshot.data!.isEmpty){
                  return CommonEmptyList();
                }

                return Column(
                  spacing: 10,
                  children:
                      List.generate(snapshot.data!.length, (index) {
                    final seekerData = snapshot.data![index];
                    final isBookmarked = provider.bookmarkedStates[
                            seekerData.personalData?.personal.id.toString()] ??
                        false;
                    return SeekerCard(
                        seekerData: seekerData,
                        isBookmarked: isBookmarked,
                        onBookmarkToggle: () {
                          provider.toggleBookmark(seekerData);
                        });
                  }),
                );
              }
            );
          }),
        ),
      ],
    );
  }
}
