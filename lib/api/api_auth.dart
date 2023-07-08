import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appchat_socket/api/api.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
class apiAuth   {
  Future<void> LoginAuth(accesstoken) async {
    final url = Uri.parse('${api.ipServer}user/signingoogle');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'accesstoken': accesstoken,
      }),
    );

    if (response.statusCode == 200) {
      // Xử lý dữ liệu trả về
      final data = response.body;
      final Map<String, dynamic> result = json.decode(data);
        sharedPreferences.setString(keyShared.GOOGLEGMAIL,result['email'] );
        sharedPreferences.setString(keyShared.GOOGLEIMAGE, result['avatar']);
        sharedPreferences.setString(keyShared.GOOGLENAMEDISPLAY,result['name'] );
        sharedPreferences.setString(keyShared.IDUSER,result['_id'] );
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
  }
}

apiAuth ApiAuth = new apiAuth();