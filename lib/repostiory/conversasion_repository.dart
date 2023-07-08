import 'dart:convert';
import 'package:appchat_socket/models/conversasion_model.dart';
import 'package:appchat_socket/models/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:appchat_socket/api/api.dart';
class conversasionRepository {
  Future<List<conversasionModel>> getMessageByUserId(userID) async {
    final url = Uri.parse(
        '${api.ipServer}chat/getallconversasion?userid=$userID');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Xử lý dữ liệu trả về
      final data = response.body;
      final List<dynamic> result = jsonDecode(data);

     
        List<conversasionModel> value =
            result.map((e) => conversasionModel.fromJson(e)).toList();
       

      return value;
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
    return [];
  }
  Future<List<messageModel>> getChatMessageByUserId(userid) async {
    
    final url = Uri.parse(
        '${api.ipServer}chat/getallmessagebyuser?userID=$userid');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Xử lý dữ liệu trả về
      final data = response.body;
      final Iterable result = jsonDecode(data);

     
        List<messageModel> value =
            result.map((e) => messageModel.fromJson(e)).toList();
       

      return value;
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
    return [];
  }
  Future<conversasionModel> getcheckconversasionByUserId(userid,sender) async {
    
    final url = Uri.parse(
        '${api.ipServer}chat/checkconversasion?userID=$userid&sender=$sender');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Xử lý dữ liệu trả về
      final data = response.body;
      Map<String,dynamic> result = jsonDecode(data);
      conversasionModel con = conversasionModel.fromJson(result);
     
        
       

      return con;
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
     return conversasionModel.fromJson({});
  }
}

conversasionRepository conRepo = new conversasionRepository();
