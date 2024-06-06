import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_firebase_storage/pages/home_page.dart';
import 'package:learn_firebase_storage/pages/register_page.dart';

import '../services/auth_service.dart';
import '../services/utils_service.dart';
import '../shared_preferens.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

bool isnima = true;
bool errorText = true;

TextEditingController emailC = TextEditingController();
TextEditingController passwordC = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome back!",
                style: TextStyle(
                  color: Color(0xff169C89),
                  fontSize: 34,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                "Enter your credentials to continue.",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 50),
              TextFormField(
                controller: emailC,
                // style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  counterStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Color(0xffB1B1B1),
                  ),
                  label: Text(
                    "Email Address",
                    style: TextStyle(
                      color: Color(0xffB1B1B1),
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: Color(0xff454B60),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(14),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return null;
                  } else {
                    return "Pizdes foshfoa asogi haslgka sbgioasbg";
                  }
                },
                onChanged: (value) {
                  if (globalKey.currentState!.validate()) {
                    setState(() {});
                  }
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordC,
                obscureText: isnima,
                decoration: InputDecoration(
                  counterStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    // color: Colors.white,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      isnima = !isnima;
                      setState(() {});
                    },
                    icon: isnima
                        ? const Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: Colors.green,
                          ),
                  ),
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: Color(0xffB1B1B1),
                  ),
                  label: const Text(
                    "Password",
                    style: TextStyle(
                      color: Color(0xffB1B1B1),
                    ),
                  ),
                  hintStyle: const TextStyle(
                    color: Color(0xff454B60),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(14),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return null;
                  } else {
                    return "sfsdf foshfoa asogi haslgka sbgioasbg";
                  }
                },
                onChanged: (value) {
                  if (globalKey.currentState!.validate()) {
                    setState(() {});
                  }
                },
              ),
              const SizedBox(height: 5),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Color(0xff169C89),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff169C89),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: const Size(double.maxFinite, 60),
                ),
                onPressed: () async {
                  User? user1 = await AuthService.loginUser(context,
                      email: emailC.text, password: passwordC.text);
                  if (user1 != null) {
                    await setLoginState(true);
                    Utils.fireSnackBar("Successfully", context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  } else {
                    setState(() {});
                    errorText = false;
                  }
                },
                child: const Text(
                  "Log in",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    // fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'Or connect via',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xffDDDDDD),
                          width: 3,
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/img_3.png',
                        cacheWidth: 25,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xffDDDDDD),
                          width: 3,
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/img_4.png',
                        cacheWidth: 25,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xffDDDDDD),
                          width: 3,
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/img_5.png',
                        cacheWidth: 25,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 90),
              const Center(
                child: Text(
                  "By logging, you are agreeing with our\n   Terms of Use and Privacy Policy",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
