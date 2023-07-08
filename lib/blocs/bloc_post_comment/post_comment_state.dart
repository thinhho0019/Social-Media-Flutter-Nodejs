part of 'post_comment_bloc.dart';

abstract class PostCommentState extends Equatable {
  const PostCommentState();
  
  @override
  List<Object> get props => [];
}

class PostCommentLoading extends PostCommentState {}
class PostCommentShowed extends PostCommentState {
    final List<commentPost> listComment;
   const PostCommentShowed({required this.listComment});
  
  @override
  List<Object> get props => [listComment];
}
class PostCommentShowError extends PostCommentState {}