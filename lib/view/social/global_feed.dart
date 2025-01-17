import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/components/alert_dialog.dart';
import 'package:amity_uikit_beta_service/components/post_profile.dart';
import 'package:amity_uikit_beta_service/components/reaction_button.dart';
import 'package:amity_uikit_beta_service/components/skeleton.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/community_setting/posts/edit_post_page.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/explore_page.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/general_component.dart';
import 'package:amity_uikit_beta_service/view/user/user_profile_v2.dart';
import 'package:amity_uikit_beta_service/viewmodel/my_community_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/user_viewmodel.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// import 'package:shared/shared.dart';

import '../../components/custom_user_avatar.dart';
import '../../provider/rate/rate_cubit.dart';
import '../../viewmodel/amity_viewmodel.dart';
import '../../viewmodel/community_feed_viewmodel.dart';
import '../../viewmodel/configuration_viewmodel.dart';
import '../../viewmodel/edit_post_viewmodel.dart';
import '../../viewmodel/feed_viewmodel.dart';
import '../../viewmodel/post_viewmodel.dart';
import '../../viewmodel/user_feed_viewmodel.dart';
import 'comments.dart';
import 'community_feedV2.dart';
import 'post_content_widget.dart';

class GlobalFeedScreen extends StatefulWidget {
  final isShowMyCommunity;
  final bool canCreateCommunity;
  final bool isInit;

  const GlobalFeedScreen({
    super.key,
    this.isShowMyCommunity = true,
    this.canCreateCommunity = true,
    this.isInit = false,
    // this.isCustomPostRanking = false
  });

  @override
  GlobalFeedScreenState createState() => GlobalFeedScreenState();
}

