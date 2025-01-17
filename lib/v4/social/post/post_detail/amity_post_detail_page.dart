import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/v4/core/base_page.dart';
import 'package:amity_uikit_beta_service/v4/social/comment/comment_creator/comment_creator.dart';
import 'package:amity_uikit_beta_service/v4/social/comment/comment_creator/comment_creator_action.dart';
import 'package:amity_uikit_beta_service/v4/social/comment/comment_item/comment_action.dart';
import 'package:amity_uikit_beta_service/v4/social/comment/comment_list/comment_list_component.dart';
import 'package:amity_uikit_beta_service/v4/social/post/amity_post_content_component.dart';
import 'package:amity_uikit_beta_service/v4/social/post/common/post_action.dart';
import 'package:amity_uikit_beta_service/v4/social/post/post_detail/bloc/post_detail_bloc.dart';
import 'package:amity_uikit_beta_service/v4/social/post/post_item/bloc/post_item_bloc.dart';
import 'package:amity_uikit_beta_service/v4/utils/Shimmer.dart';
import 'package:amity_uikit_beta_service/v4/utils/skeleton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmityPostDetailPage extends NewBasePage {
  final String postId;
  final AmityPost? post;
  final AmityPostAction? action;

  AmityPostDetailPage({
    super.key,
    required this.postId,
    this.post,
    this.action,
  }) : super(pageId: 'post_detail_page');

  @override
  Widget buildPage(BuildContext context) {
    return BlocProvider(
      create: (context) => PostDetailBloc(postId: postId, post: post),
      child: BlocBuilder<PostDetailBloc, PostDetailState>(
          builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: buildPostDetail(context, state),
        );
      }),
    );
  }

  Widget buildPostDetail(BuildContext context, PostDetailState state) {
    if (state is PostDetailStateInitial) {
      context.read<PostDetailBloc>().add(
          PostDetailLoad(postId: (state).postId));
      return Container(
          padding: const EdgeInsets.only(top: 74),
          decoration: BoxDecoration(color: theme.backgroundColor),
          child: showShimmerContent());
    } else if (state is PostDetailStateError) {
      return Text(state.message);
    } else if (state is PostDetailStateLoaded) {
      return renderPage(
          context: context, post: state.post, replyTo: state.replyTo);
    } else {
      return Container();
    }
  }

  Widget renderPage(
      {required BuildContext context,
      required AmityPost post,
      AmityComment? replyTo}) {
    ScrollController scrollController = ScrollController();
    return BlocProvider(
      create: (context) => PostItemBloc(),
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  backgroundColor: theme.backgroundColor,
                  title: Text("post.title".tr()),
                  titleTextStyle: TextStyle(
                    color: theme.baseColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                  pinned: true,
                  centerTitle: true,
                ),
                SliverToBoxAdapter(
                  child: Container(
                    child: renderPost(
                      context: context,
                      post: post,
                      scrollController: scrollController,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsetsDirectional.only(
                      start: 12, end: 16, top: 7),
                  sliver: AmityCommentListComponent(
                    referenceId: postId,
                    referenceType: AmityCommentReferenceType.POST,
                    parentScrollController: scrollController,
                    commentAction:
                        CommentAction(onReply: (AmityComment? comment) {
                      context
                          .read<PostDetailBloc>()
                          .add(PostDetailReplyComment(replyTo: comment));
                    }),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                getSectionDivider(),
                AmityCommentCreator(
                  referenceId: postId,
                  referenceType: AmityCommentReferenceType.POST,
                  replyTo: replyTo,
                  action: CommentCreatorAction(onDissmiss: () {
                    context
                        .read<PostDetailBloc>()
                        .add(const PostDetailReplyComment(replyTo: null));
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget renderPost({
    required BuildContext context,
    required AmityPost post,
    required ScrollController scrollController,
  }) {
    return Column(
      children: [
        AmityPostContentComponent(
          style: AmityPostContentComponentStyle.detail,
          post: post,
          action: action,
        ),
        getSectionDivider(),
      ],
    );
  }

  Widget getSectionDivider() {
    return Container(
      width: double.infinity,
      height: 1,
      color: theme.baseColorShade4,
    );
  }

  Widget showShimmerContent() {
    return Shimmer(
      linearGradient: configProvider.getShimmerGradient(),
      child: ShimmerLoading(
        isLoading: true,
        child: SizedBox(
          height: 180,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 60,
                      padding: const EdgeInsetsDirectional.only(
                          top: 12, start: 0, end: 8, bottom: 8),
                      child: const SkeletonImage(
                        height: 40,
                        width: 40,
                        borderRadius: 40,
                      ),
                    ),
                    const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 6.0),
                          SkeletonText(width: 120),
                          SizedBox(height: 12.0),
                          SkeletonText(width: 88),
                        ]),
                  ],
                ),
                const SizedBox(height: 14.0),
                const SkeletonText(width: 240),
                const SizedBox(height: 12.0),
                const SkeletonText(width: 297),
                const SizedBox(height: 12.0),
                const SkeletonText(width: 180),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
