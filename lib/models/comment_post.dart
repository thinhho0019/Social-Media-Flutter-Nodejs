// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appchat_socket/models/user_model.dart';

class commentPost {
  final String id;
  final userModel user;
  final String post;
  final String comment;
  final List<commentPost> userReply;
  final String create_at;
  commentPost({
    required this.id,
    required this.user,
    required this.post,
    required this.comment,
    required this.create_at,
    required this.userReply,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMap(),
      'post': post,
      'comment': comment,
      'create_at': create_at,
      'reply': userReply
    };
  }

  factory commentPost.fromMap(Map<String, dynamic> map) {
    return commentPost(
        id: map['_id'] ?? "",
        user: userModel.fromJson(map['user'] ?? {}),
        post: map['post'] ?? "",
        comment: map['comment'] ?? "",
        create_at: map['create_at'] ?? "",
        userReply: map.containsKey('reply')
            ? map['reply'] == null
                ? []
                : List.from(map['reply'])
                    .map((e) => commentPost.fromMap(e))
                    .toList()
            : []);
  }

  commentPost copyWith(
    String? id,
    userModel? user,
    String? post,
    String? comment,
    List<commentPost>? userReply,
    String? create_at,
  ) {
    return commentPost(
      id: id ?? this.id,  
      user: user ?? this.user,
      post: post ?? this.post,
      comment: comment ?? this.comment,
      userReply: userReply ?? this.userReply,
      create_at: create_at ?? this.create_at,
    );
  }
}
