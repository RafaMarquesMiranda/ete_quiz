import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {

  static String   UserLoggedinKey = "USERLOGGEDINKEY";

  static saveUserLoggedInDetails({@required bool inLoggedin}) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(UserLoggedinKey ,  inLoggedin);
  }

  static Future <bool> getUserLoggedInDetails () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(UserLoggedinKey);
  }
}