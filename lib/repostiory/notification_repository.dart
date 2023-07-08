import 'dart:convert';
import 'package:appchat_socket/models/notification_model.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import '../api/api.dart';
import 'package:http/http.dart' as http;
import 'package:nanoid/nanoid.dart';

class notificationRepository {
  Future<dynamic> getAllNotification() async {
    final url = Uri.parse('${api.ipServer}notification/getnotification');
    final headers = {'Content-Type': 'application/json'};
    final body =
        json.encode({"userid": sharedPreferences.getString(keyShared.IDUSER)});
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      try {
        final data = response.body;
        Iterable result = json.decode(data);
        List<notificationModel> listNoti =
            result.map((e) => notificationModel.fromMap(e)).toList();
        return listNoti;
      } catch (e) {
        print(e);
      }
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
      return "error";
    }
  }
}

notificationRepository notiRe = notificationRepository();
