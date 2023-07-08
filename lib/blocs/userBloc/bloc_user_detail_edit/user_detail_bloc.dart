 
import 'dart:async';

import 'package:appchat_socket/blocs/userBloc/bloc_user_detail_edit/stream_user_detail_edit_bloc/stream_infor_user.dart';
import 'package:appchat_socket/models/user_detail.dart';
import 'package:appchat_socket/models/user_model.dart';
import 'package:appchat_socket/repostiory/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'user_detail_event.dart';
part 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  userRepository _userRe;
  UserDetailBloc(userRepository userR) :this._userRe=userR, super(UserDetaiLoading()) {
    on<showInformation>(_showInformation);
    on<updateProfile>(_updateProfile);
    on<updateImageAvatar>(_updateImageAvatar);
    on<updateImageBackground>(_updateImageBackground);
  }

  void  _showInformation(showInformation event, Emitter<UserDetailState> emit)async  {
    emit(UserDetaiLoading());
    try{
      userModel data = await _userRe.getUserInformation(event.user);
      emit(UserDetaiStopLoading());
      emit(UserShowInformation(user: data));
    }catch(e){
      emit(UserShowInformationError());
    }
  }

  void _updateProfile(updateProfile event, Emitter<UserDetailState> emit) async {
    final state = this.state;

    try{
      
      if(state is UserShowInformation){
        userModel data = state.user;
        await _userRe.updateProfile(data.user_detail.id, event.user.toMap());
        userDetail userD  = event.user;
        data.user_detail  = userD;  
        emit( UserShowInformation(user: data));
      }
      
    }catch(e){
      emit(UserShowInformationError());
    }
  }

  void _updateImageAvatar(updateImageAvatar event, Emitter<UserDetailState> emit) async {
    final state = this.state;
    try{
      
      if(state is UserShowInformation){
        userModel data = state.user;
         
        final result = await _userRe.uploadImageAvatar(event.fileimage, event.userid, event.namefileole);
       streamInforU.avatar.sink.add(result);
       userModel userResult = data.copyWith(
          avatar: result
        );
        emit( UserShowInformation(user: userResult));
      }
      
    }catch(e){
      emit(UserShowInformationError());
    }
    
}
  void _updateImageBackground(updateImageBackground event, Emitter<UserDetailState> emit)async {
    final state = this.state;
    try{
      
      if(state is UserShowInformation){
        userModel data = state.user;
        userDetail dataDetail = state.user.user_detail;
        final result = await _userRe.uploadImageBackground(event.fileimage, event.userid, event.namefileole);
        
       userModel userResult = data.copyWith(
          user_detail : dataDetail.copyWith(background_image: result)
        );
        emit( UserShowInformation(user: userResult));
      }
      
    }catch(e){
      emit(UserShowInformationError());
    }
  }

}