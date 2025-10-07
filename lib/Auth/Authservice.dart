import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

ValueNotifier<Authservice> authService = ValueNotifier(Authservice());

class Authservice {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
    required String username,
  }) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    await userCredential.user!.updateDisplayName(username);
    await userCredential.user!.reload();
    return userCredential;
  }

  Future<void> updateUsername({required String username}) async {
    await currentUser!.updateDisplayName(username);
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      const String webClientId =
          '461342906551-ec5238uf2mnpb7os44fvqs61hps6a8q9.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: kIsWeb ? webClientId : null,
        scopes: ['email', 'profile'],
        forceCodeForRefreshToken: true,
      );

      try {
        await googleSignIn.signOut();
      } catch (e) {
        print('Sign-out during initialization: $e');
      }

      GoogleSignInAccount? googleUser;

      if (kIsWeb) {
        googleUser = await googleSignIn.signIn();
      } else {
        googleUser = await googleSignIn.signIn();
      }

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: kIsWeb
            ? '461342906551-ec5238uf2mnpb7os44fvqs61hps6a8q9.apps.googleusercontent.com'
            : null,
        scopes: ['email', 'profile'],
      );

      await googleSignIn.signOut();
      await firebaseAuth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      await firebaseAuth.signOut();
    }
  }

  Future<void> disconnectGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: kIsWeb
            ? '461342906551-ec5238uf2mnpb7os44fvqs61hps6a8q9.apps.googleusercontent.com'
            : null,
        scopes: ['email', 'profile'],
      );

      await googleSignIn.disconnect();
    } catch (e) {
      print('Error disconnecting Google: $e');
    }
  }
}
