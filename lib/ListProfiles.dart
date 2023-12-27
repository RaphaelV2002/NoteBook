import 'package:flutter/material.dart';
import '../../UserProfile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListProfiles extends StatelessWidget {
  final CollectionReference userProfiles =
      FirebaseFirestore.instance.collection('UserProfiles');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of user profiles'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userProfiles.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['displayName']),
                subtitle: Text(data['email']),
                // Другие поля профиля...
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
