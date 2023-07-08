
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
class streamImageEditProfileBloc{
  final avatarController  = StreamController<XFile?>.broadcast();
  final backgroundController  = StreamController<XFile?>.broadcast();
  void dispose(){
    avatarController==null;
    backgroundController==null;
  }
}
streamImageEditProfileBloc imageEditProfile = streamImageEditProfileBloc();