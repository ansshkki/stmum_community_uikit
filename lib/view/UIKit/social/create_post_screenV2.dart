import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/components/alert_dialog.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/community_setting/posts/post_cpmponent.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/post_target_page.dart';
import 'package:amity_uikit_beta_service/viewmodel/configuration_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/create_postV2_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:amity_uikit_beta_service/viewmodel/create_post_viewmodel.dart';
// import 'package:amity_uikit_beta_service/viewmodel/media_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:shared/shared.dart';

import '../../../provider/rate/rate_cubit.dart';
import '../../../viewmodel/community_feed_viewmodel.dart';
import '../../../viewmodel/community_member_viewmodel.dart';
import '../../social/comments.dart';
import '../../social/global_feed.dart';

class AmityCreatePostV2Screen extends StatefulWidget {
  final AmityCommunity? community;

  // final AmityUser? amityUser;
  final bool isFromPostToPage;
  final FeedType? feedType;

  const AmityCreatePostV2Screen({
    super.key,
    this.community,
    // this.amityUser,
    this.isFromPostToPage = false,
    this.feedType,
  });

  @override
  State<AmityCreatePostV2Screen> createState() =>
      _AmityCreatePostV2ScreenState();
}

class _AmityCreatePostV2ScreenState extends State<AmityCreatePostV2Screen> {
  AmityCommunity? community;
  final textFocusNode = FocusNode();
  bool loading = false;

