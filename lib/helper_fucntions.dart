import 'package:shared_preferences/shared_preferences.dart';

class Helperfunctions{
  //keys
  static String userLoggedInKey='LoggedInKey';
  static String userNameKey='UserNameKey';
  static String userEmailKey='UserEmailKey';
  //saving data to sf
  static Future<bool?>saveUserLoggedInStatus(bool isUserLoggedIn)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setBool(userLoggedInKey, isUserLoggedIn);
  }
  static Future<bool?>saveUsernameSF(String username)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userNameKey, username);
  }
  static Future<bool?>saveUseremailSF(String useremail)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userEmailKey, useremail);
  }

  //getting data from sf
  static Future<bool?>getUserLoggedInStatus()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }
  static Future<String?>getUserEmailFromSF()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }
  static Future<String?>getUsernameFromSF()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

}