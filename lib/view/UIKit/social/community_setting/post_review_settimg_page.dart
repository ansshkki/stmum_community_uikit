import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/viewmodel/community_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/configuration_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider

class PostReviewPage extends StatefulWidget {
  final AmityCommunity community;

  const PostReviewPage({super.key, required this.community});

  @override
  _PostReviewPageState createState() => _PostReviewPageState();
}

class _PostReviewPageState extends State<PostReviewPage> {
  bool isPostReviewEnabled = false;

  @override
  void initState() {
    // TODO: implement initState
    isPostReviewEnabled = widget.community.isPostReviewEnabled!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final communityVm =
        Provider.of<CommunityVM>(context, listen: false); // Get the ViewModel

    return Scaffold(
      backgroundColor:
          Provider.of<AmityUIConfiguration>(context).appColors.baseBackground,
      appBar: AppBar(
        title: Text(
          "post.view".tr(), //Post Review
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          // Section 1: Post Review Setting

          ListTile(
            title: Text(
              "post.approve".tr(), //Approve Member Posts
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xff292B32),
              ),
            ),
            subtitle: const Padding(
              padding: EdgeInsetsDirectional.only(top: 8.0),
              child: Text(
                '',
                //Posts by members have to be reviewed and approved by community moderators.
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff636878),
                ),
              ),
            ),
            trailing: Switch(
              activeColor:
                  Provider.of<AmityUIConfiguration>(context).primaryColor,
              value: isPostReviewEnabled,
              onChanged: (value) {
                setState(() {
                  isPostReviewEnabled = value;
                  communityVm.configPostReview(
                      communityId: widget.community.communityId!,
                      ispublic: widget.community.isPublic!,
                      isEnabled:
                          isPostReviewEnabled); // Call the function from the ViewModel when the switch is toggled
                });
              },
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
