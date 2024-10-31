import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/community_viewmodel.dart';
import '../../viewmodel/configuration_viewmodel.dart';
import 'community_list.dart';

class CommunityTabBar extends StatelessWidget {
  const CommunityTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: TabBar(
          tabAlignment: TabAlignment.start,
          physics: const BouncingScrollPhysics(),
          isScrollable: true,
          indicatorColor:
              Provider.of<AmityUIConfiguration>(context).primaryColor,
          labelColor: Provider.of<AmityUIConfiguration>(context).primaryColor,
          unselectedLabelColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(text: "community.recommended".tr()), //Recommended
            Tab(text: "community.trending".tr()), //Trending
            Tab(text: "community.join".tr()), //Joined
          ],
        ),
        body: const TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            CommunityList(CommunityListType.recommend),
            CommunityList(CommunityListType.trending),
            CommunityList(CommunityListType.my),
          ],
        ),
      ),
    );
  }
}
