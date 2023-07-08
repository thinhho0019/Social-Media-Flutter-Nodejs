// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:appchat_socket/models/image_post.dart';
import 'package:appchat_socket/models/user_model.dart';

class post {
  final String id;
  final String content;
  final int like_count;
  final int comment_count;
  final String create_at;
  final String access;
  final userModel user;
  final List<imagePost> image;
  final bool liked;
  
 

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'like_count': like_count,
      'comment_count': comment_count,
      'create_at': create_at,
      'access': access,
      'user': user.toMap(),
      'image': image.map((x) => x.toMap()).toList(),
      'liked': liked,
    };
  }

  post(   {required this.liked,required this.user,required this.content,required this.id,required this.like_count,required this.create_at,required this.access,required this.image,required this.comment_count,});
  factory post.fromMap(Map<dynamic,dynamic> map){
    return post(id: map['_id']??"",
     like_count:  map['like_count']??0,
      create_at: map['create_at']??"",
       access: map['access']??"",
       content: map['content']??"",
        image:  List.from(map['image']?.map((x)=>imagePost.fromMap(x)).toList()??[]),
        user:  userModel.fromJson(map['user'] ??[]),
        liked: map['liked']??false,
        comment_count : map['comment_count']??0
          );
  }
  post copyWith(String? id,
  int? like_count,
  String? create_at,
  String? access,
  userModel? user,
  bool? liked,
  int? comment_count,
  List<imagePost>? image,String? content){
    return post(id: id??this.id,
    content: content ?? this.content,
     like_count: like_count??this.like_count,
      create_at: create_at??this.create_at,
       access: access??this.access,
       user: user??this.user,
        image: image??this.image,
        liked: liked??this.liked, comment_count: comment_count??this.comment_count
        );
  }
}
