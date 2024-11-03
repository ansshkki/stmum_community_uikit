import 'dart:developer';
import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/components/alert_dialog.dart';
import 'package:amity_uikit_beta_service/viewmodel/create_postV2_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EditPostVM extends CreatePostVMV2 {
  List<UIKitFileSystem> editPostMedia = [];
  AmityPost? amityPost;
  int originalPostLength = 0;
  AmityDataType? postDataForEditMedia;

  void initForEditPost(AmityPost post) {
    print("initForEditPost");
    amityPost = post;
    if (amityPost!.children != null) {
      originalPostLength = amityPost!.children!.length;
      if (amityPost!.children!.isNotEmpty) {
        postDataForEditMedia = amityPost!.children![0].type;
      }
    }

    textEditingController.clear();
    editPostMedia.clear();

    var textData = post.data as TextData;
    textEditingController.text = textData.text ?? "";
    var children = post.children;
    if (children != null) {
      print(children.length);
      print(children[0].type);
      if (children[0].type == AmityDataType.IMAGE) {
        print(children[0].data!.fileId);
        editPostMedia = [];
        for (var child in children) {
          var uikitFile = UIKitFileSystem(
              postDataForEditMedie: child.data,
              status: FileStatus.complete,
              fileType: MyFileType.image,
              file: File(""));
          editPostMedia.add(uikitFile);
        }

        log("ImageData: $editPostMedia");
      } else if (children[0].type == AmityDataType.VIDEO) {
        var videoData = children[0].data as VideoData;

        editPostMedia = [];
        for (var child in children) {
          var uikitFile = UIKitFileSystem(
              postDataForEditMedie: child.data,
              status: FileStatus.complete,
              fileType: MyFileType.image,
              file: File(""));
          editPostMedia.add(uikitFile);
        }
      } else if (children[0].type == AmityDataType.FILE) {
        var fileData = children[0].data as FileData;
        var fileName = fileData.fileInfo.fileName!;
        editPostMedia = [];
        for (var child in children) {
          var uikitFile = UIKitFileSystem(
              postDataForEditMedie: child.data,
              status: FileStatus.complete,
              progress: -1,
              fileType: MyFileType.file,
              file: File(fileName));
          editPostMedia.add(uikitFile);
        }
      }
    }

    textEditingController.text = (post.data as TextData).text ?? "";
  }

  Future<void> editPost(
      {required BuildContext context, Function? callback}) async {
    var builder = amityPost!.edit().text(textEditingController.text);

    if (editPostMedia.length != originalPostLength) {
      print("Children Length is not equal");
      if (editPostMedia.isNotEmpty) {
        var childPost = amityPost!.children![0];
        var postType = childPost.type;
        print(postType);
        if (postType == AmityDataType.IMAGE) {
          var children = amityPost!.children;
          var images =
              children!.map((e) => e.data!.fileInfo as AmityImage).toList();
          builder = builder.image(images);
        } else if (postType == AmityDataType.VIDEO) {
          var children = amityPost!.children;
          var videos =
              children!.map((e) => e.data!.fileInfo as AmityVideo).toList();
          builder = builder.video(videos);
        } else if (postType == AmityDataType.FILE) {
          var children = amityPost!.children;
          var files =
              children!.map((e) => e.data!.fileInfo as AmityFile).toList();
          builder = builder.file(files);
        }
      } else {
        print("Empty Children");

        print(postDataForEditMedia);
        if (postDataForEditMedia == AmityDataType.IMAGE) {
          builder = builder.image([]);
        } else if (postDataForEditMedia == AmityDataType.VIDEO) {
          builder = builder.video([]);
        } else if (postDataForEditMedia == AmityDataType.FILE) {
          builder = builder.file([]);
        }
      }
    }
    builder.build().update().then((value) {
      notifyListeners();
      callback!();
    }).onError((error, stackTrace) async {
      await AmityDialog().showAlertErrorDialog(
          title: "repo.unknown_error".tr(), message: error.toString()); //Error!
    });
  }

  void deselectFileAt(int index) {
    editPostMedia.removeAt(index);
    amityPost!.children!.removeAt(index);
    notifyListeners();
  }
}
