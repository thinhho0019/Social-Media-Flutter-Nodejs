part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();
  
  @override
  List<Object> get props => [];
}

class PostLoading extends PostState {
}

class PostShowed extends PostState {
  final List<post> listPost;
  final List<post> listPostUser;
  PostShowed( {required this.listPost,required this.listPostUser,});
  
  @override
  List<Object> get props => [listPost,listPostUser];
}
 class PostShowedForUser extends PostState {
  final List<post> listPost;
  PostShowedForUser({required this.listPost});
  
  @override
  List<Object> get props => [listPost];
}
class PostShowError extends PostState {
  String error;
  PostShowError(this.error);
  @override
  List<Object> get props => [error];
}