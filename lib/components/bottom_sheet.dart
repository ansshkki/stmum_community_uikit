import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/viewmodel/user_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showOptionsBottomSheet(
  BuildContext context,
  AmityUser user,
) {
  showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsetsDirectional.only(
              top: 20, bottom: 20 + MediaQuery.paddingOf(bc).bottom),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                children: [
                  user.isFlaggedByMe
                      ? ListTile(
                          title: Text("report.unReport_user".tr()),
                          onTap: () {
                            Provider.of<UserVM>(context, listen: false)
                                .reportOrUnReportUser(user);
                            Navigator.pop(context);
                          },
                        )
                      : ListTile(
                          title: Text("report.report_user".tr()),
                          onTap: () {
                            Provider.of<UserVM>(context, listen: false)
                                .reportOrUnReportUser(user);
                            Navigator.pop(context);
                          },
                        ),
                ],
              ),
            ],
          ),
        );
      });
}
