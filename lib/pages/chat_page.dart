import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zing/components/chat_bubble.dart';
import 'package:zing/components/custom_textfeild.dart';
import 'package:zing/services/auth/auth_services.dart';
import 'package:zing/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Message Controller
  final TextEditingController _messageController = TextEditingController();

  // Chat & Auth Services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  FocusNode chatFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Add Listener to FocusNode
    chatFocusNode.addListener(() {
      if (chatFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
  }

  @override
  void dispose() {
    chatFocusNode.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  // Method to SendMessage
  void sendMessage() async {
    // Send message only if TextField != Empty
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverId, _messageController.text);
      scrollDown();
    }

    // Clear TextController after Message has been sent
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          // Display All Messages
          Expanded(
            child: _buildMessageList(),
          ),

          // Display TextInput
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverId, senderId),
      builder: (context, snapshot) {
        // Error Handling
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // Loading State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        // Return ListView
        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // Messages by CurrentUser -> Align RightSide

    // is CurrentUser the sender?
    bool isCurrentUser = data['senderId'] == _authService.getCurrentUser()!.uid;

    // Alignment
    var customAlignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: customAlignment,
      child: ChatBubble(
        message: data["message"],
        messageId: doc.id,
        isCurrentUser: isCurrentUser,
        userId: data['senderId'],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16), // Adjusted padding
      child: Row(
        children: [
          // TextField
          Expanded(
            child: CustomTextField(
              hintText: "Enter Message",
              obscureText: false,
              controller: _messageController,
              focusNode: chatFocusNode,
            ),
          ),

          // SendButton
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
