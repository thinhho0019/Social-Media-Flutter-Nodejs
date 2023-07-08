import 'package:appchat_socket/repostiory/user_repository.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'action_friends_state.dart';

class ActionFriendsCubit extends Cubit<ActionFriendsState> {
  userRepository _userRepos;
  ActionFriendsCubit({ required userRepository userRepos}) : 
  this._userRepos=userRepos,super(ActionFriendsLoading());
  void checkFriends(String user) async {
    try {
      if(user!=sharedPreferences.getString(keyShared.IDUSER)){
        final check = await _userRepos.checkFriendsForUser(user);
        if(check=="friends"){
          
          emit(ActionFriendsCancleFriends()); 
        }else if(check=="cancleawait"){
          emit(ActionFriendsCancleAwaitFriends()); 
        }else if(check=="receiveaddfriend"){
          emit(ActionFriendsAcceptFriends()); 
        }else{
          emit(ActionFriendsAddFriend());
        }
      }else{
        emit(ActionFriendsMyProfile());
      }
      
       
    } catch (e) {
      print(e);
    }
  }
  void addFriends(String user)async {
    try {
      final friends = await _userRepos.sendAddFriends(user);
      emit(ActionFriendsCancleAwaitFriends());  
    } catch (e) {
      print(e);
    }
  }
  void acceptFriends(String user)async{
    try {
      final friends = await _userRepos.acceptAddFriends(user);
      emit(ActionFriendsCancleFriends());  
    } catch (e) {
      print(e);
    }
  }
  void cancleAwaitFriends(String user) async {
    try {
      final friends = await _userRepos.cancelWaitFriend(user, "cancelwait");
      emit(ActionFriendsAddFriend());
    } catch (e) {
      print(e);
    }
  }
  void cancleFriends(String user) async {
    try {
      final friends = await _userRepos.cancelWaitFriend(user, "cancelfriends");
      
        emit(ActionFriendsAddFriend());
      
    } catch (e) {
      print(e);
    }
  }
  void cancleAcceptFriends(String user) async {
    try {
      final friends = await _userRepos.cancelWaitFriend(user,"cancle_wait_receiver");
       emit(ActionFriendsAddFriend());
      
    } catch (e) {
      print(e);
    }
  }
}
