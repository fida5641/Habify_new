import 'package:flutter/material.dart';
import 'package:habify/viewmodels/profile_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileViewModel viewModel = ProfileViewModel();

  ProfileScreen({super.key, required String username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.grey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ValueListenableBuilder<String>(
                valueListenable: viewModel.username,
                builder: (context, username, _) {
                  return Text(
                    "Hello, $username!",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.white),
              title: ValueListenableBuilder<String>(
                valueListenable: viewModel.email,
                builder: (context, email, _) {
                  return Text(
                    email,
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () => viewModel.logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
