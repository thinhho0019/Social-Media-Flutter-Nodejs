import 'package:shared_preferences/shared_preferences.dart';


class sharedPreferences {
  static SharedPreferences? _prefer;
  static Future initPreference() async{
    _prefer = await SharedPreferences.getInstance();
  }
  static void setString(String key,String value){
    _prefer?.setString(key, value);
  }
  static String getString(String key){
    return _prefer?.getString(key) ?? '';
  }
}