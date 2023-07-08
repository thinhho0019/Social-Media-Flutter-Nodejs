import 'dart:convert';

import 'package:appchat_socket/api/api.dart';
import 'package:appchat_socket/models/user_model.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:http/http.dart' as http;
class ApiSearch  {
  Future<List<userModel>> getAllUserSearch() async {
    String id_user = sharedPreferences.getString(keyShared.IDUSER);
    if (!id_user.isEmpty) {
      final response = await http
          .get(Uri.parse('${api.ipServer}user/getalluser'));

      if (response.statusCode == 200) {
        final data = response.body;

        final Iterable listUser = json.decode(data);
        List<userModel> user = [];
        try {
          user = listUser.map((e) => userModel.fromJson(e)).toList();
        } catch (e) {
          print("msg: $e");
        }

        return user;
      } else {
        print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
      }
    }

    return [];
  }
}

ApiSearch apiSearch = ApiSearch();
