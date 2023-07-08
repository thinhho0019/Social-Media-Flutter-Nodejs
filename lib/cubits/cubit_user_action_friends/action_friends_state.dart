part of 'action_friends_cubit.dart';

class ActionFriendsState extends Equatable {
  const ActionFriendsState();

  @override
  List<Object> get props => [];
}

class ActionFriendsLoading extends ActionFriendsState {}
class ActionFriendsAddFriend extends ActionFriendsState {} //when dont friends
class ActionFriendsCancleAwaitFriends extends ActionFriendsState {} //when wait access 
class ActionFriendsCancleFriends extends ActionFriendsState {} //when is friends
class ActionFriendsAcceptFriends extends ActionFriendsState {} //when accept friends
class ActionFriendsMyProfile extends ActionFriendsState {} //when show my profile