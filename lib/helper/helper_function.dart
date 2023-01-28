import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String useridKey = "USERIDKEY";
  static String userstuidKey = "USERSTUIDKEY";
  static String usertypeKey = "USERTYPEKEY"; // -1 : none, 0 : 학생, 1: 교수
  static String projectKey = "PROJECTKEY";
  // saving the data to SF

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool> saveUserIDSF(String userID) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(useridKey, userID);
  }

  static Future<bool> saveUserstuIDSF(String stuID) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userstuidKey, stuID);
  }

  static Future<bool> saveUsertypeSF(int inputtype) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setInt(usertypeKey, inputtype);
  }

  static Future<bool> saveProjectSF(String proid) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(projectKey, proid);
  }

  // getting the data from SF
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<String?> getUserIDFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(useridKey);
  }

  static Future<String?> getUserstuIDFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userstuidKey);
  }

  static Future<int?> getUsertypeSFFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getInt(usertypeKey);
  }

  static Future<String?> getProjectidFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(projectKey);
  }
}
