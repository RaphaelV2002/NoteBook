import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../UserProfile.dart';
import 'api_events.dart';
import 'api_states.dart';

class ApiBloc extends Bloc<ApiEvents, ApiStates> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  ApiBloc() : super(InitialState()) {
    on<SuccessfulGoogleSignInEvent>(_signInWithGoogle);
  }

  _signInWithGoogle(
      SuccessfulGoogleSignInEvent event, Emitter<ApiStates> emitter) async {
    try {
      emitter(LoadingState());
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Создание объекта UserProfile
      UserProfile userProfile = UserProfile(
        uid: googleUser.id,
        displayName: googleUser.displayName ?? '',
        email: googleUser.email ?? '',
        avatarUrl: googleUser.photoUrl ?? '',
      );

      // Отправка объекта UserProfile в состояние SuccessfulGoogleSignInState
      emitter(SuccessfulGoogleSignInState(userProfile));
    } catch (error) {
      print(error);
      emitter(ErrorState());
    }
  }
}
