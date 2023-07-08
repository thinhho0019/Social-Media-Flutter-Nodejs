 
import 'package:appchat_socket/blocs/userBloc/bloc_user_detail_edit/stream_user_detail_edit_bloc/stream_infor_user.dart';
import 'package:appchat_socket/service/notification_init.dart';
 
import 'package:appchat_socket/utils/key.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:appchat_socket/view/screens.dart/post_screen/createPostScreen.dart';
import 'package:flutter/material.dart';
class addNewPost extends StatelessWidget {
  final String action;
  const addNewPost({
    Key? key, required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      
      padding: EdgeInsets.only(top: 7, bottom: 7),
      decoration: BoxDecoration(
        color: Colors.white,
          border: Border(
        top: BorderSide(
          color: Color.fromARGB(255, 214, 213, 213),
          width: 1.0,
        ),
        bottom: BorderSide(
          color: Color.fromARGB(255, 214, 213, 213),
          width: 3.0,
        ),
      )),
      child: Row(
        children: [
          StreamBuilder(
            stream: streamInforU.avatar.stream,
            builder: (context, snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting){
                return CircularProgressIndicator();
              }
            return Container(
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            height: 35,
            width: 35,
            child: ClipOval(
              child: Image.network(
                  snapshot.data!.contains("http")?
                  snapshot.data!
                  :keyS.LOADIMAGEUSER+snapshot.data!,fit: BoxFit.cover,),
            ),
          );
          },),
          Expanded(
              child: InkWell(
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return createPostScreen(action:action,idpost: "",listImage: [],titlePost: "",);
                },
              ));
              
            },
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              padding: EdgeInsets.only(top: 7, bottom: 7, left: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                      color: Color.fromARGB(255, 158, 157, 157), width: 0.4)),
              child: Text(
                "Bạn đang nghĩ gì?",
                style: TextStyle(fontSize: 15, fontFamily: 'Roboto_normal'),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
