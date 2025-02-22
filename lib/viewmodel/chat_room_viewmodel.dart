import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/components/alert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChatRoomVM extends ChangeNotifier {
  AmityChannel? channel;
  TextEditingController textEditingController = TextEditingController();
  final amityMessage = <AmityMessage>[];
  // late PagingController<AmityMessage> messageController;
  final scrollController = ScrollController();
  // Future<void> initSingleChannel(
  //   String channelId,
  // ) async {
  //   await AmityChatClient.newChannelRepository()
  //       .getChannel(channelId)
  //       .then((value) {
  //     channel = value;

  //     notifyListeners();
  //   }).onError((error, stackTrace) async {
  //     log("error from channel");
  //     await AmityDialog().showAlertErrorDialog(
  //         title: "Error!", message: messageController.error.toString());
  //   });

  // Query for message type
  // messageController = PagingController(
  //   pageFuture: (token) => AmityChatClient.newMessageRepository()
  //       .getMessages(channelId)
  //       .getPagingData(token: token, limit: 20),
  //   pageSize: 20,
  // )..addListener(
  //     () async {
  //       if (messageController.error == null) {
  //         print("new update");
  //         amitymessage.clear();
  //         amitymessage.addAll(messageController.loadedItems);
  //         // listenToMessages(channelId);
  //         notifyListeners();
  //       } else {
  //         // Error on pagination controller
  //         log("error from messages");
  //         await AmityDialog().showAlertErrorDialog(
  //             title: "Error!", message: messageController.error.toString());
  //       }
  //     },
  //   );

  // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //   messageController.fetchNextPage();
  // });

  // messageController.addListener(loadnextpage);
  // }

  late MessageLiveCollection messageLiveCollection;
  // void listenToMessages(String channelId) {
  //   messageLiveCollection = AmityChatClient.newMessageRepository()
  //       .getMessages(channelId)
  //       .getLiveCollection(pageSize: 20);

  //   messageLiveCollection!.getStreamController().stream.listen((event) {
  //     print("EVENT:${event.length}");
  //     notifyListeners();
  //   });
  // }

  // void loadnextpage() {
  //   if ((scrollcontroller.position.pixels ==
  //           scrollcontroller.position.maxScrollExtent) &&
  //       messageController.hasMoreItems) {
  //     messageController.fetchNextPage();
  //   }
  // }

  Future<void> initSingleChannel(
    String channelId,
  ) async {
    await AmityChatClient.newChannelRepository()
        .getChannel(channelId)
        .then((value) {
      channel = value;

      notifyListeners();
    }).onError((error, stackTrace) async {
      log("error from channel");
      await AmityDialog()
          .showAlertErrorDialog(title: "repo.unknown_error".tr(), message: error.toString()); //Error!
    });
    messageLiveCollection = AmityChatClient.newMessageRepository()
        .getMessages(channelId)
        .getLiveCollection(pageSize: 20);

    messageLiveCollection.getStreamController().stream.listen((event) {
      print("evemt triggered");
      print("event length: ${event.length}");
      amityMessage.clear();

      amityMessage.addAll(event.reversed);
      notifyListeners();
    });

    messageLiveCollection.loadNext();

    scrollController.addListener(paginationListener);
  }

  void paginationListener() {
    if ((scrollController.position.pixels >=
            (scrollController.position.maxScrollExtent - 100)) &&
        messageLiveCollection.hasNextPage()) {
      messageLiveCollection.loadNext();
    }
  }

  Future<void> sendMessage() async {
    AmityChatClient.newMessageRepository()
        .createMessage(channel!.channelId!)
        .text(textEditingController.text)
        .send()
        .then((value) {
      textEditingController.clear();
    }).onError((error, stackTrace) async {
      // Error on pagination controller
      log("error from send message");
      await AmityDialog()
          .showAlertErrorDialog(title: "repo.unknown_error".tr(), message: error.toString()); //Error!
    });
  }

  void scrollToBottom() {
    log("scrollToBottom ");
    // scrollController!.animateTo(
    //   1000000,
    //   curve: Curves.easeOut,
    //   duration: const Duration(milliseconds: 500),
    // );
    scrollController.jumpTo(0);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }
}
