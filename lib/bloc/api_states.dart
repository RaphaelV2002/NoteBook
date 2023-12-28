import 'package:google_sign_in/google_sign_in.dart';
import '../UserProfile.dart';

abstract class ApiStates {}

class MenuPageState extends ApiStates {}

class LoadingState extends ApiStates {}

class ErrorState extends ApiStates {
  // String error;
  //
  // ErrorState(this.error);
}

class SuccessfulGoogleSignInState extends ApiStates {
  final UserProfile userProfile;

  SuccessfulGoogleSignInState(this.userProfile);
}

class ListProfilesState extends ApiStates {
  final List<UserProfile> profiles;

  ListProfilesState(this.profiles);
}
