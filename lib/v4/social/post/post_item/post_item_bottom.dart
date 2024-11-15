import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/v4/core/base_component.dart';
import 'package:amity_uikit_beta_service/v4/social/post/common/post_action.dart';
import 'package:amity_uikit_beta_service/v4/social/post/common/post_reaction_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostItemBottom extends NewBaseComponent {
  final AmityPost post;
  final AmityPostAction action;
  final bool isReacting;
  final bool hideReactionCount;
  final bool isOptimisticUi;

  PostItemBottom({
    super.key,
    required this.post,
    required this.action,
    this.isReacting = false,
    this.hideReactionCount = false,
    super.pageId,
    required super.componentId,
    required this.isOptimisticUi,
  });

  @override
  Widget buildComponent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            height: 1,
            color: theme.baseColorShade4,
          ),
        ),
        Container(
            width: double.infinity,
            padding: const EdgeInsetsDirectional.only(
                start: 16, top: 0, end: 16, bottom: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PostReactionButton(
                  post: post,
                  action: action,
                  isReacting: isReacting,
                  showLabel: hideReactionCount,
                  isOptimisticUi: isOptimisticUi,
                ),
                const SizedBox(width: 12),
                getCommentButton(context, hideReactionCount),
              ],
            ))
      ],
    );
  }

  Widget getCommentButton(BuildContext context, bool hideCommentCount) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/Icons/amity_ic_post_comment.svg',
          package: 'amity_uikit_beta_service',
          width: 20,
          height: 17,
        ),
        const SizedBox(width: 4),
        Text(
          hideCommentCount
              ? "comment.comment".tr()
              : "community.comment".plural(
                  post.commentCount!.toInt(),
                  format:
                      NumberFormat.compact(locale: context.locale.toString()),
                ),
          style: TextStyle(
            color: theme.baseColorShade2,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget getShareButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/Icons/amity_ic_post_share.svg',
          package: 'amity_uikit_beta_service',
          width: 20,
          height: 18,
        ),
        const SizedBox(width: 4),
        Text(
          "external.share".tr(),
          style: TextStyle(
            color: theme.baseColorShade2,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
