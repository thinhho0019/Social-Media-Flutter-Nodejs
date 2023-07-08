// ignore_for_file: public_member_api_docs, sort_constructors_first
 
import 'package:appchat_socket/models/user_detail.dart';

class userModel {
  final String id;
  final String name;
  final String avatar;
  final String access_token_current;
  final String status;
  final String email;
  final String google_id;
  final List<dynamic> friends;
  final List<dynamic> wait_friends;
  final String create_at;
   userDetail user_detail;
  int status_friend=0;
  userModel( 
      {required this.id,
      required this.name,
      required this.avatar,
      required this.google_id,
      required this.create_at,
      required this.status,
      required this.email,
      required this.access_token_current,
      required this.user_detail, 
      required this.status_friend,
      required this.friends,required this.wait_friends
      });
  factory userModel.fromJson(Map<String, dynamic> map) {
    return userModel(
        id: map['_id'],
        name: map['name'],
        avatar: map['avatar'] ?? "",
        create_at: map['create_at'] ?? "",
        status: map['status']?? "",
        email: map['email']?? "",
        google_id: map['google_id']?? "",
        access_token_current: map['access_token_current'] ?? "",
        status_friend: map['status_friend']??0,
        friends: map['friends']??[],
        wait_friends:map['wait_friends']??[],
        user_detail: map['user_detail'] is Map?userDetail.fromMap(map['user_detail']??{})
        :userDetail(id: "null", address_from: "null", address_live: "null", birthday: "null", studying: "null", background_image: "null",bio: "null",job: "null")
        );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'avatar': avatar,
      'access_token_current': access_token_current,
      'status': status,
      'email': email,
      'google_id': google_id,
      'friends': friends,
      'wait_friends': wait_friends,
      'create_at': create_at,
      'status_friend=0': status_friend=0,
    };
  }

  

  

  userModel copyWith({
    String? id,
    String? name,
    String? avatar,
    String? access_token_current,
    String? status,
    String? email,
    String? google_id,
    List<dynamic>? friends,
    List<dynamic>? wait_friends,
    String? create_at,
    userDetail? user_detail,
    int? status_friend,
  }) {
    return userModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      access_token_current: access_token_current ?? this.access_token_current,
      status: status ?? this.status,
      email: email ?? this.email,
      google_id: google_id ?? this.google_id,
      friends: friends ?? this.friends,
      wait_friends: wait_friends ?? this.wait_friends,
      create_at: create_at ?? this.create_at,
      user_detail: user_detail ?? this.user_detail,
      status_friend: status_friend ?? this.status_friend,
    );
  }
}
