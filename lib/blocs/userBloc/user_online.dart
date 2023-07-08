


import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:appchat_socket/models/user_model.dart';

class userBlocOnline{

  final userControllerOnline  = StreamController<String>.broadcast();
 
  void dispose(){
    userControllerOnline.close();
 
  }
}
userBlocOnline userOnline = userBlocOnline();