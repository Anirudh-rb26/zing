import 'package:flutter/material.dart';
import 'package:zing/services/chat/chat_service.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String messageId;
  final bool isCurrentUser;
  final String userId;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userId,
  });

  void showOptions(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              // Report Message
              ListTile(
                leading: const Icon(Icons.flag_rounded),
                title: const Text("Report Message"),
                onTap: () {
                  Navigator.pop(context);
                  _reportContent(context, messageId, userId);
                },
              ),

              // Block User
              ListTile(
                leading: const Icon(Icons.block_rounded),
                title: const Text("Block User"),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(context, userId);
                },
              ),

              // Cancel
              ListTile(
                leading: const Icon(Icons.cancel_rounded),
                title: const Text("Cancel"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _reportContent(BuildContext context, String messageId, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Report Message"),
        content: const Text(
          "This message will be recorded, and a report will sent.",
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          // Confirm Button
          TextButton(
            onPressed: () {
              ChatService().reportUser(messageId, userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Message Reported"),
                ),
              );
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  void _blockUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Block User"),
        content: const Text(
          "Are you sure you want to Block user? You can Unblock later.",
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          // Confirm Button
          TextButton(
            onPressed: () {
              ChatService().blockUser(userId);

              Navigator.pop(context);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User Blocked"),
                ),
              );
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // Only Report other users
        if (!isCurrentUser) {
          showOptions(context, messageId, userId);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              isCurrentUser ? const Color(0xFF34C759) : const Color(0xFF007AFF),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isCurrentUser ? const Radius.circular(12) : Radius.zero,
            bottomRight:
                isCurrentUser ? Radius.zero : const Radius.circular(12),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 5,
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
