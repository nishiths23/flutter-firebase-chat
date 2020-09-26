import 'package:firebase_auth/firebase_auth.dart';

///
/// Represents errors
///
class Error {
  static const SomethingWentWrongErrorCode = 'SOMETHING_WENT_WRONG';
  const Error({this.code, this.message});
  final String code;
  final String message;
}

///
/// Class containing authentication related members
///
class Auth {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  ///
  /// Sign in user with Google id token and access token
  ///
  static Future<String> googleSignIn(String idToken, String accessToken) async {
    User user;
    Error authError;
    try {
      final result = await _auth.signInWithCredential(GoogleAuthProvider.credential(idToken: idToken, accessToken: accessToken));
      user = result.user;
    } catch (error) {
      authError = _getErrorMessage(authError);
    }
    if (authError != null) {
      return Future.error(authError);
    }
    if (user == null) {
      return Future.error(Error(code: Error.SomethingWentWrongErrorCode, message: 'Something went wrong'));
    }
    return user.uid;
  }

  ///
  /// Sign in user with email and password
  ///
  static Future<String> signIn(String email, String password) async {
    User user;
    Error authError;
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      user = result.user;
    } catch (error) {
      authError = _getErrorMessage(authError);
    }
    if (authError != null) {
      return Future.error(authError);
    }
    if (user == null) {
      return Future.error(Error(code: Error.SomethingWentWrongErrorCode, message: 'Something went wrong'));
    }
    return user.uid;
  }

  static Error _getErrorMessage(dynamic error) {
    String errorMessage;
    switch (error?.code ?? '') {
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Your email address appears to be malformed.";
        break;
      case "ERROR_WRONG_PASSWORD":
        errorMessage = "Your password is wrong.";
        break;
      case "ERROR_USER_NOT_FOUND":
        errorMessage = "User with this email doesn't exist.";
        break;
      case "ERROR_USER_DISABLED":
        errorMessage = "User with this email has been disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        errorMessage = "Too many requests. Try again later.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }
    return Error(code: error?.code ?? 'SOMETHING_WENT_WRONG', message: errorMessage);
  }
}
