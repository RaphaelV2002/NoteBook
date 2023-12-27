import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unihelp/bloc/api_bloc.dart';
import 'package:unihelp/bloc/api_events.dart';
import 'package:unihelp/bloc/api_states.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'UserProfile.dart';

class CreateAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiBloc, ApiStates>(
      builder: (context, state) {
        if (state is LoadingState) {
          return CircularProgressIndicator();
        } else if (state is ErrorState) {
          return Text('An error occurred.');
        } else if (state is SuccessfulGoogleSignInState) {
          // Обработка успешного входа через Google
          return Text(
              'Successfully signed in with Google: ${state.userProfile.displayName}');
        } else {
          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Вызов метода handleGoogleSignIn при нажатии кнопки "Sign in with Google"
                  handleGoogleSignIn(context);
                },
                child: Text('Sign in with Google'),
              ),
            ],
          );
        }
      },
    );
  }

  Future<void> handleGoogleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        // Получение данных пользователя из Google
        String displayName = googleUser.displayName ?? '';
        String email = googleUser.email ?? '';
        String avatarUrl = googleUser.photoUrl ?? '';

        // Создание профиля пользователя
        UserProfile userProfile = UserProfile(
          uid: googleUser.id,
          displayName: displayName,
          email: email,
          avatarUrl: avatarUrl,
        );

        // Отправка события SuccessfulGoogleSignInEvent в блок ApiBloc
        BlocProvider.of<ApiBloc>(context).add(SuccessfulGoogleSignInEvent(userProfile: userProfile));
      }
    } catch (error) {
      // Обработка ошибок
      print('Ошибка входа через Google: $error');
    }
  }
}
