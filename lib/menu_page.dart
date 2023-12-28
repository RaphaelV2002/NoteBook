import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unihelp/bloc/api_bloc.dart';
import 'package:unihelp/bloc/api_events.dart';
import 'package:unihelp/bloc/api_states.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'UserProfile.dart';

class menuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiBloc, ApiStates>(
      builder: (context, state) {
        return Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Вызов события SuccessfulGoogleSignInEvent с передачей объекта UserProfile
                UserProfile userProfile = UserProfile(
                    uid: '', displayName: '', email: '', avatarUrl: '');
                BlocProvider.of<ApiBloc>(context)
                    .add(SuccessfulGoogleSignInEvent(userProfile: userProfile));
              },
              child: Text('Sign in with Google'),
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<ApiBloc>(context).add(ListProfilesEvent());
              },
              child: Text('List Profiles'),
            ),
          ],
        );
      },
    );
  }
}
