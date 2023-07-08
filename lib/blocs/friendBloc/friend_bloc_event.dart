part of 'friend_bloc_bloc.dart';
 
abstract class FriendBlocEvent extends Equatable {
  FriendBlocEvent();
  
}
class FriendShowedAgain extends FriendBlocEvent{
   
  @override
  List<Object> get props => [];
} 
class FriendShowed extends FriendBlocEvent{
   
  @override
  List<Object> get props => [];
} 
class FriendShowedForUser extends FriendBlocEvent{
  final String user;
  FriendShowedForUser({required this.user});
  @override
  List<Object> get props => [user];
} 
class FriendRequestShowed extends FriendBlocEvent{
   
  @override
  List<Object> get props => [];
} 
class FriendReceivedShowed extends FriendBlocEvent{
   
  @override
  List<Object> get props => [];
} 