  @override
  void initState() {
    community = widget.community;
    Provider.of<CreatePostVMV2>(context, listen: false).init();

    super.initState();
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<CreatePostVMV2>(builder: (consumerContext, vm, _) {
      return Scaffold(
        backgroundColor:
            Provider.of<AmityUIConfiguration>(context).appColors.baseBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: Text(
            "post.new_share".tr(), //My Feed
            style: Provider.of<AmityUIConfiguration>(context)
                .titleTextStyle
                .copyWith(
                    color: Provider.of<AmityUIConfiguration>(context)
                        .appColors
                        .base),
          ),
          automaticallyImplyLeading: false,
          actions: [
            // TextButton(
            //   onPressed: hasContent
            //       ? () async {
            //           if (vm.isUploadComplete) {
            //             if (widget.community == null) {
            //               //creat post in user Timeline
            //               await vm.createPost(context,
            //                   callback: (isSuccess, error) {
            //                 if (isSuccess) {
            //                   Navigator.of(context).pop();
            //                   if (widget.isFromPostToPage) {
            //                     Navigator.of(context).pop();
            //                   }
            //                 } else {}
            //               });
            //             } else {
            //               //create post in Community
            //               await vm.createPost(context,
            //                   communityId: widget.community?.communityId!,
            //                   callback: (isSuccess, error) async {
            //                 if (isSuccess) {
            //                   var roleVM = Provider.of<MemberManagementVM>(
            //                       context,
            //                       listen: false);
            //                   roleVM.checkCurrentUserRole(
            //                       widget.community!.communityId!);
            //
            //                   if (widget.community!.isPostReviewEnabled!) {
            //                     if (!widget.community!.hasPermission(
            //                         AmityPermission.REVIEW_COMMUNITY_POST)) {
            //                       await AmityDialog().showAlertErrorDialog(
            //                           title: "تم تسجيل المنشور", //Post submitted
            //                           message:
            //                               "لقد تم إرسال منشورك إلى قائمة الانتظار. سيتم مراجعتها بواسطة مشرف المجتمع"); //Your post has been submitted to the pending list. It will be reviewed by community moderator
            //                     }
            //                   }
            //                   Navigator.of(context).pop();
            //                   if (widget.isFromPostToPage) {
            //                     Navigator.of(context).pop();
            //                   }
            //                   if (widget.community!.isPostReviewEnabled!) {
            //                     Provider.of<CommuFeedVM>(context, listen: false)
            //                         .initAmityPendingCommunityFeed(
            //                             widget.community!.communityId!,
            //                             AmityFeedType.REVIEWING);
            //                   }
            //
            //                   // Navigator.of(context).push(MaterialPageRoute(
            //                   //     builder: (context) => ChangeNotifierProvider(
            //                   //           create: (context) => CommuFeedVM(),
            //                   //           child: CommunityScreen(
            //                   //             isFromFeed: true,
            //                   //             community: widget.community!,
            //                   //           ),
            //                   //         )));
            //                 }
            //               });
            //             }
            //           }
            //         }
            //       : null,
            //   child: Text("نشر", //Post
            //       style: TextStyle(
            //           color: vm.isPostValid
            //               ? Provider.of<AmityUIConfiguration>(context)
            //                   .primaryColor
            //               : Colors.grey)),
            // ),
            IconButton(
              icon: Icon(Icons.close,
                  color: Provider.of<AmityUIConfiguration>(context)
                      .appColors
                      .base),
              onPressed: () {
                if (vm.isPostValid) {
                  ConfirmationDialog().show(
                    context: context,
                    title: "messages.discard.title".tr(),
                    detailText: "messages.discard.content".tr(),
                    leftButtonText: "external.cancel".tr(),
                    rightButtonText: "external.discard".tr(),
                    onConfirm: () => Navigator.of(context).pop(),
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => textFocusNode.requestFocus(),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            style: TextStyle(
                                color:
                                    Provider.of<AmityUIConfiguration>(context)
                                        .appColors
                                        .base),
                            focusNode: textFocusNode,
                            onChanged: (value) => vm.updatePostValidity(),
                            controller: vm.textEditingController,
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "post.hint".tr(),
                              //Write something to post
                              hintStyle: TextStyle(
                                  color:
                                      Provider.of<AmityUIConfiguration>(context)
                                          .appColors
                                          .userProfileTextColor),
                            ),
                            // style: t/1heme.textTheme.bodyText1.copyWith(color: Colors.grey),
                          ),
                          Consumer<CreatePostVMV2>(
                            builder: (context, vm, _) =>
                                PostMedia(files: vm.files),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () async {
                  final community = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    builder: (context) => const FractionallySizedBox(
                      heightFactor: 0.8,
                      child: PostToPage(),
                    ),
                  );
                  if (community is AmityCommunity?) {
                    setState(() {
                      this.community = community;
                    });
                  }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          community == null
                              ? "user.profile".tr()
                              : "community.share"
                                  .tr(args: [community?.displayName ?? ""]),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _iconButton(
                      Icons.camera_alt_outlined,
                      isEnable:
                          vm.availableFileSelectionOptions()[MyFileType.image]!,
                      label: "media.camera".tr(),
                      //Photo
                      // debugingText:
                      //     "${vm2.isNotSelectVideoYet()}&& ${vm2.isNotSelectedFileYet()}",
                      onTap: () {
                        _handleCameraTap(context);
                      },
                    ),
                    _iconButton(
                      Icons.image_outlined,
                      label: "media.photo".tr(), //Image
                      isEnable:
                          vm.availableFileSelectionOptions()[MyFileType.image]!,
                      onTap: () async {
                        _handleImageTap(context);
                      },
                    ),
                    _iconButton(
                      Icons.play_circle_outline,
                      label: "media.video".tr(), //Video
                      isEnable:
                          vm.availableFileSelectionOptions()[MyFileType.video]!,
                      onTap: () async {
                        _handleVideoTap(context);
                      },
                    ),
                    _iconButton(
                      Icons.attach_file_outlined,
                      label: "media.file".tr(), //File
                      isEnable:
                          vm.availableFileSelectionOptions()[MyFileType.file]!,
                      onTap: () async {
                        _handleFileTap(context);
                      },
                    ),
                    // _iconButton(
                    //   Icons.more_horiz,
                    //   isEnable: true,
                    //   label: "المزيد", //More
                    //   onTap: () {
                    //     // TODO: Implement more options logic
                    //     _showMoreOptions(context);
                    //   },
                    // ),
                    const Spacer(),
                    loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: vm.isPostValid
                                ? () async {
                                    setState(() => loading = true);
                                    if (vm.isUploadComplete) {
                                      if (community == null) {
                                        //creat post in user Timeline
                                        await vm.createPost(context,
                                            callback: (isSuccess, error, post) {
                                          setState(() => loading = false);
                                          if (isSuccess) {
                                            Navigator.of(context).pop(true);
                                            if (widget.isFromPostToPage) {
                                              Navigator.of(context).pop(true);
                                            }
                                          } else {}
                                        });
                                      } else {
                                        //create post in Community
                                        await vm.createPost(context,
                                            communityId:
                                                community?.communityId!,
                                            callback:
                                                (isSuccess, error, post) async {
                                          setState(() => loading = false);
                                          if (isSuccess) {
                                            var roleVM =
                                                Provider.of<MemberManagementVM>(
                                                    context,
                                                    listen: false);
                                            roleVM.checkCurrentUserRole(
                                                community!.communityId!);

                                            if (community!
                                                .isPostReviewEnabled!) {
                                              if (!community!.hasPermission(
                                                  AmityPermission
                                                      .REVIEW_COMMUNITY_POST)) {
                                                await AmityDialog()
                                                    .showAlertErrorDialog(
                                                  title: "post.submitted".tr(),
                                                  //Post submitted
                                                  message:
                                                      "post.submitted_content"
                                                          .tr(),
                                                ); //Your post has been submitted to the pending list. It will be reviewed by community moderator
                                              }
                                            }
                                            Navigator.of(context).pop(true);
                                            if (widget.isFromPostToPage) {
                                              Navigator.of(context).pop(true);
                                            }
                                            if (community!
                                                .isPostReviewEnabled!) {
                                              Provider.of<CommuFeedVM>(context,
                                                      listen: false)
                                                  .initAmityPendingCommunityFeed(
                                                      community!.communityId!,
                                                      AmityFeedType.REVIEWING);
                                            }

                                            if (post != null) {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CommentScreen(
                                                            amityPost: post,
                                                            theme: Theme.of(
                                                                context),
                                                            isFromFeed: false,
                                                            feedType: FeedType
                                                                .community,
                                                          )));
                                            }

                                            // Navigator.of(context).push(MaterialPageRoute(
                                            //     builder: (context) => ChangeNotifierProvider(
                                            //           create: (context) => CommuFeedVM(),
                                            //           child: CommunityScreen(
                                            //             isFromFeed: true,
                                            //             community: community!,
                                            //           ),
                                            //         )));
                                          }
                                        });
                                      }
                                    }
                                    context
                                        .read<RateCubit>()
                                        .checkRate("community");
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                            ),
                            child: Text("external.share".tr()),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _iconButton(IconData icon,
      {required String label,
      required VoidCallback onTap,
      required bool isEnable,
      String? debugingText}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        debugingText == null ? const SizedBox() : Text(debugingText),
        IconButton(
          icon: Icon(
            icon,
            color:
                Provider.of<AmityUIConfiguration>(context).appColors.baseShade1,
          ),
          onPressed: isEnable ? onTap : null,
        ),
      ],
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Consumer<CreatePostVMV2>(builder: (consumerContext, vm, _) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(top: 16.0),
                // Space at the top
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: _iconButton(Icons.camera_alt_outlined,
                          isEnable: vm.availableFileSelectionOptions()[
                              MyFileType.image]!,
                          label: "media.camera".tr(), //Camera
                          onTap: () {}),
                      title: Text(
                        "media.camera".tr(), //Camera
                        style: TextStyle(
                            color: vm.availableFileSelectionOptions()[
                                    MyFileType.image]!
                                ? Colors.black
                                : Colors.grey),
                      ),
                      onTap: () {
                        if (vm.availableFileSelectionOptions()[
                            MyFileType.image]!) {
                          _handleImageTap(context);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    ListTile(
                      leading: _iconButton(Icons.image_outlined,
                          isEnable: vm.availableFileSelectionOptions()[
                              MyFileType.image]!,
                          label: "media.photo".tr(), //Photo
                          onTap: () {}),
                      title: Text(
                        "media.photo".tr(), //Photo
                        style: TextStyle(
                            color: vm.availableFileSelectionOptions()[
                                    MyFileType.image]!
                                ? Colors.black
                                : Colors.grey),
                      ),
                      onTap: () {
                        if (vm.availableFileSelectionOptions()[
                            MyFileType.image]!) {
                          _handleImageTap(context);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    ListTile(
                      leading: _iconButton(
                        Icons.attach_file_rounded,
                        isEnable: vm
                            .availableFileSelectionOptions()[MyFileType.file]!,
                        label: "media.attachment".tr(), //Attachment
                        onTap: () {},
                      ),
                      title: Text(
                        "media.attachment".tr(), //Attachment
                        style: TextStyle(
                            color: vm.availableFileSelectionOptions()[
                                    MyFileType.file]!
                                ? Colors.black
                                : Colors.grey),
                      ),
                      onTap: () {
                        if (vm.availableFileSelectionOptions()[
                            MyFileType.file]!) {
                          _handleFileTap(context);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    ListTile(
                      leading: _iconButton(
                        Icons.play_circle_outline_outlined,
                        isEnable: vm
                            .availableFileSelectionOptions()[MyFileType.video]!,
                        label: "media.video".tr(), //Video
                        onTap: () {},
                      ),
                      title: Text(
                        "media.video".tr(), //Video
                        style: TextStyle(
                            color: vm.availableFileSelectionOptions()[
                                    MyFileType.video]!
                                ? Colors.black
                                : Colors.grey),
                      ),
                      onTap: () {
                        if (vm.availableFileSelectionOptions()[
                            MyFileType.video]!) {
                          _handleVideoTap(context);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _showDiscardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("messages.discard.title".tr()),
        //Discard Post?
        content: Text("messages.discard.content".tr()),
        //Do you want to discard your post?
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("external.cancel".tr()), //Cancel
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              Navigator.of(context).pop();
            },
            child: Text("external.discard".tr()), //Discard
          ),
        ],
      ),
    );
  }

  Future<void> _handleCameraTap(BuildContext context) async {
    await _pickMedia(context, PickerAction.cameraImage);
  }

  Future<void> _handleImageTap(BuildContext context) async {
    await _pickMedia(context, PickerAction.galleryImage);
  }

  Future<void> _handleVideoTap(BuildContext context) async {
    await _pickMedia(context, PickerAction.galleryVideo);
  }

  Future<void> _handleFileTap(BuildContext context) async {
    await _pickMedia(context, PickerAction.filePicker);
  }

  Future<void> _pickMedia(BuildContext context, PickerAction action) async {
    var createPostVM = Provider.of<CreatePostVMV2>(context, listen: false);
    await createPostVM.pickFile(action);
  }
}
