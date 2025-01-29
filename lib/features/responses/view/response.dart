import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/resdex/model/job_response_model.dart';
import 'package:recruiter_app/features/resdex/provider/search_seeker_provider.dart';
import 'package:recruiter_app/features/responses/provider/seeker_provider.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';
import 'package:recruiter_app/widgets/common_empty_list.dart';
import 'package:recruiter_app/widgets/common_error_widget.dart';
import 'package:recruiter_app/widgets/common_search_widget.dart';
import 'package:recruiter_app/widgets/seeker_card.dart';
import 'package:recruiter_app/widgets/shimmer_list_loading.dart';

class Response extends StatefulWidget {
  const Response({Key? key}) : super(key: key);

  @override
  _ResponseState createState() => _ResponseState();
}

class _ResponseState extends State<Response>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final ScrollController _scrollController = ScrollController();
  final List<double> _itemVisibility = List.filled(30, 1.0);
  late Animation<Offset> _animation;
  late Animation<Offset> _searchBarAnimation;
  late Animation<Offset> _listsAnimation;
  late Animation<Offset> _listItemAnimation;
  bool _isLoading = true;
  Future<List<JobResponseModel>?>? _seekerLists;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SeekerProvider>(context, listen: false)
          .fetchAllAppliedSeekers()
          .then((_) {
        if(mounted){
          setState(() {
          _isLoading = false;
          _seekerLists =
              Provider.of<SeekerProvider>(context, listen: false).seekerLists;
        });
        }
      });
    });

    _animation = Tween<Offset>(begin: const Offset(-0.1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _searchBarAnimation = Tween<Offset>(
            begin: const Offset(-0.1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _listItemAnimation = Tween<Offset>(
            begin: const Offset(-0.1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _listsAnimation = Tween<Offset>(
            begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateItemVisibility(ScrollNotification notification) {
    final viewportHeight = notification.metrics.viewportDimension;
    final offset = notification.metrics.pixels;

    setState(() {
      for (int i = 0; i < _itemVisibility.length; i++) {
        final itemPosition = (144.0 * i) - offset; // 128 + 16 margin
        final visibilityRatio = _calculateVisibilityRatio(
          itemPosition,
          viewportHeight,
        );
        _itemVisibility[i] = visibilityRatio;
      }
    });
  }

  double _calculateVisibilityRatio(double itemPosition, double viewportHeight) {
    const itemHeight = 18.0; // 128 + 16 margin

    // If item is completely outside viewport
    if (itemPosition + itemHeight < 0 || itemPosition > viewportHeight) {
      return 0.0;
    }

    // If item is completely inside viewport
    if (itemPosition >= 0 && itemPosition + itemHeight <= viewportHeight) {
      return 1.0;
    }

    // If item is partially visible
    final visibleHeight = itemPosition < 0
        ? itemHeight + itemPosition
        : viewportHeight - itemPosition;

    return (visibleHeight / itemHeight).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height.h;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: screenHeight * 0.45,
            child: SvgPicture.asset(
              "assets/svgs/onboard_1.svg",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SlideTransition(
                      position: _animation,
                      child: CommonAppbarWidget(
                        title: "Responses",
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        SlideTransition(
                            position: _searchBarAnimation,
                            child: Consumer<SeekerProvider>(
                                builder: (context, provider, child) {
                              return CommonSearchWidget(
                                onChanged: (query) {
                                  provider.setSearchQuery(query);
                                },
                              );
                            })),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Shows the list of candidates who have responded to or applied for the jobs you have posted. You can view their application details",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: greyTextColor),
                        ),
                        const SizedBox(height: 15),
                        
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: NotificationListener<ScrollNotification>(
                              onNotification: (notification) {
                            _updateItemVisibility(notification);
                            return true;
                          }, child: Consumer<SeekerProvider>(
                                  builder: (context, provider, child) {
                            if (provider.isLoading) {
                              return ShimmerListLoading();
                            }

                            final filteredSeekers = provider.filteredSeekers;

                            if (filteredSeekers.isEmpty) {
                              return CommonEmptyList();
                            }
                            return ListView.builder(
                              controller: _scrollController,
                              itemCount: filteredSeekers.length,
                              itemBuilder: (context, index) {
                                final visibility = _itemVisibility[index];
                                final scale = 0.85 + (0.15 * visibility);
                                final opacity = 0.6 + (0.4 * visibility);

                                final seekerData = filteredSeekers[index];

                                return AnimatedScale(
                                  scale: scale,
                                  duration: const Duration(milliseconds: 200),
                                  child: AnimatedOpacity(
                                    opacity: opacity,
                                    duration: const Duration(milliseconds: 200),
                                    child: Consumer<SearchSeekerProvider>(
                                        builder: (context, provider, child) {
                                      final isBookmarked =
                                          provider.bookmarkedStates[seekerData
                                                  .seeker
                                                  .personalData
                                                  ?.personal
                                                  .id] ??
                                              false;
                                      return SeekerCard(
                                        jobData: seekerData.job,
                                        seekerData: seekerData.seeker,
                                        isBookmarked: isBookmarked,
                                        fromResponse: true,
                                        onBookmarkToggle: () {
                                          provider.toggleBookmark(
                                              seekerData.seeker, context);
                                        },
                                      );
                                    }),
                                  ),
                                );
                              },
                            );
                          })



                              // FutureBuilder<List<JobResponseModel>?>(
                              //     future: _seekerLists,
                              //     builder: (context, snapshot) {
                              //       if (snapshot.connectionState ==
                              //           ConnectionState.waiting) {
                              //         return ShimmerListLoading();
                              //       }

                              //       if (snapshot.hasError ||
                              //           snapshot.data == null) {
                              //         return CommonErrorWidget();
                              //       }

                              //       if (snapshot.hasData &&
                              //           snapshot.data!.isEmpty) {
                              //         return CommonEmptyList();
                              //       }

                              //       return ListView.builder(
                              //         controller: _scrollController,
                              //         itemCount: snapshot.data!.length,
                              //         itemBuilder: (context, index) {
                              //           final visibility = _itemVisibility[index];
                              //           final scale = 0.85 + (0.15 * visibility);
                              //           final opacity = 0.6 + (0.4 * visibility);

                              //           final seekerData = snapshot.data![index];

                              //           return AnimatedScale(
                              //             scale: scale,
                              //             duration:
                              //                 const Duration(milliseconds: 200),
                              //             child: AnimatedOpacity(
                              //               opacity: opacity,
                              //               duration:
                              //                   const Duration(milliseconds: 200),
                              //               child: Consumer<SearchSeekerProvider>(
                              //                   builder:
                              //                       (context, provider, child) {
                              //                 final isBookmarked =
                              //                     provider.bookmarkedStates[
                              //                             seekerData
                              //                                 .seeker
                              //                                 .personalData
                              //                                 ?.personal
                              //                                 .id] ??
                              //                         false;
                              //                 return SeekerCard(

                              //                   jobData: seekerData.job,
                              //                   seekerData: seekerData.seeker,
                              //                   isBookmarked: isBookmarked,
                              //                   fromResponse: true,
                              //                   onBookmarkToggle: () {
                              //                     provider.toggleBookmark(
                              //                         seekerData.seeker, context);
                              //                   },
                              //                 );
                              //               }),
                              //             ),
                              //           );
                              //         },
                              // );

                              // }
                              // ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sizeIt(BuildContext context, int index) {
    return SizedBox(
      height: 128.0,
      child: Card(
        color: Colors.red,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: Text(
            'Item $index',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
