import 'package:flutter/material.dart';
import 'package:zing/components/user_tile.dart';
import 'package:zing/services/auth/auth_services.dart';
import 'package:zing/services/chat/chat_service.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void _unblockBox(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text("Unblock User?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _chatService.unblockUser(userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User Unblocked!"),
                ),
              );
            },
            child: const Text("Unblock"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = _authService.getCurrentUser()!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text("BLOCKED USERS"),
        actions: [],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _chatService.getBlockedUsersStream(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error Loading users"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading..."));
          }

          final blockedUsers = snapshot.data ?? [];
          if (blockedUsers.isEmpty) {
            return const Center(child: Text("No Blocked users"));
          }

          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              final user = blockedUsers[index];
              return UserTile(
                text: user['email'],
                onTap: () => _unblockBox(
                  context,
                  user['uid'],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
