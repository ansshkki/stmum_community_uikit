import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/components/bottom_sheet.dart';
import 'package:amity_uikit_beta_service/view/user/user_profile_v2.dart';
import 'package:amity_uikit_beta_service/viewmodel/user_feed_viewmodel.dart';
import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/custom_user_avatar.dart';
import '../../viewmodel/follower_following_viewmodel.dart';

class AmityFollowingScreen extends StatefulWidget {
  final String userId;

  const AmityFollowingScreen({
    super.key,
    required this.userId,
  });

  @override
  State<AmityFollowingScreen> createState() =>
      _AmityFollowingScreenScreenState();
}

class _AmityFollowingScreenScreenState extends State<AmityFollowingScreen> {
  @override
  void initState() {
    Provider.of<FollowerVM>(context, listen: false)
        .getFollowingListof(userId: widget.userId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FollowerVM>(builder: (context, vm, _) {
      final theme = Theme.of(context);
      return FadedSlideAnimation(
        beginOffset: const Offset(0, 0.3),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
        child: RefreshIndicator(
          onRefresh: () async {
            await vm.getFollowingListof(userId: widget.userId);
          },
          child: ListView.builder(
            controller: vm.followingScrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: vm.getFollowingList.length,
            itemBuilder: (context, index) {
              return StreamBuilder<AmityFollowRelationship>(
                  // key: Key(vm.getFollowRelationships[index].targetUserId! +
                  //     vm.getFollowRelationships[index].targetUserId!),
                  stream: vm.getFollowingList[index].listen.stream,
                  initialData: vm.getFollowingList[index],
                  builder: (context, snapshot) {
                    return ListTile(
                      onTap: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                                create: (context) => UserFeedVM(),
                                child: UserProfileScreen(
                                  amityUser: snapshot.data!.targetUser,
                                  amityUserId: snapshot.data!.targetUserId!,
                                ))));
                      },
                      trailing: IconButton(
                          onPressed: () {
                            showOptionsBottomSheet(
                                context, snapshot.data!.targetUser!);
                            Provider.of<FollowerVM>(context, listen: false)
                                .getFollowingListof(userId: widget.userId);
                          },
                          icon: const Icon(Icons.more_horiz)),
                      title: Row(
                        children: [
                          GestureDetector(
                            child: getAvatarImage(vm
                                .getFollowingList[index].targetUser!.avatarUrl),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vm.getFollowingList[index].targetUser!
                                          .displayName ??
                                      "external.empty_name".tr(),
                                  //display name not found
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                    // return Text(snapshot.data!.status.toString());
                  });
            },
          ),
        ),
      );
    });
  }
}
