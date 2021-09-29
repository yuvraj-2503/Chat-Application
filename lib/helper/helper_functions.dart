
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  static String sharedPreferencesUserLoggedInKey = "IS_LOGGED_IN";
  static String sharedPreferencesUsernameKey = "USERNAME_KEY";
  static String sharedPreferencesUserEmailKey = "USER_EMAIL_KEY";

  static Future saveUserLoggedInSharedPreferences(bool isUserLoggedIn) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(sharedPreferencesUserLoggedInKey, isUserLoggedIn);
  }

  static Future saveUsernameSharedPreferences(String username) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferencesUsernameKey, username);
  }

  static Future saveUserEmailSharedPreferences(String userEmail) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferencesUserEmailKey, userEmail);
  }

  static Future getUserLoggedInSharedPreferences() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferencesUserLoggedInKey);
  }

  static Future getUsernameSharedPreferences() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferencesUsernameKey);
  }

  static Future getUserEmailSharedPreferences() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferencesUserEmailKey);
  }

  static Future<bool> deleteSharedPreferencesData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.clear();
  }
}