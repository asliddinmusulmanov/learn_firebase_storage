import 'package:flutter/material.dart';
import 'package:learn_firebase_storage/pages/auth_gate.dart';
import 'package:learn_firebase_storage/setup.dart';
import 'package:learn_firebase_storage/shared_preferens.dart';

void main() async {
  await setup();
  bool isLoading = await getLoginState();
  runApp(MyApp(isLogin: isLoading));
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  const MyApp({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
