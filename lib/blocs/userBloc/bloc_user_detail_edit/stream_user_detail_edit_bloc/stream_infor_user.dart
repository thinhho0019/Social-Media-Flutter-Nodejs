


import 'dart:async';
import 'package:appchat_socket/models/user_model.dart';
import 'package:appchat_socket/repostiory/user_repository.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
class streamInforUser{
  final avatar  = StreamController<String>.broadcast();
  void getInforUser()async{
    userModel user = await userRe.getUserInformation(sharedPreferences.getString(keyShared.IDUSER));
    sharedPreferences.setString(keyShared.GOOGLEIMAGE,user.avatar);
    avatar.sink.add(user.avatar);
  }
  void dispose(){
    avatar==null;
    
  }
}
streamInforUser streamInforU = streamInforUser();