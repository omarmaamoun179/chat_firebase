import 'dart:developer';

import 'package:chat_firebase/cubit/auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  User? get user => FirebaseAuth.instance.currentUser;
  final fireStore = FirebaseFirestore.instance;

  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      emit(AuthInitial());
    } catch (e) {
      log(e.toString());
    }
  }

  void register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      credential.user?.getIdToken();
      addUserToFireStore(name,  email);
      emit(AuthSuccess(credential.user!));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      log(e.toString());
      emit(AuthError(e.toString()));
    } catch (e) {
      print(e);

      emit(AuthError(e.toString()));
    }
  }

  void login(String email, String password) async {
    try {
      emit(AuthLoading());
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log("UserName : ${credential.user!.displayName}");

      return emit(AuthSuccess(credential.user!));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void addUserToFireStore(
    String name,
    String email,
  ) async {
    try {
      await fireStore.collection('users').doc(user!.uid).set({
        'name': name,
        'email': email,
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