class GlobalFeedScreenState extends State<GlobalFeedScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isInit) {
      Future.delayed(Duration.zero, () {
        var globalFeedProvider = Provider.of<FeedVM>(context, listen: false);
        var myCommunityList =
            Provider.of<MyCommunityVM>(context, listen: false);

        myCommunityList.initMyCommunityFeed();

        globalFeedProvider.initAmityGlobalFeed();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        AppBar().preferredSize.height;

    final theme = Theme.of(context);
    return Consumer<FeedVM>(builder: (context, vm, _) {
      return RefreshIndicator(
        color: Provider.of<AmityUIConfiguration>(context).primaryColor,
        onRefresh: () async {
          var globalFeedProvider = Provider.of<FeedVM>(context, listen: false);
          var myCommunityList =
              Provider.of<MyCommunityVM>(context, listen: false);

          myCommunityList.initMyCommunityFeed();

          globalFeedProvider.initAmityGlobalFeed(
              // isCustomPostRanking: widget.isCustomPostRanking
              isCustomPostRanking: false);
        },
        child: Container(
          color:
              Provider.of<AmityUIConfiguration>(context).appColors.baseShade4,
          child: !vm.isLoading && vm.getAmityPosts.isEmpty
              ? buildEmptyFeed(context)
              : vm.isLoading && vm.getAmityPosts.isEmpty
                  ? LoadingSkeleton(context: context)
                  : FadedSlideAnimation(
                      beginOffset: const Offset(0, 0.3),
                      endOffset: const Offset(0, 0),
                      slideCurve: Curves.linearToEaseOut,
                      child: ListView.builder(
                        // shrinkWrap: true,
                        controller: vm.scrollController,
                        padding: EdgeInsets.only(
                          top: 24,
                          bottom: MediaQuery.paddingOf(context).bottom + 24,
                        ),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: vm.getAmityPosts.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder<AmityPost>(
                            key: Key(vm.getAmityPosts[index].postId!),
                            stream: vm.getAmityPosts[index].listen.stream,
                            initialData: vm.getAmityPosts[index],
                            builder: (context, snapshot) {
                              return Column(
                                children: [
                                  index != 1
                                      ? const SizedBox()
                                      : widget.isShowMyCommunity
                                          ? const RecommendationSection()
                                          : const SizedBox(),
                                  PostWidget(
                                    isPostDetail: false,
                                    // customPostRanking:
                                    //     widget.isCustomPostRanking,
                                    feedType: FeedType.global,
                                    showCommunity: true,
                                    showLatestComment: false,
                                    post: snapshot.data!,
                                    theme: theme,
                                    postIndex: index,
                                    isFromFeed: true,
                                  ),
                                  if (vm.loadingNexPage &&
                                      index == vm.getAmityPosts.length - 1)
                                    SizedBox(
                                      height: 400,
                                      child: LoadingSkeleton(context: context),
                                    ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
        ),
      );
    });
  }

  Widget buildEmptyFeed(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/Icons/empty_feed.svg",
            package: 'amity_uikit_beta_service',
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "feed.no_community".tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "feed.explore".tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                DefaultTabController.of(context).animateTo(2);
              },
              icon: const Icon(Icons.search),
              label: Text("external.explore".tr()),
            ),
          ),
        ],
      ),
    );
  }
}

enum FeedType { user, community, global, pending }

class PostWidget extends StatefulWidget {
  const PostWidget({
    super.key,
    required this.post,
    required this.theme,
    required this.postIndex,
    this.isFromFeed = false,
    required this.showLatestComment,
    required this.feedType,
    required this.showCommunity,
    this.showAcceptOrRejectButton = false,
    required this.isPostDetail,
  });

  final FeedType feedType;
  final AmityPost post;
  final ThemeData theme;
  final int postIndex;
  final bool isFromFeed;
  final bool showLatestComment;
  final bool showCommunity;
  final bool showAcceptOrRejectButton;
  final bool isPostDetail;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState
    extends State<PostWidget> // with AutomaticKeepAliveClientMixin
{
  double iconSize = 13;
  double feedReactionCountSize = 13;

  Widget postWidgets() {
    List<Widget> widgets = [];
    if (widget.post.data != null) {
      widgets
          .add(AmityPostWidget([widget.post], false, false, widget.feedType));
    }
    final childrenPosts = widget.post.children;
    if (childrenPosts != null && childrenPosts.isNotEmpty) {
      widgets.add(AmityPostWidget(childrenPosts, true, true, widget.feedType));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  Widget postOptions(BuildContext context) {
    bool isPostOwner =
        widget.post.postedUserId == AmityCoreClient.getCurrentUser().userId;
    final isFlaggedByMe = widget.post.isFlaggedByMe;
    List<String> postOwnerMenu = ["external.edit".tr(), "external.delete".tr()];
    List<String> otherPostMenu = [
      isFlaggedByMe ? "report.unReport".tr() : "report.report_post".tr(),
    ];

    return IconButton(
      icon: Icon(
        Icons.more_horiz_rounded,
        size: 24,
        color: widget.feedType == FeedType.user
            ? Provider.of<AmityUIConfiguration>(context)
                .appColors
                .userProfileTextColor
            : Colors.grey,
      ),
      onPressed: () => showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: Provider.of<AmityUIConfiguration>(context)
                  .appColors
                  .baseBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding:
                const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 32),
            child: Wrap(
              children: [
                if (isPostOwner)
                  ...postOwnerMenu.map((option) => ListTile(
                        title: Text(
                          option,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          handleMenuOption(context, option, isFlaggedByMe);
                        },
                      )),
                if (!isPostOwner)
                  ...otherPostMenu.map((option) => ListTile(
                        title: Text(
                          option,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          handleMenuOption(context, option, isFlaggedByMe);
                        },
                      )),
              ],
            ),
          );
        },
      ),
    );
  }

  void handleMenuOption(_, String option, bool isFlaggedByMe) {
    if (option == "report.report_post".tr() ||
        option == "report.unReport".tr()) {
      log("isflag by me $isFlaggedByMe");
      if (isFlaggedByMe) {
        Provider.of<PostVM>(context, listen: false).unflagPost(widget.post);
      } else {
        Provider.of<PostVM>(context, listen: false).flagPost(widget.post);
      }
    } else if (option == "external.edit".tr()) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<EditPostVM>(
              create: (context) => EditPostVM(),
              child: AmityEditPostScreen(
                amityPost: widget.post,
              ))));
    } else if (option == "external.delete".tr()) {
      showDeleteConfirmationDialog(context);
    } else if (option == 'Block User') {
      Provider.of<UserVM>(context, listen: false)
          .blockUser(widget.post.postedUserId!, () {
        if (widget.feedType == FeedType.global) {
          Provider.of<FeedVM>(context, listen: false).reload();
        } else if (widget.feedType == FeedType.community) {
          Provider.of<CommuFeedVM>(context, listen: false)
              .initAmityCommunityFeed(
                  (widget.post.target as CommunityTarget).targetCommunityId!);
        }
      });
    }
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    ConfirmationDialog().show(
      context: context,
      title: "delete.post.title".tr(),
      detailText: "delete.post.content".tr(),
      leftButtonText: "external.cancel".tr(),
      rightButtonText: "external.delete".tr(),
      onConfirm: () {
        if (widget.feedType == FeedType.global) {
          Provider.of<FeedVM>(context, listen: false)
              .deletePost(widget.post, widget.postIndex, (isSuccess, error) {
            if (isSuccess && widget.isPostDetail) {
              Navigator.of(context).pop();
            }
          });
        } else if (widget.feedType == FeedType.community) {
          Provider.of<CommuFeedVM>(context, listen: false)
              .deletePost(widget.post, widget.postIndex, (isSuccess, error) {
            if (isSuccess && widget.isPostDetail) {
              Navigator.of(context).pop();
            }
          });
        } else if (widget.feedType == FeedType.user) {
          Provider.of<UserFeedVM>(context, listen: false)
              .deletePost(widget.post, (isSuccess, error) {
            if (isSuccess && widget.isPostDetail) {
              Navigator.of(context).pop();
            }
          });
        } else if (widget.feedType == FeedType.pending) {
          Provider.of<CommuFeedVM>(context, listen: false)
              .deletePendingPost(widget.post, widget.postIndex);
        } else {
          print("unhandled postType");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color:
            Provider.of<AmityUIConfiguration>(context).appColors.baseBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              Provider.of<AmityUIConfiguration>(context).appColors.baseShade3,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                if (widget.isFromFeed) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentScreen(
                            amityPost: widget.post,
                            theme: widget.theme,
                            isFromFeed: true,
                            feedType: widget.feedType,
                          )));
                }
              },
              child: Container(
                margin: const EdgeInsetsDirectional.only(bottom: 0),
                color: Provider.of<AmityUIConfiguration>(context)
                    .appColors
                    .baseBackground,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: Column(
                    children: [
                      SizedBox(
                        child: ListTile(
                          contentPadding: const EdgeInsetsDirectional.only(
                              start: 0, top: 0, end: 0, bottom: 0),
                          leading: FadeAnimation(
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeNotifierProvider(
                                          create: (context) => UserFeedVM(),
                                          child: UserProfileScreen(
                                            amityUser: widget.post.postedUser!,
                                            amityUserId:
                                                widget.post.postedUser!.userId!,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: getAvatarImage(
                                      widget.post.postedUser!.userId !=
                                              AmityCoreClient.getCurrentUser()
                                                  .userId
                                          ? widget.post.postedUser?.avatarUrl
                                          : AmityCoreClient.getCurrentUser()
                                              .avatarUrl))),
                          title: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.post.postedUser!.userId !=
                                          AmityCoreClient.getCurrentUser()
                                              .userId
                                      ? widget.post.postedUser?.displayName ??
                                          "community.name".tr() //Display name
                                      : Provider.of<AmityVM>(context)
                                          .currentAmityUser
                                          ?.displayName,
                                  style: TextStyle(
                                      color: Provider.of<AmityUIConfiguration>(
                                              context)
                                          .appColors
                                          .baseShade1),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider(
                                            create: (context) => UserFeedVM(),
                                            child: UserProfileScreen(
                                              amityUser:
                                                  widget.post.postedUser!,
                                              amityUserId: widget
                                                  .post.postedUser!.userId!,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                ),
                                if (widget.showCommunity &&
                                    widget.post.targetType ==
                                        AmityPostTargetType.COMMUNITY) ...[
                                  TextSpan(
                                    text: "post.place".tr(),
                                    style: TextStyle(
                                        color:
                                            Provider.of<AmityUIConfiguration>(
                                                    context)
                                                .appColors
                                                .baseShade2),
                                  ),
                                  TextSpan(
                                    text:
                                        (widget.post.target as CommunityTarget)
                                                .targetCommunity!
                                                .displayName ??
                                            "community.community_name".tr(),
                                    style: TextStyle(
                                        color:
                                            Provider.of<AmityUIConfiguration>(
                                                    context)
                                                .primaryColor),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ChangeNotifierProvider(
                                              create: (context) =>
                                                  CommuFeedVM(),
                                              child: CommunityScreen(
                                                isFromFeed: true,
                                                community: (widget.post.target
                                                        as CommunityTarget)
                                                    .targetCommunity!,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                  ),
                                ],
                              ],
                            ),
                            style: const TextStyle(fontSize: 12),
                          ),
                          // title: Wrap(
                          //   children: [
                          //     GestureDetector(
                          //       onTap: () {
                          //         Navigator.of(context).push(
                          //           MaterialPageRoute(
                          //             builder: (context) =>
                          //                 ChangeNotifierProvider(
                          //               create: (context) => UserFeedVM(),
                          //               child: UserProfileScreen(
                          //                   amityUser: widget.post.postedUser!,
                          //                   amityUserId:
                          //                       widget.post.postedUser!.userId!),
                          //             ),
                          //           ),
                          //         );
                          //       },
                          //       child: Text(
                          //         widget.post.postedUser!.userId !=
                          //                 AmityCoreClient.getCurrentUser().userId
                          //             ? widget.post.postedUser?.displayName ??
                          //                 "عرض الاسم" //Display name
                          //             : Provider.of<AmityVM>(context)
                          //                     .currentamityUser!
                          //                     .displayName ??
                          //                 "",
                          //         style: TextStyle(
                          //             fontWeight: FontWeight.bold,
                          //             color: Provider.of<AmityUIConfiguration>(
                          //                     context)
                          //                 .appColors
                          //                 .base),
                          //       ),
                          //     ),
                          //     widget.showCommunity &&
                          //             widget.post.targetType ==
                          //                 AmityPostTargetType.COMMUNITY
                          //         ? Icon(
                          //             Icons.arrow_right_rounded,
                          //             color: Provider.of<AmityUIConfiguration>(
                          //                     context)
                          //                 .appColors
                          //                 .base,
                          //           )
                          //         : Container(),
                          //     widget.showCommunity &&
                          //             widget.post.targetType ==
                          //                 AmityPostTargetType.COMMUNITY
                          //         ? GestureDetector(
                          //             onTap: () {
                          //               Navigator.of(context).push(
                          //                   MaterialPageRoute(
                          //                       builder: (context) =>
                          //                           ChangeNotifierProvider(
                          //                             create: (context) =>
                          //                                 CommuFeedVM(),
                          //                             child: CommunityScreen(
                          //                               isFromFeed: true,
                          //                               community: (widget
                          //                                           .post.target
                          //                                       as CommunityTarget)
                          //                                   .targetCommunity!,
                          //                             ),
                          //                           )));
                          //             },
                          //             child: Text(
                          //               (widget.post.target as CommunityTarget)
                          //                       .targetCommunity!
                          //                       .displayName ??
                          //                   "اسم المجتمع", //Community name
                          //               style: widget.theme.textTheme.bodyLarge!
                          //                   .copyWith(
                          //                 color:
                          //                     Provider.of<AmityUIConfiguration>(
                          //                             context)
                          //                         .appColors
                          //                         .base,
                          //                 overflow: TextOverflow.ellipsis,
                          //                 fontWeight: FontWeight.bold,
                          //                 fontSize: 16,
                          //               ),
                          //             ),
                          //           )
                          //         : Container()
                          //   ],
                          // ),
                          subtitle: Row(
                            children: [
                              TimeAgoWidget(
                                createdAt: widget.post.createdAt!,
                                textColor:
                                    Provider.of<AmityUIConfiguration>(context)
                                        .appColors
                                        .baseShade2,
                              ),
                              widget.post.editedAt != widget.post.createdAt
                                  ? Row(
                                      children: [
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Icon(
                                          Icons.circle,
                                          size: 4,
                                          color: widget.feedType ==
                                                  FeedType.user
                                              ? Provider.of<
                                                          AmityUIConfiguration>(
                                                      context)
                                                  .appColors
                                                  .userProfileTextColor
                                              : Colors.grey,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text("external.edited".tr(), //Edited
                                            style: TextStyle(
                                              color: widget.feedType ==
                                                      FeedType.user
                                                  ? Provider.of<
                                                              AmityUIConfiguration>(
                                                          context)
                                                      .appColors
                                                      .userProfileTextColor
                                                  : Colors.grey,
                                            )),
                                      ],
                                    )
                                  : const SizedBox()
                            ],
                          ),
                          trailing: widget.feedType == FeedType.pending &&
                                  widget.post.postedUser!.userId !=
                                      AmityCoreClient.getCurrentUser().userId
                              ? null
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Image.asset(
                                    //   'assets/Icons/ic_share.png',
                                    //   scale: 3,
                                    // ),
                                    // SizedBox(width: iconSize.feedIconSize),
                                    // Icon(
                                    //   Icons.bookmark_border,
                                    //   size: iconSize.feedIconSize,
                                    //   color: ApplicationColors.grey,
                                    // ),
                                    // SizedBox(width: iconSize.feedIconSize),
                                    postOptions(context),
                                  ],
                                ),
                        ),
                      ),
                      postWidgets(),
                      widget.feedType == FeedType.pending
                          ? const SizedBox()
                          : SizedBox(
                              child: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      top: 16, bottom: 16, start: 0, end: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Builder(builder: (context) {
                                        return widget.post.reactionCount! > 0
                                            ? Row(
                                                children: [
                                                  // CircleAvatar(
                                                  //   radius: 10,
                                                  //   backgroundColor: Provider
                                                  //           .of<AmityUIConfiguration>(
                                                  //               context)
                                                  //       .primaryColor,
                                                  //   child: const Icon(
                                                  //     Icons.thumb_up,
                                                  //     color: Colors.white,
                                                  //     size: 13,
                                                  //   ),
                                                  // ),
                                                  // const SizedBox(
                                                  //   width: 5,
                                                  // ),
                                                  Text(
                                                      widget.post.reactionCount
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: widget
                                                                      .feedType ==
                                                                  FeedType.user
                                                              ? Provider.of<
                                                                          AmityUIConfiguration>(
                                                                      context)
                                                                  .appColors
                                                                  .userProfileTextColor
                                                              : Colors.grey,
                                                          fontSize:
                                                              feedReactionCountSize,
                                                          letterSpacing: 1)),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                      widget.post.reactionCount! >
                                                              1
                                                          ? "post.members_like"
                                                              .tr() //likes
                                                          : "post.member_like"
                                                              .tr(), //like
                                                      style: TextStyle(
                                                          color: widget
                                                                      .feedType ==
                                                                  FeedType.user
                                                              ? Provider.of<
                                                                          AmityUIConfiguration>(
                                                                      context)
                                                                  .appColors
                                                                  .userProfileTextColor
                                                              : Colors.grey,
                                                          fontSize:
                                                              feedReactionCountSize,
                                                          letterSpacing: 1)),
                                                ],
                                              )
                                            : const SizedBox(
                                                width: 0,
                                              );
                                      }),
                                      Builder(builder: (context) {
                                        // any logic needed...
                                        if (widget.post.commentCount! > 1) {
                                          return Text(
                                            "community.comment".plural(
                                              widget.post.commentCount ?? 0,
                                              format: NumberFormat.compact(
                                                  locale: context.locale
                                                      .toString()),
                                            ),
                                            //comments
                                            style: TextStyle(
                                                color: widget.feedType ==
                                                        FeedType.user
                                                    ? Provider.of<
                                                                AmityUIConfiguration>(
                                                            context)
                                                        .appColors
                                                        .userProfileTextColor
                                                    : Colors.grey,
                                                fontSize: feedReactionCountSize,
                                                letterSpacing: 0.5),
                                          );
                                        } else if (widget.post.commentCount! ==
                                            0) {
                                          return const SizedBox(
                                            width: 0,
                                          );
                                        } else {
                                          return Text(
                                            "community.comment".plural(
                                              widget.post.commentCount ?? 0,
                                              format: NumberFormat.compact(
                                                  locale: context.locale
                                                      .toString()),
                                            ),
                                            //comment
                                            style: TextStyle(
                                                color: widget.feedType ==
                                                        FeedType.user
                                                    ? Provider.of<
                                                                AmityUIConfiguration>(
                                                            context)
                                                        .appColors
                                                        .userProfileTextColor
                                                    : Colors.grey,
                                                fontSize: feedReactionCountSize,
                                                letterSpacing: 0.5),
                                          );
                                        }
                                      })
                                    ],
                                  )),
                            ),
                      const Divider(
                        // color: widget.feedType == FeedType.user
                        //     ? Provider.of<AmityUIConfiguration>(context)
                        //         .appColors
                        //         .userProfileTextColor
                        //     : Colors.grey,
                        height: 1,
                      ),
                      // const SizedBox(
                      //   height: 7,
                      // ),
                      widget.feedType == FeedType.pending
                          ? widget.showAcceptOrRejectButton
                              ? PendingSectionButton(
                                  postId: widget.post.postId!,
                                  communityId:
                                      (widget.post.target as CommunityTarget)
                                          .targetCommunityId!,
                                )
                              : const SizedBox()
                          : SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ReactionWidget(
                                      post: widget.post,
                                      feedType: widget.feedType,
                                      feedReactionCountSize:
                                          feedReactionCountSize),

                                  TextButton(
                                    onPressed: () {
                                      if (widget.isFromFeed) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CommentScreen(
                                                      amityPost: widget.post,
                                                      theme: widget.theme,
                                                      isFromFeed: true,
                                                      feedType: widget.feedType,
                                                    )));
                                        context
                                            .read<RateCubit>()
                                            .checkRate("community");
                                      }
                                    },
                                    style: ButtonStyle(
                                      padding: WidgetStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6)),
                                      minimumSize: WidgetStateProperty.all<Size>(Size.zero),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Provider.of<AmityUIConfiguration>(
                                                context)
                                            .iconConfig
                                            .commentIcon(),
                                        const SizedBox(width: 5.5),
                                        Text(
                                          "comment.comment".tr(), //Comment
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: feedReactionCountSize,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {},
                                  //   child: Row(
                                  //     children: [
                                  //       Provider.of<AmityUIConfiguration>(context)
                                  //           .iconConfig
                                  //           .shareIcon(iconSize: 16),
                                  //       const SizedBox(width: 4),
                                  //       Text(
                                  //         "Share",
                                  //         style: TextStyle(
                                  //           color: Colors.grey,
                                  //           fontSize: feedReactionCountSize,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),

                      // Divider(),
                      // CommentComponent(
                      //     key: Key(widget.post.postId!),
                      //     postId: widget.post.postId!,
                      //     theme: widget.theme)
                    ],
                  ),
                ),
              )),
          widget.post.latestComments == null
              ? const SizedBox()
              : !widget.showLatestComment
                  ? const SizedBox()
                  : Container(
                      color: Provider.of<AmityUIConfiguration>(context)
                          .appColors
                          .baseBackground,
                      child: const Divider(
                        // color: widget.feedType == FeedType.user
                        //     ? Provider.of<AmityUIConfiguration>(context)
                        //         .appColors
                        //         .userProfileTextColor
                        //     : Colors.grey,
                        height: 0,
                      )),
          // widget.isFromFeed
          //     ? const SizedBox()
          //     : Container(
          //         color: Colors.white,
          //         child: const Divider(
          //           color: Colors.grey,
          //           height: 0,
          //         )),

          !widget.showLatestComment
              ? const SizedBox()
              : widget.post.latestComments == null
                  ? const SizedBox()
                  : widget.post.latestComments!.isEmpty
                      ? const SizedBox()
                      : Container(
                          color: Provider.of<AmityUIConfiguration>(context)
                              .appColors
                              .baseBackground,
                          child: LatestCommentComponent(
                            feedType: widget.feedType,
                            postId: widget.post.data!.postId,
                            comments: widget.post.latestComments!,
                          ),
                        ),

          !widget.isFromFeed
              ? const SizedBox()
              : const SizedBox(
                  height: 8,
                )
        ],
      ),
    );
  }

