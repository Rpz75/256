import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter256/data/db/remote/response.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthSource {
  FirebaseAuth instance = FirebaseAuth.instance;

  Future<Response<UserCredential>> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await instance.signInWithEmailAndPassword(
          email: email, password: password);
      return Response.success(userCredential);
    } catch (e) {
      return Response.error(
          ((e as FirebaseException).message ?? e.toString()));
    }
  }

  Future<Response<UserCredential>> register(String email,
      String password) async {
    try {
      UserCredential userCredential = await instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return Response.success(userCredential);
    } catch (e) {
      return Response.error(
          ((e as FirebaseException).message ?? e.toString()));
    }
  }

  Future<Response<UserCredential>> signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;
      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      //return await FirebaseAuth.instance.signInWithCredential(credential);
      return Response.success(await FirebaseAuth.instance.signInWithCredential(credential));
    } catch (e) {
      return Response.error(
          ((e as FirebaseException).message ?? e.toString()));
    }
  }
}