import 'package:google_sign_in/google_sign_in.dart';

class SignInWithGoogle{
  GoogleSignInAccount? googleUser;
  late String name;
  late String email;
  late String urlphoto;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly', // Thêm openid vào danh sách scope
      'openid',
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/userinfo.email',
    ],
  );

  void initGoogleLogin() {
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      googleUser = account;

      if (googleUser != null) {
        // Perform your action
      }
      googleSignIn.signInSilently();
    });
  }

  Future<String> googleLogin() async {
     
    final googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    return googleAuth.accessToken.toString();
  }

  Future<void> signOut() async {
    this.googleSignIn.disconnect();
  }
}
