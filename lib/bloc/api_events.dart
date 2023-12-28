import 'package:google_sign_in/google_sign_in.dart';
import 'package:unihelp/bloc/api_states.dart';
import '../UserProfile.dart';

abstract class ApiEvents {}

class CreateAccountEvent extends ApiEvents {
  final String username;
  final String email;
  final String password;

  CreateAccountEvent({
    required this.username,
    required this.email,
    required this.password,
  });
}

class SuccessfulGoogleSignInEvent extends ApiEvents {
  final UserProfile userProfile;

  SuccessfulGoogleSignInEvent({
    required this.userProfile,
  });
}

class ListProfilesEvent extends ApiEvents {}

class MenuPageEvent extends ApiEvents {}