// @override
// bool get wantKeepAlive {
//   final childrenPosts = widget.post.children;
//   if (childrenPosts != null && childrenPosts.isNotEmpty) {
//     if (childrenPosts[0].data is VideoData) {
//       log("keep ${childrenPosts[0].parentPostId} alive");
//       return true;
//     } else {
//       return true;
//     }
//   } else {
//     return false;
//   }
// }
}

class PendingSectionButton extends StatelessWidget {
  final String postId;
  final String communityId;

  const PendingSectionButton({
    super.key,
    required this.postId,
    required this.communityId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 11,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Provider.of<CommuFeedVM>(context, listen: false).acceptPost(
                    postId: postId,
                    communityId: communityId,
                    callback: (isSuccess) {},
                  );
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        Provider.of<AmityUIConfiguration>(context).primaryColor,
                    borderRadius: BorderRadius.circular(4), // Set border radius
                  ),
                  child: Center(
                    child: Text(
                      "external.accept".tr(), //Accept
                      style: const TextStyle(color: Colors.white),
                    ),
                  ), // Text color set to white
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Provider.of<CommuFeedVM>(context, listen: false).declinePost(
                    postId: postId,
                    communityId: communityId,
                    callback: (isSuccess) {},
                  );
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white, // Decline button background color
                    borderRadius: BorderRadius.circular(4), // Set border radius
                    border: Border.all(color: Colors.grey), // Border color
                  ),
                  child: Center(
                    child: Text("external.decline".tr()),
                  ), //Decline// Text with default color
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}

