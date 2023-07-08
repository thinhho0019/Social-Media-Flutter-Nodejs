import 'dart:convert';
import 'package:appchat_socket/models/comment_post.dart';
import 'package:appchat_socket/models/image_post.dart';
import 'package:appchat_socket/models/post.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../api/api.dart';
import 'package:nanoid/nanoid.dart';

class postRepository  {
  final dio = Dio();
  Future<List<post>> getPost() async {
    final url = Uri.parse('${api.ipServer}post/getallpost?user=${sharedPreferences.getString(keyShared.IDUSER)}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = response.body;
      Iterable result = json.decode(data);
      try {
        List<post> postData = result.map((e) => post.fromMap(e)).toList();
        return postData;
      } catch (e) {
        print(e.toString());
      }
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
    return [];
  }
  Future<List<post>> getPostForUser(String user) async {
    String a= sharedPreferences.getString(keyShared.IDUSER);
    final url = Uri.parse('${api.ipServer}post/getallpostbyuserid?user=${user}&useraction=$a');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = response.body;
      Iterable result = json.decode(data);
      try {
        List<post> postData = result.map((e) => post.fromMap(e)).toList();
        return postData;
      } catch (e) {
        print(e.toString());
      }
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
    return [];
  }
  Future<String> likePost(String post,String userRecei) async {
    final url = Uri.parse('${api.ipServer}post/likepost');
    final headers = {'Content-Type': 'application/json'};
     final body = json.encode({
       "user":sharedPreferences.getString(keyShared.IDUSER),
       "idpost":post,
       "userrecei":userRecei,
       "tokennofi":sharedPreferences.getString(keyShared.TOKENNOTIFICATION),
       "nameuser":sharedPreferences.getString(keyShared.GOOGLENAMEDISPLAY)
    });
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = response.body;
      return data;
       
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
    return "";
  }
  Future<dynamic> addComment(commentPost comment) async {
    final url = Uri.parse('${api.ipServer}post/addcomment');
    final headers = {'Content-Type': 'application/json'};
     final body = json.encode({
       "user":comment.user.id,
       "post":comment.post,
       "userReply":comment.userReply??"",
       "comment":comment.comment
    });
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = response.body;
      Map<String,dynamic> result = json.decode(data);
      commentPost comment = commentPost.fromMap(result);
      return comment;
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
      return "error";
    }
    
  }
  Future<dynamic> addReplyComment(String idcomment,commentPost comment) async {
    final url = Uri.parse('${api.ipServer}post/addreplycomment');
    final headers = {'Content-Type': 'application/json'};
     final body = json.encode({
       "idcomment":idcomment,
    "user":comment.user.id,
    "post":comment.post,
    "comment":comment.comment
    });
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = response.body;
      Map<String,dynamic> result = json.decode(data);
      commentPost comment = commentPost.fromMap(result);
      return comment;
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
      return "error";
    }
    
  }
  Future<bool> checkliked(String post) async {
    final url = Uri.parse('${api.ipServer}post/likepost');
    final headers = {'Content-Type': 'application/json'};
     final body = json.encode({
       "user":sharedPreferences.getString(keyShared.IDUSER),
       "idpost":post
    });
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
       return response.body as bool;
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
    return false;
  }
  Future<bool> deletePost(String idpost,List<String> image) async {
    final url = Uri.parse('${api.ipServer}post/deletepost');
    final headers = {'Content-Type': 'application/json'};
     final body = json.encode({
       "idpost":idpost,
       "listImage":image
    });
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {

       return response.body=="true"?true:false;
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
    return false;
  }
  Future<List<commentPost>> getAllCommentByIdPost(String post) async {
    final url = Uri.parse('${api.ipServer}post/getcommentbyid?post=$post');
    final response = await http.get(url );
    if (response.statusCode == 200) {
      final data = response.body;
      Iterable result = json.decode(data);
      List<commentPost> rs = result.map((e) => commentPost.fromMap(e)).toList();
      return rs;
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
    }
    return [];
  }
  Future<post> uploadPost(List<XFile> listFile,String content,String access) async {
    FormData formData = FormData();
    try {
      final temp =[];
      for (var i = 0; i < listFile.length; i++) {
        final file = listFile[i];
        final mutipart =  await MultipartFile.fromFile(file.path,
              filename: nanoid()+"-"+file.path.split('/').last);
        temp.add(mutipart);
      }
      formData = FormData.fromMap({
          'fileimage': temp ,
          'content':content,
          'access':access,
          'user':sharedPreferences.getString(keyShared.IDUSER)
        });
      final response = await dio
          .post('${api.ipServer}post/uploadimage', data: formData);

      if (response.statusCode == 200) {
        final data = response.data;
        //Map<String,dynamic> result = json.decode(data);
        return  post.fromMap(data);
      } else {
        print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
    Map<String,dynamic> a =Map();
    return post.fromMap(a);
  }
  Future<List<imagePost>> updatePost(List<XFile> listFile,String content,String access,List<String> imageold,String idpost) async {
    FormData formData = FormData();
    try {
      final temp =[];
      for (var i = 0; i < listFile.length; i++) {
        final file = listFile[i];
        final mutipart =  await MultipartFile.fromFile(file.path,
              filename:  nanoid()+"-"+file.path.split('/').last);
        temp.add(mutipart);
      }
      formData = FormData.fromMap({
          'idpost':idpost,
          'fileimage': temp ,
          'titlepost':content,
          'access':access,
          'imageold':imageold.length==1?[imageold]:imageold
        });
      final response = await dio
          .post('${api.ipServer}post/updatepost', data: formData);

      if (response.statusCode == 200) {
        final data = response.data;
        Iterable result = data;
        List<imagePost> resultImage = result.map((e) => imagePost.fromMap(e)).toList();
        return  resultImage;
      } else {
        print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      
    }
     return [];
  }
}

postRepository postRe = new postRepository();
