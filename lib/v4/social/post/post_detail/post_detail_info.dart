import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/components/alert_dialog.dart';
import 'package:amity_uikit_beta_service/v4/core/base_component.dart';
import 'package:amity_uikit_beta_service/v4/social/reaction/reaction_list.dart';
import 'package:amity_uikit_beta_service/v4/utils/compact_string_converter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostDetailInfo extends NewBaseComponent {
  final AmityPost post;

  PostDetailInfo({
    super.key,
    required this.post,
    required super.componentId,
  });

  @override
  Widget buildComponent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          getReactionPreview(post, context),
          Expanded(child: Container()),
          getCommentCount(context, post),
        ],
      ),
    );
  }

  Widget getReactionPreview(AmityPost post, BuildContext context) {
    void showReactionsBottomSheet() {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        isScrollControlled: true,
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            minChildSize: 0.25,
            maxChildSize: 0.75,
            builder: (BuildContext context, scrollController) {
              return Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: AmityReactionListComponent(
                  pageId: 'post_detail_page',
                  referenceId: post.postId ?? "",
                  referenceType: AmityReactionReferenceType.POST,
                ),
              );
            },
          );
        },
      );
    }

    return GestureDetector(
      onTap: () => showReactionsBottomSheet(),
      child: Row(
        children: [
          getReactionIcon(post),
          const SizedBox(width: 4),
          getReactionCount(context, post),
        ],
      ),
    );
  }

  Widget getReactionIcon(AmityPost post) {
    if (post.myReactions?.isNotEmpty ?? false) {
      return post.myReactions!.first == 'like'
          ? SvgPicture.asset(
              'assets/Icons/amity_ic_post_reaction_like.svg',
              package: 'amity_uikit_beta_service',
              width: 20,
              height: 20,
            )
          : SvgPicture.asset(
              'assets/Icons/amity_ic_post_reaction_like.svg',
              package: 'amity_uikit_beta_service',
              width: 20,
              height: 20,
            );
    } else {
      return Container();
    }
  }

  Widget getReactionCount(BuildContext context, AmityPost post) {
    final reactionCount = post.reactionCount ?? 0;

    return Text(
      "community.like".plural(
        args: ["${reactionCount.toInt()}"],
        reactionCount,
        format: NumberFormat.compact(locale: context.locale.toString()),
      ),
      style: TextStyle(
        color: theme.baseColorShade2,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget getCommentCount(BuildContext context, AmityPost post) {
    final commentCount = post.commentCount ?? 0;
    return Text(
      "community.comment".plural(
        args: ["${commentCount.toInt()}"],
        commentCount,
        format: NumberFormat.compact(locale: context.locale.toString()),
      ),
      style: TextStyle(
        color: theme.baseColorShade2,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
