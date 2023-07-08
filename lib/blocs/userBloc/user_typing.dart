
import 'dart:async';
import 'package:bloc/bloc.dart';
 
class userBlocTyping{

  final userControllerTyping  = StreamController<bool>.broadcast();
 
  void dispose(){
     userControllerTyping==null;
 
  }
}
userBlocTyping userTyping= userBlocTyping();