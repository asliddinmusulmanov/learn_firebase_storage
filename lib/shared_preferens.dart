import 'package:shared_preferences/shared_preferences.dart';

Future<void> setLoginState(bool loggedIn) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', loggedIn);
}

Future<bool> getLoginState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}
