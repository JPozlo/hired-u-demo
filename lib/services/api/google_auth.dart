import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication{
    static final _googleSignIn = GoogleSignIn();
    static Future<GoogleSignInAccount?> googleLogin() =>  _googleSignIn.signIn();
    static Future<GoogleSignInAccount?> googleLogout() =>  _googleSignIn.disconnect();
}