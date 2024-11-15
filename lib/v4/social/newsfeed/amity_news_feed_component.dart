import 'package:amity_uikit_beta_service/v4/core/base_component.dart';
import 'package:amity_uikit_beta_service/v4/social/globalfeed/amity_global_feed_component.dart';
import 'package:flutter/widgets.dart';

class AmityNewsFeedComponent extends NewBaseComponent {
  AmityNewsFeedComponent({super.key, super.pageId})
      : super(componentId: 'news_feed_component');

  @override
  Widget buildComponent(BuildContext context) {
    return AmityGlobalFeedComponent(pageId: pageId);
  }
}
