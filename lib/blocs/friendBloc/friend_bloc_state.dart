part of 'friend_bloc_bloc.dart';
 
class FriendBlocState extends Equatable {
  FriendBlocState();
  @override
  List<Object> get props => [];
}
 
class FriendStateLoading extends FriendBlocState {
  @override
  List<Object> get props => [];
}
class FriendStateLoaded extends FriendBlocState {
  List<userModel> friendlist;
  FriendStateLoaded({required this.friendlist});
  @override
  List<Object> get props => [friendlist];
}
class FriendStateEmpty extends FriendBlocState {
 
  FriendStateEmpty();
  @override
  List<Object> get props => [ ];
}
class FriendStateError extends FriendBlocState {
  String message = "No Found";
  FriendStateError({required this.message});
  @override
  List<Object> get props => [message];
}


