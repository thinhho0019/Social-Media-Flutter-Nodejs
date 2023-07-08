import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
class postReplyComment{

  final postReplyCommentController  = StreamController<String>.broadcast();
  void start(){
     
  }
  void dispose(){
    postReplyCommentController.close();
 
  }
}
postReplyComment postReplyCommentStream = postReplyComment();