import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:learn_firebase_storage/services/utils_service.dart';

import '../data/auth_model.dart';

final class AuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static Dio dio = Dio();

  static Future<User?> registerUser(
      BuildContext context, AuthModel authModel) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: authModel.email, password: authModel.password);
      dio.post("https://65c4be6adae2304e92e33e36.mockapi.io/user/products",
          data: authModel.toJson());
      userCredential.user?.updateDisplayName(authModel.name);
      if (userCredential.user != null) {
        return userCredential.user;
      } else {
        return null;
      }
    } catch (e) {
      Utils.fireSnackBar("$e", context);
      return null;
    }
  }

  static Future<User?> loginUser(BuildContext context,
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null) {
        return userCredential.user;
      } else {
        return null;
      }
    } catch (e) {
      Utils.fireSnackBar("$e", context);
      return null;
    }
  }

  static Future<void> deleteAccount() async {
    await auth.currentUser?.delete();
  }

  static Future<void> logOut() async {
    await auth.signOut();
  }
}
