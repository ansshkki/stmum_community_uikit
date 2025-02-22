import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/v4/core/theme.dart';
import 'package:amity_uikit_beta_service/v4/social/post/common/post_moderator_badge.dart';
import 'package:amity_uikit_beta_service/v4/utils/date_time_extension.dart';
import 'package:amity_uikit_beta_service/view/social/community_feed.dart';
import 'package:amity_uikit_beta_service/view/user/user_profile_v2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostDisplayName extends StatelessWidget {
  final AmityPost post;
  final AmityThemeColor theme;

  const PostDisplayName({
    super.key,
    required this.post,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    var isModerator = false;
    if (post.target is CommunityTarget) {
      var roles = (post.target as CommunityTarget).postedCommunityMember?.roles;
      if (roles != null &&
          (roles.contains("moderator") ||
              roles.contains("community-moderator"))) {
        isModerator = true;
      }
    }

    var timestampText = post.createdAt?.toSocialTimestamp() ?? "";
    if (post.editedAt != post.createdAt) {
      timestampText += " (edited)";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: (post.target != null &&
                    ((post.target is CommunityTarget) ||
                        (post.target is UserTarget &&
                            (post.target as UserTarget).targetUserId !=
                                post.postedUserId)))
                ? [
                    IntrinsicWidth(
                        child: DisplayName(context, post.postedUser)),
                    Expanded(child: PostTarget(context, post.target!)),
                  ]
                : [Expanded(child: DisplayName(context, post.postedUser))],
          ),
          Row(
            children: [
              if (isModerator) const CommunityModeratorBadge(),
              if (isModerator)
                Container(
                    padding: const EdgeInsetsDirectional.only(start: 2),
                    child: Text(
                      "• ",
                      style: TextStyle(
                        color: theme.baseColorShade2,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
              Container(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  timestampText,
                  style: TextStyle(
                    color: theme.baseColorShade2,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget DisplayName(BuildContext context, AmityUser? user) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(
              amityUserId: user?.userId ?? '',
              amityUser: null,
            ),
          ),
        );
      },
      child: Text(
        user?.displayName ?? "post.unknown_name".tr(),
        style: TextStyle(
          color: theme.baseColor,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget PostTarget(BuildContext context, AmityPostTarget target) {
    Future<dynamic> targetNavigation;

    VoidCallback? onTap;
    var targetName = '';
    if (target is CommunityTarget && target.targetCommunity != null) {
      targetName =
          (post.target as CommunityTarget).targetCommunity?.displayName ??
              "post.unknown_name".tr();

      onTap = () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                CommunityScreen(community: target.targetCommunity!),
          ),
        );
      };
    } else if (target is UserTarget) {
      if (post.postedUserId != target.targetUserId) {
        if (post.postedUserId != target.targetUserId) {
          targetName = (post.target as UserTarget).targetUser?.displayName ??
              "post.unknown_name".tr();
        }
        onTap = () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserProfileScreen(
                amityUserId: target.targetUser?.userId ?? '',
                amityUser: null,
              ),
            ),
          );
        };
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 4),
          targetArrow(),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              targetName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                color: theme.baseColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget targetArrow() {
    return Container(
      width: 16,
      height: 16,
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: SvgPicture.asset(
        'assets/Icons/amity_ic_post_target_arrow.svg',
        package: 'amity_uikit_beta_service',
        width: 16,
        height: 12,
      ),
    );
  }
}
