

import 'package:appchat_socket/models/comment_post.dart';

class execList {
    static commentPost? checkListPostCommentChangeColor(List<commentPost> list,String id){
      try{
      commentPost? p =  list.firstWhere((element) => element.id==id);
       return p;
      }catch(e){
        return null;
      }
       
    }
}