class LatestCommentComponent extends StatefulWidget {
  const LatestCommentComponent({
    super.key,
    required this.postId,
    required this.comments,
    required this.feedType,
    this.textColor,
  });

  final FeedType feedType;
  final String postId;

  final List<AmityComment> comments;
  final Color? textColor;

  @override
  State<LatestCommentComponent> createState() => _LatestCommentComponentState();
}

class _LatestCommentComponentState extends State<LatestCommentComponent> {
  @override
  void initState() {
    super.initState();
  }

  bool isLiked(AsyncSnapshot<AmityComment> snapshot) {
    var comments = snapshot.data!;
    return comments.myReactions?.isNotEmpty ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostVM>(builder: (context, vm, _) {
      return ListView.builder(
        padding: EdgeInsetsDirectional.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.comments.length,
        itemBuilder: (context, index) {
          return StreamBuilder<AmityComment>(
            key: Key(widget.comments[index].commentId!),
            stream: widget.comments[index].listen.stream,
            initialData: widget.comments[index],
            builder: (context, snapshot) {
              var comments = snapshot.data!;
              var commentData = comments.data as CommentTextData;

              return index > 1
                  ? const SizedBox()
                  : comments.isDeleted!
                      ? const SizedBox()
                      //     child: const Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Padding(
                      //           padding: EdgeInsetsDirectional.all(9.0),
                      //           child: Row(
                      //             children: [
                      //               SizedBox(
                      //                 width: 14,
                      //               ),
                      //               Icon(
                      //                 Icons.remove_circle_outline,
                      //                 size: 15,
                      //                 color: Color(0xff636878),
                      //               ),
                      //               SizedBox(
                      //                 width: 14,
                      //               ),
                      //               Text(
                      //                 "هذا التعليق تم حذفه",
                      //                 //This comment  has been deleted
                      //                 style: TextStyle(
                      //                     color: Color(0xff636878),
                      //                     fontSize: 13),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //         Divider(
                      //           height: 0,
                      //         )
                      //       ],
                      //     ),
                      //   )
                      : Column(
                          children: [
                            Container(
                              color: widget.feedType == FeedType.user
                                  ? Provider.of<AmityUIConfiguration>(context)
                                      .appColors
                                      .userProfileBGColor
                                  : Colors.white,
                              padding: const EdgeInsetsDirectional.symmetric(
                                  vertical: 0, horizontal: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsetsDirectional.only(
                                        top: 14, start: 16, bottom: 8),
                                    child: CustomListTile(
                                        avatarUrl: comments.user!.avatarUrl,
                                        displayName:
                                            comments.user!.displayName!,
                                        createdAt: comments.createdAt!,
                                        editedAt: comments.editedAt!,
                                        userId: comments.user!.userId!,
                                        user: comments.user!),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsetsDirectional.all(10.0),
                                    margin: const EdgeInsetsDirectional.only(
                                        start: 70.0, end: 18),
                                    decoration: BoxDecoration(
                                      color: Provider.of<AmityUIConfiguration>(
                                              context)
                                          .appColors
                                          .baseShade4,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      commentData.text!,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color:
                                            Provider.of<AmityUIConfiguration>(
                                                    context)
                                                .appColors
                                                .base,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  CommentActionComponent(
                                      amityComment: comments),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                            ),
                            // const Divider(
                            //   height: 0,
                            // ),
                          ],
                        );
            },
          );
        },
      );
    });
  }
}

class CommentActionComponent extends StatelessWidget {
  const CommentActionComponent({
    super.key,
    required this.amityComment,
  });

  final AmityComment amityComment;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AmityComment>(
      stream: amityComment.listen.stream,
      initialData: amityComment,
      builder: (context, snapshot) {
        var comments = snapshot.data!;
        return Padding(
          padding: const EdgeInsetsDirectional.only(start: 70.0, top: 5.0),
          child: Row(
            children: [
              // Like Button
              comments.myReactions == null
                  ? GestureDetector(
                      onTap: () {
                        Provider.of<PostVM>(context, listen: false)
                            .addCommentReaction(comments);
                        context.read<RateCubit>().checkRate("community");
                      },
                      child: Row(
                        children: [
                          Provider.of<AmityUIConfiguration>(context)
                              .iconConfig
                              .likeIcon(),
                          snapshot.data!.reactionCount! > 0
                              ? Text(
                                  " ${snapshot.data!.reactionCount!}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff898E9E),
                                  ),
                                )
                              : Text(
                                  "post.useful".tr(), //Like
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff898E9E),
                                  ),
                                ),
                        ],
                      ),
                    )
                  : comments.myReactions!.isEmpty
                      ? GestureDetector(
                          onTap: () {
                            Provider.of<PostVM>(context, listen: false)
                                .addCommentReaction(comments);
                          },
                          child: Row(
                            children: [
                              Provider.of<AmityUIConfiguration>(context)
                                  .iconConfig
                                  .likeIcon(),
                              snapshot.data!.reactionCount! > 0
                                  ? Text(
                                      " ${snapshot.data!.reactionCount!}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff898E9E),
                                      ),
                                    )
                                  : Text(
                                      "post.useful".tr(), //Like
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff898E9E),
                                      ),
                                    ),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            print("addCommentReaction");
                            Provider.of<PostVM>(context, listen: false)
                                .removeCommentReaction(comments);
                            context.read<RateCubit>().checkRate("community");
                          },
                          child: Row(
                            children: [
                              Provider.of<AmityUIConfiguration>(context)
                                  .iconConfig
                                  .likedIcon(
                                      color: Provider.of<AmityUIConfiguration>(
                                              context)
                                          .primaryColor),
                              Text(
                                " ${snapshot.data?.reactionCount ?? 0}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Provider.of<AmityUIConfiguration>(
                                            context)
                                        .appColors
                                        .primary),
                              ),
                            ],
                          )),

