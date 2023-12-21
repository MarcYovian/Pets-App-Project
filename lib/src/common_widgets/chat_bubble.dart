import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets_shop/src/utils/my_utils.dart';

class ChatBubble extends StatefulWidget {
  final Map data;
  const ChatBubble({super.key, required this.data});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    BoxDecoration boxDecoration = BoxDecoration(
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(10),
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      color: Colors.grey.shade500,
    );

    var crossAxis = CrossAxisAlignment.start;

    if (widget.data['senderId'] == _firebaseAuth.currentUser!.uid) {
      boxDecoration = BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Colors.orange.shade300,
      );
      crossAxis = CrossAxisAlignment.end;
    }
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: boxDecoration,
      constraints: const BoxConstraints(
        minWidth: 100,
      ),
      child: Column(
        crossAxisAlignment: crossAxis,
        children: [
          Text(widget.data['message']),
          Text(
            formatTimestamp(widget.data['timestamp'].toDate()),
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
