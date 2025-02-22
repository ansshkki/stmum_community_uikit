import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

enum CategoryListState { loading, success, error }

class ExplorePageVM with ChangeNotifier {
  List<AmityCommunityCategory> amityCategories = [];
  List<AmityCommunity> _recommendedCommunities = [];
  List<AmityCommunity> _trendingCommunities = [];

  List<AmityCommunity> get recommendedCommunities => _recommendedCommunities;

  List<AmityCommunity> get trendingCommunities => _trendingCommunities;

  // final amityCategories = <AmityCommunityCategory>[];
  late PagingController<AmityCommunityCategory> _communityCategoryController;
  final categoryScrollController = ScrollController();

  CategoryListState _categoryState = CategoryListState.loading; // Default state
  CategoryListState get categoryState => _categoryState; // Getter for the state

  void getRecommendedCommunities() async {
    print("getRecommendedCommunities...");
    await AmitySocialClient.newCommunityRepository()
        .getRecommendedCommunities()
        .then((List<AmityCommunity> communities) {
      _recommendedCommunities = communities.take(5).toList();
      print(_recommendedCommunities);
      notifyListeners();
    }).onError((error, stackTrace) {
      // handle error
    });
  }

  void getTrendingCommunities() {
    print("getTrendingCommunities...");
    AmitySocialClient.newCommunityRepository()
        .getTrendingCommunities()
        .then((List<AmityCommunity> communities) => {
              _trendingCommunities = communities.take(5).toList(),
              notifyListeners(),
            })
        .onError((error, stackTrace) => {
              // handle error
            });
  }

  final amityCommunities = <AmityCommunity>[];
  late PagingController<AmityCommunity> _communityController;
  final communityScrollController = ScrollController();

  void getCommunitiesInCategory(
      {required String categoryId, bool enableNotifyListener = false}) {
    _communityController = PagingController(
      pageFuture: (token) => AmitySocialClient.newCommunityRepository()
          .getCommunities()
          .filter(AmityCommunityFilter.ALL)
          .sortBy(AmityCommunitySortOption.DISPLAY_NAME)
          .includeDeleted(false)
          .categoryId(
              categoryId) //optional filter communities based on community categories
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_communityController.error == null) {
            //handle results, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            amityCommunities.clear();
            amityCommunities.addAll(_communityController.loadedItems);
            //update widgets
            if (enableNotifyListener) {
              notifyListeners();
            }
          } else {
            //error on pagination controller
            //update widgets
          }
        },
      );

    _communityController.fetchNextPage();

    communityScrollController.addListener(communityPagination);
  }

  void communityPagination() {
    if ((communityScrollController.position.pixels >=
        (communityScrollController.position.maxScrollExtent - 100))) {
      if (isLoadingFinish && _communityController.hasMoreItems) {
        print("load more");
        _communityController.fetchNextPage();
        isLoadingFinish = false;
        notifyListeners();
      }
    }
  }

  void queryCommunityCategories(
      {required AmityCommunityCategorySortOption sortOption,
      bool enableNotifyListener = false}) async {
    try {
      print("queryCommunityCategories");
      _categoryState = CategoryListState.loading; // Set loading state

      if (enableNotifyListener) {
        notifyListeners();
      }

      _communityCategoryController = PagingController(
        pageFuture: (token) => AmitySocialClient.newCommunityRepository()
            .getCategories()
            .sortBy(sortOption)
            .includeDeleted(false)
            .getPagingData(token: token, limit: 20),
        pageSize: 20,
      )..addListener(
          () {
            if (_communityCategoryController.error == null) {
              //handle results, we suggest to clear the previous items
              //and add with the latest _controller.
              amityCategories.clear();
              amityCategories.addAll(_communityCategoryController.loadedItems);
              if (amityCategories.isNotEmpty) {
                _categoryState = CategoryListState.success; // Success state
              }
              if (enableNotifyListener) {
                notifyListeners();
              }
              isLoadingFinish = true;
              //update widgets
            } else {
              _categoryState = CategoryListState.error; // Error state
              notifyListeners();
              //error on pagination controller
              //update widgets
            }
          },
        );

      // fetch the data for the first page
      _communityCategoryController.fetchNextPage();

      categoryScrollController.addListener(categoryPagination);
    } catch (e) {
      _categoryState = CategoryListState.error; // Error state
    }
  }

  var isLoadingFinish = true;

  void categoryPagination() {
    if ((categoryScrollController.position.pixels >=
        (categoryScrollController.position.maxScrollExtent - 100))) {
      if (isLoadingFinish && _communityCategoryController.hasMoreItems) {
        print("load more");
        _communityCategoryController.fetchNextPage();
        isLoadingFinish = false;
        notifyListeners();
      }
    }
  }
}
