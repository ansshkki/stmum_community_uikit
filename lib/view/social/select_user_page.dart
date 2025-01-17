import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/viewmodel/configuration_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/user_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatefulWidget {
  final List<AmityUser>? preSelectMember;
  final Function(List<AmityUser>)? onDonePressed; // Add this line

  const UserListPage({
    super.key,
    this.preSelectMember,
    this.onDonePressed,
  }); // Modify this line

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  void initState() {
    if (widget.preSelectMember != null) {
      log(widget.preSelectMember.toString());
      Provider.of<UserVM>(context, listen: false)
          .setSelectedUsersList(widget.preSelectMember!);
      Provider.of<UserVM>(context, listen: false).initUserList("");
    }
    super.initState();
  }

//   @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<AmityUIConfiguration>(context).appColors.baseBackground,
      appBar: AppBar(
        backgroundColor:
            Provider.of<AmityUIConfiguration>(context).appColors.baseBackground,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "user.select_member".tr(), //Select member
          style: Provider.of<AmityUIConfiguration>(context)
              .titleTextStyle
              .copyWith(
                  color: Provider.of<AmityUIConfiguration>(context)
                      .appColors
                      .base),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(
                  Provider.of<UserVM>(context, listen: false)
                      .selectedCommunityUsers),
            child: TextButton(
              onPressed: () {
                if (widget.onDonePressed != null) {
                  widget.onDonePressed!(
                      Provider.of<UserVM>(context, listen: false)
                          .selectedCommunityUsers);
                }
                Navigator.of(context).pop();
              },
              child: Text("external.done".tr(), //Done
                  style: TextStyle(
                      color: Provider.of<AmityUIConfiguration>(context,
                              listen: false)
                          .primaryColor)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.all(
                    10.0), // Adjust this value based on your needs
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    hintText: "search.search".tr(),
                    //Search
                    filled: true,
                    contentPadding:
                        const EdgeInsetsDirectional.symmetric(vertical: 0),
                    fillColor: Colors.grey[3],
                    focusColor: Colors.white,
                    // Removes focus highlight
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded edges
                      borderSide: BorderSide.none, // Removes default underline
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Rounded edges when focused
                      borderSide:
                          BorderSide.none, // Removes underline when focused
                    ),
                  ),
                  onChanged: (value) {
                    Provider.of<UserVM>(context, listen: false)
                        .searchWithKeyword(value);
                  },
                ),
              ),
              Provider.of<UserVM>(context).selectedCommunityUsers.isEmpty
                  ? const SizedBox()
                  : SizedBox(
                      height: 80, // Adjust height as needed
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: Provider.of<UserVM>(context)
                            .selectedCommunityUsers
                            .length,
                        itemBuilder: (context, index) {
                          var user = Provider.of<UserVM>(context)
                              .selectedCommunityUsers[index];
                          return Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 5, 0, 5),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Provider.of<UserVM>(context, listen: false)
                                        .toggleUserSelection(user);
                                  },
                                  child: Stack(
                                    alignment: AlignmentDirectional.topEnd,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            Provider.of<AmityUIConfiguration>(
                                                    context)
                                                .appColors
                                                .primaryShade3,
                                        backgroundImage: user.avatarUrl == null
                                            ? null
                                            : NetworkImage(user.avatarUrl!),
                                        child: user.avatarUrl != null
                                            ? null
                                            : const Icon(Icons.person,
                                                size: 25,
                                                color: Colors
                                                    .white), // Adjust to use the correct attribute for avatar URL
                                      ),
                                      PositionedDirectional(
                                        end: 0,
                                        child: InkWell(
                                            onTap: () {
                                              // Handle the logic to remove the user when "X" is tapped
                                            },
                                            child: CircleAvatar(
                                              radius: 7,
                                              backgroundColor: Colors.black
                                                  .withOpacity(0.5)
                                                  .withOpacity(0.5),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.close_rounded,
                                                  // "X" mark
                                                  size: 10,

                                                  color: Colors.white,
                                                ),
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // Space between avatar and name
                                SizedBox(
                                  width: 70,
                                  child: Center(
                                    child: Text(
                                      user.displayName ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color:
                                              Provider.of<AmityUIConfiguration>(
                                                      context)
                                                  .appColors
                                                  .base),
                                    ),
                                  ),
                                )
                                // Display user's name, replace 'name' with the appropriate attribute for the user's name
                              ],
                            ),
                          );
                        },
                      )),
              Expanded(
                  child: CustomScrollView(
                controller: Provider.of<UserVM>(context).scrollController,
                slivers: Provider.of<UserVM>(context)
                    .listWithHeaders
                    .map<Widget>((item) {
                  return SliverStickyHeader(
                    header: Container(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 5, 0, 5),
                      color: Provider.of<AmityUIConfiguration>(context)
                          .appColors
                          .baseShade4,
                      child: Text(
                        item.keys.first,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final AmityUser user = item.values.first[index];
                          return Column(
                            children: [
                              ListTile(
                                dense: true,
                                contentPadding:
                                    const EdgeInsetsDirectional.symmetric(
                                        vertical: 4.0, horizontal: 16.0),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Provider.of<AmityUIConfiguration>(context)
                                          .appColors
                                          .primaryShade3,
                                  backgroundImage: user.avatarUrl == null
                                      ? null
                                      : NetworkImage(user.avatarUrl!),
                                  child: user.avatarUrl != null
                                      ? null
                                      : const Icon(Icons.person,
                                          size: 25,
                                          color: Colors
                                              .white), // Adjust to use the correct attribute for avatar URL
                                ),

                                title: Text(
                                  user.displayName ?? "external.empty_name".tr(),
                                  //No name
                                  style: TextStyle(
                                      color: Provider.of<AmityUIConfiguration>(
                                              context)
                                          .appColors
                                          .base),
                                ),
                                // Fallback for a null displayName
                                trailing: Checkbox(
                                  activeColor:
                                      Provider.of<AmityUIConfiguration>(context,
                                              listen: false)
                                          .primaryColor,
                                  // Set the active color to primary color
                                  shape: const CircleBorder(),
                                  value: Provider.of<UserVM>(context)
                                      .selectedCommunityUsers
                                      .any((selectedUser) =>
                                          selectedUser.id == user.id),
                                  onChanged: (bool? value) {
                                    Provider.of<UserVM>(context, listen: false)
                                        .toggleUserSelection(user);
                                  },
                                ),
                                onTap: () {
                                  Provider.of<UserVM>(context, listen: false)
                                      .toggleUserSelection(user);
                                },
                              ),
                              const Divider()
                            ],
                          );
                        },
                        childCount: item.values.first.length,
                      ),
                    ),
                  );
                }).toList(),
              )),
            ],
          )),
        ],
      ),
    );
  }
}
