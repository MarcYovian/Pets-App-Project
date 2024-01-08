import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets_shop/src/common_widgets/chat_bubble.dart';
import 'package:pets_shop/src/common_widgets/my_text_field.dart';
import 'package:pets_shop/src/features/chat/data/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String receivedUserEmail;
  final String receiverUserId;
  const ChatScreen({
    super.key,
    required this.receivedUserEmail,
    required this.receiverUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // only send the message if the message is not empty
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserId, _messageController.text);
      // clear the message controller after sending the message

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receivedUserEmail),
      ),
      body: Column(
        children: [
          // messages
          Expanded(
            child: _buildMessageList(),
          ),

          // user input
          _buildMessageInput(),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserId, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            "Error: ${snapshot.error}",
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Waiting");
        }

        print(snapshot);

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ChatBubble(data: data),
          ],
        ),
      ),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        // textfield
        Expanded(
          child: MyTextField(
            controller: _messageController,
            hintText: "enter message",
            obscureText: false,
            keyboardType: TextInputType.text,
          ),
        ),

        // sending button
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(
            Icons.send,
            size: 50,
          ),
        )
      ],
    );
  }
}
