import 'dart:ffi';
import 'package:intl/intl.dart';
class formatTime {
  static String convertUtcToVn(String date) {
    DateTime now = DateTime.now().toUtc();
    DateTime dateTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parseUtc(date);
    var vietnamTime = dateTime.add(Duration(hours: 7));
    var formatter = DateFormat('dd/MM/yyyy, HH:mm');
    //var formattedTime = formatter.format(vietnamTime);
    //equals
    String day = formatter.format(vietnamTime).split(',')[0];
    String time = formatter.format(vietnamTime).split(',')[1];
    if (vietnamTime.isBefore(now)) {
      return day + "," + time;
    } else if (vietnamTime.isAfter(now)) {
      return time;
    } else {
      return time;
    }
    return day;
  }

  static String convertTimePost(date) {
    DateTime now = DateTime.now().toUtc();
    DateTime dateTime = DateTime.parse(date).toUtc();
    Duration difference = now.difference(dateTime);

    if (difference.inMinutes >= 60) {
      if (difference.inMinutes >= 1440) {
        return "${difference.inDays} ngày trước";
      }
      return "${difference.inHours} giờ trước";
    } else {
      return difference.inMinutes.toString() + " phút trước";
    }
  }

  static String convertVNtoUtc(date) {
   
    String formattedDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(date);
    return formattedDate;
  }

  static int diffConvertUtcToMinutes(date) {
    DateTime now = DateTime.now().toUtc();
    DateTime dateTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parseUtc(date);
    Duration difference = now.difference(dateTime);
    return difference.inMinutes;
  }

  static String convertUtcToVnConversasion(String date) {
    DateTime now = DateTime.now().toUtc();
    DateTime dateTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parseUtc(date);
    var vietnamTime = dateTime.add(Duration(hours: 7));
    var formatter = DateFormat('dd/MM/yyyy, HH:mm');
    //var formattedTime = formatter.format(vietnamTime);
    //equals
    String day = formatter.format(vietnamTime).split(',')[0];
    String time = formatter.format(vietnamTime).split(',')[1];

    return time;
  }
  static String convertDatetoString(DateTime date){
    String dateTime = DateFormat("dd/MM/yyyy").format(date);
    return dateTime;
  }
  static DateTime convertUtcToVN_editprofile(String date){
    DateTime now = DateTime.now().toUtc();
    DateTime dateTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parseUtc(date);
    var vietnamTime = dateTime.add(Duration(hours: 7));
    
    var formattedTime = DateFormat("dd/MM/yyyy").format(vietnamTime);
    return DateFormat("dd/MM/yyyy").parse(formattedTime);
  }
  static String convertUtcToVn_online(String date) {
    DateTime now = DateTime.now().toUtc();
    DateTime dateTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parseUtc(date);
    Duration difference = now.difference(dateTime);
    if (difference.inMinutes >= 60) {
      if (difference.inMinutes >= 1440) {
        return "${difference.inDays} ngày";
      } else {
        return "${difference.inHours} giờ";
      }
    } else {
      return difference.inMinutes.toString() + " phút";
    }
  }
  static String convertUtcToVn_birthday(String date) {
    DateTime now = DateTime.now().toUtc();
    DateTime dateTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parseUtc(date);
     var vietnamTime = dateTime.add(Duration(hours: 7));
    var formatter = DateFormat('dd/MM/yyyy, HH:mm');
    //var formattedTime = formatter.format(vietnamTime);
    //equals
    String datetimeA = formatter.format(vietnamTime).split(',')[0];
    ;
    return "Ngày ${datetimeA.split('/')[0]} tháng ${datetimeA.split('/')[1]} năm ${datetimeA.split('/')[2]}";
  }
}
