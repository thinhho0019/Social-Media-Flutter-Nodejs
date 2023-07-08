// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'dart:convert';

import 'package:appchat_socket/models/post.dart';
import 'package:appchat_socket/models/user_model.dart';

class notificationModel {
  final String id;
  final userModel user;
  final post? p;
  final String type;
  final String create_at;
  final String seen;
  notificationModel(  {
    required this.id,
    required this.user,
    required this.p,
    required this.type,
    required this.create_at,
    required this.seen,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'post': p!.toMap(),
      'type': type,
      'create_at': create_at,
    };
  }

  factory notificationModel.fromMap(Map<String, dynamic> map) {
    return notificationModel(
      id: map['_id']??"",
      user: userModel.fromJson(map['user']??""),
      p: map['post']!=null?post.fromMap(map['post']):null,
      type: map['type'] ??"",
      create_at: map['create_at'] ??"",
      seen: map['seen']??""
    );
  }

  

  notificationModel copyWith({
    userModel? user,
    post? p,
    String? type,
    String? create_at,
    String? seen,
    String? id
  }) {
    return notificationModel(
      id: id??this.id,
      user: user ?? this.user,
      p: p ?? this.p,
      type: type ?? this.type,
      seen: seen??this.seen,
      create_at: create_at ?? this.create_at,
    );
  }
}
