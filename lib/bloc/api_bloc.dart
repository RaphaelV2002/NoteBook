import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../UserProfile.dart';
import 'api_events.dart';
import 'api_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApiBloc extends Bloc<ApiEvents, ApiStates> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  ApiBloc() : super(MenuPageState()) {
    on<SuccessfulGoogleSignInEvent>(_signInWithGoogle);
    on<ListProfilesEvent>(_getListProfiles);

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

      // Получаем ссылку на коллекцию "userProfiles" из Firestore
      CollectionReference userProfiles =
          FirebaseFirestore.instance.collection('userProfile');

      // Добавляем новый документ в коллекцию "userProfile" с идентификатором, соответствующим UID пользователя
      await userProfiles.doc(userProfile.uid).set({
        'displayName': userProfile.displayName,
        'email': userProfile.email,
        'avatarUrl': userProfile.avatarUrl,
        // Другие поля профиля...
      });

      // Отправка объекта UserProfile в состояние SuccessfulGoogleSignInState
      emitter(SuccessfulGoogleSignInState(userProfile));
    } catch (error) {
      print(error);
      emitter(ErrorState());
    }
  }

  _getListProfiles(ListProfilesEvent event, Emitter<ApiStates> emitter) async {
    try {
      // Получение данных из Firestore
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('userProfile').get();
      List<UserProfile> profiles = querySnapshot.docs
          .map((doc) => UserProfile(
                uid: doc.id,
                displayName: doc['displayName'],
                email: doc['email'],
                avatarUrl: doc['avatarUrl'],
                // Другие поля профиля...
              ))
          .toList();

      // Отправка списка профилей в состояние ListProfilesState
      emitter(ListProfilesState(profiles));
    } catch (error) {
      print(error);
      emitter(ErrorState());
    }
  }
}
