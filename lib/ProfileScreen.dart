import 'package:flutter/material.dart';
import '../../UserProfile.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatelessWidget {
  final UserProfile userProfile;

  ProfileScreen({required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${userProfile.displayName}'),
          Text('Email: ${userProfile.email}'),
          // Другие поля профиля...
        ],
      ),
    );
  }
}
