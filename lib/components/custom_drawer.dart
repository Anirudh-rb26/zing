import 'package:flutter/material.dart';
import 'package:zing/auth/auth_services.dart';
import 'package:zing/pages/settings_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void logout() {
    final auth = AuthServices();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Half
          Column(
            children: [
              // Logo
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                ),
              ),

              // Home List Tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("H O M E"),
                  leading: const Icon(Icons.home_rounded),
                  onTap: () {
                    // Pop Drawer
                    Navigator.pop(context);
                  },
                ),
              ),

              // Settings List Tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("S E T T I N G S"),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    // Navigate to Settings Page
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Bottom Half
          // Logout List Tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: ListTile(
              title: const Text("L O G O U T"),
              leading: const Icon(Icons.logout_rounded),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
