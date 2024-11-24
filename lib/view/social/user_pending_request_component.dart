import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/viewmodel/pending_request_viewmodel.dart';
import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/custom_user_avatar.dart';
import '../../viewmodel/configuration_viewmodel.dart';

class AmityPendingScreen extends StatefulWidget {
  const AmityPendingScreen({super.key});

  @override
  State<AmityPendingScreen> createState() => _AmityPendingScreenState();
}

class _AmityPendingScreenState extends State<AmityPendingScreen> {
  @override
  void initState() {
    Provider.of<PendingVM>(context, listen: false).getMyPendingRequestList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PendingVM>(builder: (context, vm, _) {
      final theme = Theme.of(context);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "user.follow".tr(), //Follow Request
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 24),
          ),
        ),
        body: FadedSlideAnimation(
          beginOffset: const Offset(0, 0.3),
          endOffset: const Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
          child: RefreshIndicator(
            onRefresh: () async {
              await vm.getMyPendingRequestList();
            },
            child: ListView.builder(
              controller: vm.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: vm.pendingRequestList.length,
              itemBuilder: (context, index) {
                return StreamBuilder<AmityFollowRelationship>(
                    // key: Key(vm.getFollowRelationships[index].sourceUserId! +
                    //     vm.getFollowRelationships[index].sourceUserId!),
                    stream: vm.pendingRequestList[index].listen.stream,
                    initialData: vm.pendingRequestList[index],
                    builder: (context, snapshot) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.all(8.0),
                        child: Row(
                          children: [
                            getAvatarImage(vm.pendingRequestList[index]
                                .sourceUser!.avatarUrl),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data?.sourceUser!.displayName ??
                                          "external.empty_name".tr(),
                                      //display name not found
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    Text(
                                      snapshot.data?.sourceUser!.userId ??
                                          "external.empty_name".tr(),
                                      //displayname not found
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                Provider.of<AmityUIConfiguration>(context)
                                    .primaryColor,
                              )),
                              onPressed: () {
                                vm.acceptFollowRequest(
                                    snapshot.data!.sourceUser!.userId!, index);
                              },
                              child: const Text("external.accept"), //accept
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.grey)),
                              onPressed: () {
                                vm.declineFollowRequest(
                                    snapshot.data!.sourceUser!.userId!, index);
                              },
                              child: Text("external.reject".tr()), //reject
                            ),
                          ],
                        ),
                      );
                      // return Text(snapshot.data!.status.toString());
                    });
              },
            ),
          ),
        ),
      );
    });
  }
}
