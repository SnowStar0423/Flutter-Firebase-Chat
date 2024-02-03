import 'package:chat_app/model/chat_message.dart';
import 'package:chat_app/core/utils/app_util.dart';
import 'package:chat_app/view/widgets/custom_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoomBox extends StatelessWidget {
  ChatRoomBox({super.key, required this.message});
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: buildPeerChat(),
    );
  }

  buildPeerChat() {
    return message.idFrom == _firebaseAuth.currentUser!.uid
        ? _MyMessage(message: message)
        : _PeerMessage(message: message);
  }
}

class _MyMessage extends StatelessWidget {
  const _MyMessage({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 300),
          padding: const EdgeInsets.fromLTRB(15, 7, 15, 10),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: message.content,
                      style: const TextStyle(
                          fontSize: 15, color: Colors.black, height: 1.5),
                    ),
                    const TextSpan(
                        text: " • ", style: TextStyle(color: Colors.grey)),
                    TextSpan(
                      text: AppUtil.formatTimeAgo(
                          DateTime.parse(message.timestamp)),
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class _PeerMessage extends StatelessWidget {
  const _PeerMessage({required this.message});
  final ChatMessage message;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 280),
          padding: const EdgeInsets.fromLTRB(15, 7, 15, 10),
          decoration: BoxDecoration(
            // color: Color(Random().nextInt(0xffffffff)).withAlpha(20),
            color: Colors.red.shade50,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.type == ChatMessageType.image)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: CustomImage(
                    message.imageUrl ??
                        "https://t3.ftcdn.net/jpg/05/52/37/18/360_F_552371867_LkVmqMEChRhMMHDQ2drOS8cwhAWehgVc.jpg",
                    imageType: ImageType.network,
                    radius: 10,
                  ),
                ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: message.content,
                      style: const TextStyle(
                          fontSize: 15, color: Colors.black, height: 1.5),
                    ),
                    const TextSpan(
                        text: "  ", style: TextStyle(color: Colors.grey)),
                    TextSpan(
                      text: AppUtil.formatTimeAgo(
                          DateTime.parse(message.timestamp)),
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
