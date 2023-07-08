part of 'post_comment_bloc.dart';

abstract class PostCommentEvent extends Equatable {
  const PostCommentEvent();

  @override
  List<Object> get props => [];
}
class PostCommentShow extends PostCommentEvent{
    final String post;
   const PostCommentShow({required this.post});

  @override
  List<Object> get props => [post];
}
class PostCommentAdd extends PostCommentEvent{
  final commentPost comment;
  final int index;
   const PostCommentAdd( {required this.comment,required this.index,});

  @override
  List<Object> get props => [comment];
}
