import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_firebase_storage/data/auth_model.dart';
import 'package:learn_firebase_storage/pages/home_page.dart';

import '../services/auth_service.dart';
import '../services/utils_service.dart';
import 'otp_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

bool isnima = true;
bool isnimadir = true;
bool check = false;
EmailOTP myauth = EmailOTP();

TextEditingController regNameC = TextEditingController();
TextEditingController regEmailC = TextEditingController();
TextEditingController regPasswordC = TextEditingController();
TextEditingController regConfirmPassC = TextEditingController();

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;

  Future<void> register(AuthModel authModel) async {
    String name = regNameC.text;
    String email = regEmailC.text;
    String pass = regPasswordC.text;
    if (name.isEmpty || name.length < 2) {
      Utils.fireSnackBar("Name is not filled", context);
    } else if (email.isEmpty || email.length < 2 || !email.contains("@")) {
      Utils.fireSnackBar("Email is badly formatted", context);
    } else if (pass.isEmpty || pass.length < 5) {
      Utils.fireSnackBar("Password should be more than 6 char", context);
    } else {
      User? user = await AuthService.registerUser(context, authModel);
      if (user != null) {
        if (mounted) {
          Utils.fireSnackBar("Successfully registered", context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        }
      }
    }
  }

  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
            key: globalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create account!",
                  style: TextStyle(
                    color: Color(0xff169C89),
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  "Register to get started.",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: regNameC,
                  // style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    counterStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color(0xffB1B1B1),
                    ),
                    label: Text(
                      "Name",
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
                    if (regNameC.text.isNotEmpty) {
                      return null;
                    } else {
                      return 'Please enter your name';
                    }
                  },
                  onChanged: (value) {
                    if (globalKey.currentState!.validate()) {
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: regEmailC,
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
                    if (value != null && value.contains("@gmail.com")) {
                      return null;
                    } else {
                      return 'Please enter your email address\nExample => (example@gmail.com)';
                    }
                  },
                  onChanged: (value) {
                    if (globalKey.currentState!.validate()) {
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: regPasswordC,
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
                    RegExp regex = RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
                    if (value != null && regex.hasMatch(value)) {
                      return null;
                    } else {
                      return 'Must be 8 or more characters  and contain at least 1\nnumber or special character';
                    }
                  },
                  onChanged: (value) {
                    if (globalKey.currentState!.validate()) {
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: regConfirmPassC,
                  obscureText: isnimadir,
                  decoration: InputDecoration(
                    counterStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      // color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        isnimadir = !isnimadir;
                        setState(() {});
                      },
                      icon: isnimadir
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
                      "Confirm Password",
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
                    if (value!.isEmpty) return "Yozish shart";
                    if (value != regPasswordC.text)
                      return "The verification password is incorrect";
                    return null;
                  },
                  onChanged: (value) {
                    if (globalKey.currentState!.validate()) {
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: check,
                      onChanged: (bool? newValue) {
                        setState(() {
                          check = newValue!;
                        });
                      },
                      activeColor: const Color(0xff169C89),
                    ),
                    const Expanded(
                      child: Text(
                        'By registering, you are agreeing with our\nTerms of Use and Privacy Policy',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff169C89),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: const Size(double.maxFinite, 60),
                  ),
                  onPressed: () async {
                    if (!globalKey.currentState!.validate()) return;
                    if (!check) {
                      Utils.fireSnackBar(
                          "You must agree to the terms and conditions",
                          context);
                      return;
                    }
                    isLoading = true;
                    setState(() {});
                    AuthModel authModel = AuthModel(
                      name: regNameC.text,
                      phoneNumber: 'phoneNumber',
                      email: regEmailC.text,
                      password: regPasswordC.text,
                      id: 'id',
                    );

                    myauth.setConfig(
                      appEmail: authModel.email,
                      userEmail: authModel.email,
                      otpLength: 6,
                      otpType: OTPType.digitsOnly,
                      appName: "Email OTP",
                    );

                    if (await myauth.sendOTP() == true) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("OTP has been sent"),
                      ));

                      await register(authModel);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyAccount(
                            authModel: authModel,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Oops, OTP send failed"),
                      ));
                    }
                  },
                  child: !isLoading
                      ? const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            // fontWeight: FontWeight.w700,
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                            strokeCap: StrokeCap.round,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