              // const SizedBox(width: 10),
              // // Reply Button
              // Provider.of<AmityUIConfiguration>(
              //         context)
              //     .iconConfig
              //     .replyIcon(),

              // const Text(
              //   "Reply",
              //   style: TextStyle(
              //     color: Color(0xff898E9E),
              //   ),
              // ),

              // More Options Button
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                child: const Icon(
                  Icons.more_horiz,
                  color: Color(0xff898E9E),
                ),
                onTap: () => AmityGeneralComponent.showOptionsBottomSheet(
                  context,
                  [
                    comments.user?.userId! ==
                            AmityCoreClient.getCurrentUser().userId
                        ? const SizedBox()
                        : ListTile(
                            title: Text(
                              "report.report".tr(), //Report
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                            },
                          ),

                    ///check admin
                    comments.user?.userId! !=
                            AmityCoreClient.getCurrentUser().userId
                        ? const SizedBox()
                        : ListTile(
                            title: Text(
                              "comment.edit".tr(), //Edit Comment
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditCommentPage(
                                        feedType: FeedType.user,
                                        initialText:
                                            (comments.data as CommentTextData)
                                                .text!,
                                        comment: comments,
                                        postCallback: () async {},
                                      )));
                            },
                          ),
                    comments.user?.userId! !=
                            AmityCoreClient.getCurrentUser().userId
                        ? const SizedBox()
                        : ListTile(
                            title: Text(
                              "comment.delete".tr(), // Delete Comment
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            onTap: () async {
                              ConfirmationDialog().show(
                                context: context,
                                title: "delete.comment".tr(),
                                //Delete this comment
                                detailText: "delete.comment_content".tr(),
                                // This comment will be permanently deleted. You'll no longer to see and find this comment
                                onConfirm: () {
                                  Provider.of<PostVM>(context)
                                      .deleteComment(comments);
                                  // AmitySuccessDialog
                                  //     .showTimedDialog(
                                  //         "Success",
                                  //         context:
                                  //             context);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
