import 'dart:async';
import 'dart:core';
import 'dart:core';

import 'package:appchat_socket/models/user_model.dart';

import 'package:appchat_socket/repostiory/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'friend_bloc_event.dart';
part 'friend_bloc_state.dart';

class FriendBlocBloc extends Bloc<FriendBlocEvent, FriendBlocState> {
  final userRepository _friendRepository;
  FriendBlocBloc({required userRepository friend })
      : _friendRepository = friend,
        super(FriendStateLoading()) {
    on<FriendShowed>(_onFriendListLoaded);
    on<FriendShowedAgain>(_FriendShowedAgain);
    on<FriendRequestShowed>(_FriendRequestShowed);
    on<FriendReceivedShowed>(_FriendReceivedShowed);
    on<FriendShowedForUser>(_FriendShowedForUser);
  }
  void _onFriendListLoaded(
      FriendShowed event, Emitter<FriendBlocState> emit) async {
    try {
      final friends = await _friendRepository.getMyFriend();
      if(friends.length>0){
        emit(FriendStateLoaded(friendlist: friends));
      }else {
        emit(FriendStateEmpty());
      }
      
    } catch (_) {
      emit(FriendStateError(message: "No Found"));
    }
  }
   

  void _FriendRequestShowed(FriendRequestShowed event, Emitter<FriendBlocState> emit) async{
    try {
      final friends = await _friendRepository.getMySentAddFriend();
      if(friends.length>0){
        emit(FriendStateLoaded(friendlist: friends));
      }else {
        emit(FriendStateEmpty());
      }
      
    } catch (_) {
      emit(FriendStateError(message: "No Found"));
    }
  }

  void _FriendReceivedShowed(FriendReceivedShowed event, Emitter<FriendBlocState> emit)async  {
    try {
      final friends = await _friendRepository.getMyReceivedAddFriend();
      if(friends.length>0){
        emit(FriendStateLoaded(friendlist: friends));
      }else {
        emit(FriendStateEmpty());
      }
      
    } catch (_) {
      emit(FriendStateError(message: "No Found"));
    }
  }

  void _FriendShowedAgain(FriendShowedAgain event, Emitter<FriendBlocState> emit)async  {
      
    try {
      final friends = await _friendRepository.getMyFriend();
      if(friends.length>0){
        emit(FriendStateLoaded(friendlist: friends));
      }else {
        emit(FriendStateEmpty());
      }
      
    } catch (_) {
      emit(FriendStateError(message: "No Found"));
    }
  }

  void _FriendShowedForUser(FriendShowedForUser event, Emitter<FriendBlocState> emit)async {
    try {
      final friends = await _friendRepository.getMyFriendForUser(event.user);
      if(friends.length>0){
        emit(FriendStateLoaded(friendlist: friends));
      }else {
        emit(FriendStateEmpty());
      }
      
    } catch (_) {
      emit(FriendStateError(message: "No Found"));
    }
  }
}
