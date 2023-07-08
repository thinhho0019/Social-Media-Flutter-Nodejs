import 'dart:convert';
import 'package:appchat_socket/api/api.dart';
import 'package:appchat_socket/models/post.dart';
import 'package:appchat_socket/models/user_detail.dart';
import 'package:appchat_socket/models/user_model.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' ;
import 'package:image_picker/image_picker.dart';
import 'package:nanoid/nanoid.dart';
class userRepository {
  final dio = Dio();
  Future<List<userModel>> getMyFriend() async {
    final url = Uri.parse(
        '${api.ipServer}user/getmyfriends?userid=${sharedPreferences.getString(keyShared.IDUSER)}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Xử lý dữ liệu trả về
      final data = response.body;
      final List<dynamic> temp = jsonDecode(data);
      final Iterable result = temp[0]['friends'];
      List<userModel> user = result.map((e) => userModel.fromJson(e)).toList();

      return user;
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
    return [];
  }
Future<List<userModel>> getMyFriendForUser(String user) async {
    final url = Uri.parse(
        '${api.ipServer}user/getmyfriends?userid=$user');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Xử lý dữ liệu trả về
      final data = response.body;
      final List<dynamic> temp = jsonDecode(data);
      final Iterable result = temp[0]['friends'];
      List<userModel> user = result.map((e) => userModel.fromJson(e)).toList();

      return user;
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
    return [];
  }
  Future<List<userModel>> getMySentAddFriend() async {
    final url = Uri.parse(
        '${api.ipServer}user/getAllSentAddFriends?userid=${sharedPreferences.getString(keyShared.IDUSER)}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Xử lý dữ liệu trả về
      final data = response.body;
      final List<dynamic> temp = jsonDecode(data);
      final Iterable result = temp[0]['wait_friends'];
      List<userModel> user = result.map((e) => userModel.fromJson(e)).toList();
      return user;
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
    return [];
  }

  Future<List<userModel>> getMyReceivedAddFriend() async {
    final url = Uri.parse(
        '${api.ipServer}user/getAllUserWaitAccept?userid=${sharedPreferences.getString(keyShared.IDUSER)}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Xử lý dữ liệu trả về
      try {
        final data = response.body;
        final Iterable result = json.decode(data);

        List<userModel> user =
            result.map((e) => userModel.fromJson(e)).toList();
        return user;
      } catch (e) {
        print(e);
      }
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
    return [];
  }

  Future<bool> cancelWaitFriend(String user2, String action) async {
    //cancel add friend
    String user1 = sharedPreferences.getString(keyShared.IDUSER);
    final url = Uri.parse('${api.ipServer}user/cancelfriends');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userSender': sharedPreferences.getString(keyShared.IDUSER),
        'userReceiver': user2,
        'action': action
      }),
    );
    if (response.statusCode == 200) {
      // Xử lý dữ liệu trả về
      final data = response.body;
      final Map<String, dynamic> listUser = json.decode(data);
      if (listUser['result'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
    return false;
  }

  Future<bool> sendAddFriends(String user2) async {
    //cancel add friend
    String user1 = sharedPreferences.getString(keyShared.IDUSER);
    final url = Uri.parse('${api.ipServer}user/waitfriends');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userSender': sharedPreferences.getString(keyShared.IDUSER),
        'userReceiver': user2,
      }),
    );
    if (response.statusCode == 200) {
      // Xử lý dữ liệu trả về
      final data = response.body;
      final Map<String, dynamic> listUser = json.decode(data);
      if (listUser['result'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
    return false;
  }

  Future<bool> acceptAddFriends(String user2) async {
    //cancel add friend
    String user1 = sharedPreferences.getString(keyShared.IDUSER);
    final url = Uri.parse('${api.ipServer}user/acceptfriends');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userSender': user2,
        'userReceiver': sharedPreferences.getString(keyShared.IDUSER),
      }),
    );
    if (response.statusCode == 200) {
      // Xử lý dữ liệu trả về
      final data = response.body;
      final Map<String, dynamic> listUser = json.decode(data);
      if (listUser['result'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
    return false;
  }

  Future<void> logOutUser() async {
    //cancel add friend
    String user = sharedPreferences.getString(keyShared.IDUSER);
    final url = Uri.parse('${api.ipServer}user/logout');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': user,
      }),
    );
    if (response.statusCode == 200) {
      // Xử lý dữ liệu trả về
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
  }

  Future<dynamic> getUserInformation(String user) async {
    //cancel add friend
    final url = Uri.parse('${api.ipServer}user/getinformationuser');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': user,
      }),
    );
    if (response.statusCode == 200) {
      // Xử lý dữ liệu trả về
      final data = response.body;
      Map<String, dynamic> result = json.decode(data);
      return userModel.fromJson(result);
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
  }
  Future<dynamic> checkFriendsForUser(String user) async {
    //cancel add friend

    final url = Uri.parse('${api.ipServer}user/checkreplateuser');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },  
      body: jsonEncode(<String, dynamic>{
        'user1': sharedPreferences.getString(keyShared.IDUSER),
        'user2':user 
      }),
    );
    if (response.statusCode == 200) {
      // Xử lý dữ liệu trả về
      final data = response.body;
      String result = json.decode(data);
      return result;
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
  }
  Future<dynamic> updateProfile(String id,dynamic data) async {
    //cancel add friend

    final url = Uri.parse('${api.ipServer}user/updateprofile');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },  
      body: jsonEncode(<String, dynamic>{
        'idDetail': id,
        'data': data
      }),
    );
    if (response.statusCode == 200) {
      // Xử lý dữ liệu trả về
      
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
  }
  Future<dynamic> uploadImageAvatar( XFile  file,String userid,String nameimageold) async {
    FormData formData = FormData();
    try {
       
      final filex = file;
      final image =  await MultipartFile.fromFile(filex.path,
              filename: nanoid()+"-"+file.path.split('/').last);
      formData = FormData.fromMap({
          'image': image ,
          'userid':userid,
          'nameimageold':nameimageold,
           
        });
      final response = await dio
          .post('${api.ipServer}user/uploadimageavatar', data: formData);

      if (response.statusCode == 200) {
        final data = response.data;
        sharedPreferences.setString(keyShared.GOOGLEIMAGE,data);
         
        return  data;
      } else {
        print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
 
  }
  Future<dynamic> uploadImageBackground( XFile  file,String userid,String nameimageold) async {
    FormData formData = FormData();
    try {
       
      final filex = file;
      final image =  await MultipartFile.fromFile(filex.path,
              filename: nanoid()+"-"+file.path.split('/').last);
      formData = FormData.fromMap({
          'image': image ,
          'userid':userid,
          'nameimageold':nameimageold,
           
        });
      final response = await dio
          .post('${api.ipServer}user/uploadimagebackground', data: formData);

      if (response.statusCode == 200) {
        final data = response.data;
        sharedPreferences.setString(keyShared.GOOGLEIMAGE,data);
         
        return  data;
      } else {
        print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
 
  }
}

userRepository userRe = new userRepository();
