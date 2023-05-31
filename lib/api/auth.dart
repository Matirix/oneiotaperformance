import 'package:firebase_auth/firebase_auth.dart';
import 'package:one_iota_mobile_app/api/persistent_data.dart';

import '../models/tokens_model.dart';
import 'one_iota_api.dart';

///This class has methods related to account login/creation/logout
class Auth {
  final String apiURL = "https://staging.oneiotaperformance.com/api/v1";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static String? refreshToken;
  static Future<IdToken?>? futureToken;
  static IdToken? idToken;
  static dynamic errorMessage;
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      CustomToken customToken = await OneIotaAuth()
          .fetchCustomTokenWithCreds(email: email, password: password);
      UserCredential userCred =
          await Auth()._firebaseAuth.signInWithCustomToken(customToken.id);
      refreshToken = userCred.user?.refreshToken;
      futureToken = OneIotaAuth().fetchIdToken(customToken: customToken.id);
      idToken = await futureToken;
      PersistentData.futureAccount =
          OneIotaAuth().fetchAccountInfo(token: idToken);
    } on Exception catch (e) {
      errorMessage = e;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
