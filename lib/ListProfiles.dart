import 'package:flutter/material.dart';
import '../../UserProfile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListProfiles extends StatelessWidget {
  final List<UserProfile> userProfiles;
  ListProfiles({required this.userProfiles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of user profiles'),
      ),
      body: ListView.builder(
        itemCount: userProfiles.length,
        itemBuilder: (BuildContext context, int index) {
          UserProfile userProfile = userProfiles[index];
          return ListTile(
            title: Text(userProfile.displayName),
            subtitle: Text(userProfile.email),
            // Другие поля профиля...
          );
        },
      ),
    );
  }
}
