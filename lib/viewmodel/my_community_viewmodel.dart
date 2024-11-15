import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class MyCommunityVM with ChangeNotifier {
  // Existing members...

  final scrollController = ScrollController();
  bool loadingNextPage = false;
  bool isEmpty = false;

  // The list of communities.
  final List<AmityCommunity> _amityCommunities = [];
  final List<AmityCommunity> _amityCommunitiesForFeed = [];

  // The controller for handling pagination.
  // late PagingController<AmityCommunity> _communityController;
  late CommunityLiveCollection communityLiveCollection;
  late CommunityLiveCollection communityFeedLiveCollection;

  // Getter for _amityCommunities for external classes to use.
  List<AmityCommunity> get amityCommunities => _amityCommunities;

  List<AmityCommunity> get amityCommunitiesForFeed => _amityCommunitiesForFeed;
  final textEditingController = TextEditingController();

  Future<void> initMyCommunity([String? keyword]) async {
    final repository = AmitySocialClient.newCommunityRepository()
        .getCommunities()
        .filter(AmityCommunityFilter.MEMBER)
        .includeDeleted(false);
    if (keyword != null && keyword.isNotEmpty) {
      repository.withKeyword(
          keyword); // Add keyword filtering only if keyword is provided and not empty
    }
    communityLiveCollection = repository.getLiveCollection(pageSize: 50);
    communityLiveCollection.getStreamController().stream.listen((event) {
      _amityCommunities.clear();
      _amityCommunities.addAll(event);

      isEmpty = _amityCommunities.isEmpty;

      notifyListeners();
    }).onError((error, stackTrace) {
      log("error:${error.error.toString()}");
      // await AmityDialog().showAlertErrorDialog(
      //     title: "Error!",
      //     message: _communityController.error.toString());
    });
    communityLiveCollection.loadNext();
    scrollController.removeListener(() {});
    scrollController.addListener(loadNextPage);
  }

  Future<void> initMyCommunityFeed() async {
    final repository = AmitySocialClient.newCommunityRepository()
        .getCommunities()
        .filter(AmityCommunityFilter.MEMBER)
        .sortBy(AmityCommunitySortOption.DISPLAY_NAME)
        .includeDeleted(false);

    communityFeedLiveCollection = repository.getLiveCollection(pageSize: 50);
    communityFeedLiveCollection.getStreamController().stream.listen((event) {
      _amityCommunitiesForFeed.clear();
      _amityCommunitiesForFeed.addAll(event);

      notifyListeners();
    }).onError((error, stackTrace) {
      // log("error:${error.error.toString()}");
      // await AmityDialog().showAlertErrorDialog(
      //     title: "Error!",
      //     message: _communityController.error.toString());
    });
    communityFeedLiveCollection.loadNext();
  }

  void loadNextPage() async {
    if ((scrollController.position.pixels >
        scrollController.position.maxScrollExtent - 800)) {
      print("hasMore: ${communityLiveCollection.hasNextPage()}");
    }
    if ((scrollController.position.pixels >
            scrollController.position.maxScrollExtent - 800) &&
        communityLiveCollection.hasNextPage() &&
        !loadingNextPage) {
      loadingNextPage = true;
      notifyListeners();
      log("loading Next Page...");

      await communityLiveCollection.loadNext().then((value) {
        loadingNextPage = false;
        notifyListeners();
      });
    }
  }
}

class SearchCommunityVM with ChangeNotifier {
  // Existing members...
  bool isDone = true;

  final scrollcontroller = ScrollController();
  bool loadingNextPage = false;

  // The list of communities.
  final List<AmityCommunity> _amityCommunities = [];

  // Getter for _amityCommunities for external classes to use.
  List<AmityCommunity> get amityCommunities => _amityCommunities;
  final textEditingController = TextEditingController();

  // The controller for handling pagination.
  late PagingController<AmityCommunity> communityController;

  void clearSearch() {
    amityCommunities.clear();
  }

  Future<void> initSearchCommunity([String? keyword]) async {
    isDone = false;
    notifyListeners();
    communityController = PagingController(
      pageFuture: (token) {
        final repository = AmitySocialClient.newCommunityRepository()
            .getCommunities()
            .sortBy(AmityCommunitySortOption.DISPLAY_NAME)
            .filter(AmityCommunityFilter.ALL)
            .includeDeleted(false);
        if (keyword != null && keyword.isNotEmpty) {
          repository.withKeyword(
              keyword); // Add keyword filtering only if keyword is provided and not empty
        }
        return repository.getPagingData(token: token, limit: 20);
      },
      pageSize: 20,
    )..addListener(
        () async {
          if (communityController.error == null) {
            amityCommunities.clear();
            amityCommunities.addAll(communityController.loadedItems);
            // Call any additional methods like sortedUserListWithHeaders here if needed.
          } else {
            log("error: ${communityController.error.toString()}");
            // await AmityDialog().showAlertErrorDialog(
            //     title: "Error!", message: communityController.error.toString());
          }
          isDone = true;
          notifyListeners();
        },
      );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      communityController.fetchNextPage();
    });

    scrollcontroller.removeListener(() {});
    scrollcontroller.addListener(loadNextPage);
  }

  void loadNextPage() async {
    if ((scrollcontroller.position.pixels >
        scrollcontroller.position.maxScrollExtent - 800)) {
      print("hasMore: ${communityController.hasMoreItems}");
    }
    if ((scrollcontroller.position.pixels >
            scrollcontroller.position.maxScrollExtent - 800) &&
        communityController.hasMoreItems &&
        !loadingNextPage) {
      loadingNextPage = true;
      notifyListeners();
      log("loading Next Page...");
      // Call any additional methods like sortedUserListWithHeaders here if needed.
      await communityController.fetchNextPage().then((value) {
        loadingNextPage = false;
        notifyListeners();
      });
    }
  }
}
