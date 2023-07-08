part of 'post_access_cubit.dart';


enum AccessStatus{public,friend,private }
class PostAccessState extends Equatable {
  final AccessStatus status;
  const PostAccessState.public({this.status=AccessStatus.public});
  const PostAccessState.friend({this.status=AccessStatus.friend});
  const PostAccessState.private({this.status=AccessStatus.private});
  @override
  List<Object> get props => [status];
}

 
