import 'dart:async';
import 'package:image_picker/image_picker.dart';
class postImageBloc{

  final postImageController  = StreamController<List<XFile>>.broadcast();
  void start(){
     
  }
  void dispose(){
    postImageController.close();
 
  }
}
postImageBloc postImage = postImageBloc();