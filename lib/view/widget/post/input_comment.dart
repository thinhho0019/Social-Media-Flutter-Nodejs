import 'package:appchat_socket/blocs/bloc_post/post_bloc.dart';
import 'package:appchat_socket/blocs/bloc_post_comment/post_comment_bloc.dart';
import 'package:appchat_socket/models/comment_post.dart';
import 'package:appchat_socket/models/post.dart';
import 'package:appchat_socket/utils/format_time.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class inputComment extends StatelessWidget {
  final String action;
  final textEditing;
  final bloc;
  final post p;
  final int index;
  const inputComment(
      {super.key,
      required this.textEditing,
      required this.bloc,
      required this.p,
      required this.index, required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
      padding: EdgeInsets.only(left: 10),
      constraints: BoxConstraints(maxHeight: 120),
      decoration: BoxDecoration(
        color: GlobalColors.backgroundComment,
        border: Border.all(color: Colors.black, width: 0.4),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textEditing,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Viết bình luận...",
                hintStyle: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Roboto_regular',
                    color: GlobalColors.textColorComment),
              ),
              
            ),
          ),
          IconButton(
              onPressed: () {
                String charText = textEditing.text;
                String currentName = sharedPreferences.getString(keyShared.CURRENTREPLYNAME);
                String textReplace = charText.replaceAll(currentName,"");
                sharedPreferences.getString(keyShared.CURRENTREPLY)==""
                ?charText = textEditing.text
                :charText = textReplace;
                final user = {
                  "_id": sharedPreferences.getString(keyShared.IDUSER),
                  "name":
                      sharedPreferences.getString(keyShared.GOOGLENAMEDISPLAY),
                  "email": sharedPreferences.getString(keyShared.GOOGLEGMAIL),
                  "avatar": sharedPreferences.getString(keyShared.GOOGLEIMAGE)
                };
                final data = {
                  "post": p.id,
                  "user": user,
                  "comment":charText,
                  "create_at": formatTime.convertVNtoUtc(DateTime.now()),
                  'reply':[]
                };
                
                commentPost comment = commentPost.fromMap(data);
                BlocProvider.of<PostBloc>(context)
                    .add(commentUpCountPost(index: index,action: action));
                bloc.add(PostCommentAdd(comment: comment,index :index));
                textEditing.text = "";
               
              },
              icon: Icon(
                Icons.send,
                color: GlobalColors.colorButtonSent,
              ))
        ],
      ),
    );
  }
}
