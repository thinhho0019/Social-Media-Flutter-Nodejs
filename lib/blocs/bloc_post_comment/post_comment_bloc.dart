import 'dart:async';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:appchat_socket/models/comment_post.dart';
import 'package:appchat_socket/models/post.dart';
import 'package:appchat_socket/repostiory/post_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'post_comment_event.dart';
part 'post_comment_state.dart';

class PostCommentBloc extends Bloc<PostCommentEvent, PostCommentState> {
  final postRepository _postRe;
  PostCommentBloc({required postRepository postRe})
      : _postRe = postRe,
        super(PostCommentLoading()) {
    on<PostCommentShow>(_PostCommentShow);
    on<PostCommentAdd>(_PostCommentAdd);
  }

  void _PostCommentShow(
      PostCommentShow event, Emitter<PostCommentState> emit) async {
    try {
      List<commentPost> data = await _postRe.getAllCommentByIdPost(event.post);
      emit(await PostCommentShowed(listComment: data));
    } catch (e) {
      print(e);
    }
  }

  void _PostCommentAdd(
      PostCommentAdd event, Emitter<PostCommentState> emit) async {
    final state = this.state;
    try {
      if (state is PostCommentShowed) {
        commentPost data;
        if (sharedPreferences.getString(keyShared.CURRENTREPLY) == "") {
          data = await _postRe.addComment(event.comment);
          emit(PostCommentShowed(
              listComment: List.from(state.listComment)..insert(0, data)));
        } else {
          data = await _postRe.addReplyComment(
              sharedPreferences.getString(keyShared.CURRENTREPLY),
              event.comment);
          int index = int.parse(sharedPreferences.getString(keyShared.CURRENTREPLYINDEX));
          commentPost result = state.listComment[index];
          List<commentPost> allComment = List.from(state.listComment)..removeAt(index);
          allComment.insert(index,
           result.copyWith(null, null, null, null, data.userReply, null));
 
          emit(PostCommentShowed(
              listComment: allComment ));

        }
      }
    } catch (e) {
      print(e);
    }
  }
}
