import 'package:appchat_socket/blocs/bloc_post_comment/post_comment_bloc.dart';
import 'package:appchat_socket/models/comment_post.dart';
import 'package:appchat_socket/utils/format_time.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/utils/key.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:flutter/material.dart';
class cardComment extends StatefulWidget {
  final PostCommentShowed state;
  final int index;
  final edittext;
  final String action;
  final commentPost? indexreply;
  const cardComment(
      {super.key,
      required this.state,
      required this.index,
      this.edittext,
      required this.action,
      required this.indexreply});

  @override
  State<cardComment> createState() => _cardCommentState();
}

class _cardCommentState extends State<cardComment> {
  String namereply = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: widget.action == "comment" ? 40 : 26,
            width: widget.action == "comment" ? 40 : 26,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                    Radius.circular(widget.action == "comment" ? 20 : 13)),
                image: DecorationImage(
                    image: widget.action == "comment"
                        ? NetworkImage(
                            widget.state.listComment[widget.index].user.avatar.contains("http")
                            ?widget.state.listComment[widget.index].user.avatar
                            :keyS.LOADIMAGEUSER+ widget.state.listComment[widget.index].user.avatar)
                        : NetworkImage(widget.indexreply!.user.avatar.contains("http")
                        ?widget.indexreply!.user.avatar
                        :keyS.LOADIMAGEUSER+widget.indexreply!.user.avatar),fit: BoxFit.cover)),
          ),
          SizedBox(
            height: 4,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 200),
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                    color: GlobalColors.backgroundComment,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.action == "comment"
                          ? widget.state.listComment[widget.index].user.name
                          : widget.indexreply!.user.name,
                      softWrap: true,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontSize: 13),
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: widget.action == "reply"
                              ? widget.state.listComment[widget.index].user
                                      .name +
                                  " "
                              : "",
                          style: TextStyle(
                              fontFamily: 'Roboto_regular',
                              color: Colors.blue,
                              fontSize: 14)),
                      TextSpan(
                          text: widget.action == "comment"
                              ? widget.state.listComment[widget.index].comment
                              : widget.indexreply!.comment,
                          style: TextStyle(
                              fontFamily: 'Roboto_regular',
                              color: Colors.black,
                              fontSize: 14))
                    ]))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 15,
                      child: Text(
                        formatTime.convertTimePost(
                            widget.state.listComment[widget.index].create_at),
                        style:
                            TextStyle(fontFamily: 'Roboto_light', fontSize: 10),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    namereply != ""
                        ? Container(
                            height: 15,
                            child: Row(
                              children: [
                                Text(
                                  "Bạn đang trả lời " + namereply,
                                  style: TextStyle(
                                      fontFamily: 'Roboto_light',
                                      fontSize: 10,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    widget.edittext.text = "";
                                    setState(() {
                                      namereply = "";
                                    });
                                    sharedPreferences.setString(
                                        keyShared.CURRENTREPLY, "");
                                    sharedPreferences.setString(
                                        keyShared.CURRENTREPLYINDEX, "");
                                    sharedPreferences.setString(
                                        keyShared.CURRENTREPLYNAME, "");
                                  },
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    child: Icon(
                                      Icons.close,
                                      size: 15,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              widget.edittext.text =
                                  "${widget.state.listComment[widget.index].user.name + " "}";
                              setState(() {
                                namereply = widget
                                    .state.listComment[widget.index].user.name;
                              });
                              sharedPreferences.setString(
                                  keyShared.CURRENTREPLY,
                                  widget.state.listComment[widget.index].id);
                              sharedPreferences.setString(
                                  keyShared.CURRENTREPLYINDEX,
                                  widget.index.toString());
                              sharedPreferences.setString(
                                  keyShared.CURRENTREPLYNAME,
                                  widget.state.listComment[widget.index].user
                                      .name);
                            },
                            child: widget.state.listComment[widget.index].user
                                            .id !=
                                        sharedPreferences
                                            .getString(keyShared.IDUSER) &&
                                    widget.action == "comment"
                                ? Container(
                                    height: 15,
                                    child: Text(
                                      "Trả lời",
                                      style: TextStyle(
                                          fontFamily: 'Roboto_light',
                                          fontSize: 10),
                                    ),
                                  )
                                : SizedBox(),
                          ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
