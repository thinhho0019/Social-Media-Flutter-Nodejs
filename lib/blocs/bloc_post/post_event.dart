part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class PostShowList extends PostEvent{
  final String action;
  final String user;
  PostShowList( {required this.action,required this.user,});

  @override
  List<Object> get props => [action,user];
}
class showPostPlus extends PostEvent{
  final String action;
  final String user;
  showPostPlus( {required this.action,required this.user,});

  @override
  List<Object> get props => [action,user];
}
class addPost extends PostEvent{
  final String action;
  final post  Post;
  addPost({required this.Post,required this.action, });

  @override
  List<Object> get props => [Post,action];

}
class likePost extends PostEvent{
  final int index;
  final String action;
  final String userReceiNoti;
  likePost(   {required this.index,required this.action,required this.userReceiNoti,});

  @override
  List<Object> get props => [index,action,userReceiNoti];

}
class commentUpCountPost extends PostEvent{
  final String action;
  final int index; 
  commentUpCountPost(  {required this.index,required this.action,});

  @override
  List<Object> get props => [index,action];

}
class deletePost extends PostEvent{
  final String idpost;
  final List<imagePost> image;
  final int index;
  deletePost( {required this.idpost,required this.index,required this.image,});
   

  @override
  List<Object> get props => [idpost,index,image];

}
// class updatePost extends PostEvent{
//   final String idpost;
//   final List<XFile> image;
//   final String content;
//   final int index;
//   final String access;
//   final List<String> imageold;
//   updatePost(   {required this.access,required this.content, required this.idpost,required this.image,required this.index,required this.imageold,});
    

//   @override
//   List<Object> get props => [idpost,index,image,access,content];

// }
class updatePost extends PostEvent{
  final String idpost;
  final List<XFile> image;
  final String content;
  final int index;
  final String access;
  final List<String> imageold;
  updatePost(   {required this.access,required this.content, required this.idpost,required this.image,required this.index,required this.imageold,});
    

  @override
  List<Object> get props => [idpost,index,image,access,content];

}