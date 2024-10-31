import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../components/alert_dialog.dart';

class AmityVM extends ChangeNotifier {
  AmityUser? currentAmityUser;
  String? accessToken;
  String? generalAccessToken;

  Future<void> login({
    required String userID,
    required String generalAccessToken,
    String? displayName,
    String? authToken,
    String? accessToken,
  }) async {
    this.accessToken = accessToken;
    this.generalAccessToken = generalAccessToken;
    log("login with $userID");
    if (authToken == null) {
      log("authToken == null");
      if (displayName != null) {
        await AmityCoreClient.login(userID)
            .displayName(displayName)
            .submit()
            .then((value) async {
          log("success");

          currentAmityUser = value;
          notifyListeners();
        }).catchError((error, stackTrace) async {
          log("error");

          log(error.toString());
          //        await AmityDialog()
          //            .showAlertErrorDialog(title: "Error!", message: error.toString());
        });
      } else {
        await AmityCoreClient.login(userID).submit().then((value) async {
          log("success");

          currentAmityUser = value;
          notifyListeners();
        }).catchError((error, stackTrace) async {
          log("error");

          log(error.toString());
          //        await AmityDialog()
          //            .showAlertErrorDialog(title: "Error!", message: error.toString());
        });
      }
    } else {
      log("authToken is provided");
      if (displayName != null) {
        log("displayName is provided");
        await AmityCoreClient.login(userID)
            .authToken(authToken)
            .displayName(displayName)
            .submit()
            .then((value) async {
          log("success");
          print("current amity user :$value");
          currentAmityUser = value;
          notifyListeners();
        }).catchError((error, stackTrace) async {
          log("error");

          log(error.toString());
          //        await AmityDialog()
          //            .showAlertErrorDialog(title: "Error!", message: error.toString());
        });
      } else {
        log("displayName is not provided");
        await AmityCoreClient.login(userID)
            .authToken(authToken)
            .submit()
            .then((value) async {
          log("success");
          print("current amity user :$value");

          currentAmityUser = value;
          notifyListeners();
        }).catchError((error, stackTrace) async {
          print("error");

          log(error.toString());
          //        await AmityDialog()
          //            .showAlertErrorDialog(title: "Error!", message: error.toString());
        });
      }
    }
  }

  Future<void> refreshCurrentUserData() async {
    if (currentAmityUser != null) {
      await AmityCoreClient.newUserRepository()
          .getUser(currentAmityUser!.userId!)
          .then((user) {
        currentAmityUser = user;
        notifyListeners();
      }).onError((error, stackTrace) async {
        log(error.toString());
        await AmityDialog().showAlertErrorDialog(
            title: "repo.unknown_error".tr(), message: error.toString()); //Error!
      });
    }
  }

  late Function(AmityPost) onShareButtonPressed;
  void setShareButtonFunction(
      Function(AmityPost) onShareButtonPressed) {} // Callback function)
}
