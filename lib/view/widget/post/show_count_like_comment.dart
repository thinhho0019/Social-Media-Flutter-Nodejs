import 'package:appchat_socket/models/post.dart';
import 'package:flutter/material.dart';


class showCountLikeAndComment extends StatelessWidget {
  final post p;
   
  const showCountLikeAndComment({
    Key? key,required this.p 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5,right: 5),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(
          color: Colors.black,
          width: 0.1
        ))
      ),
      height: 30,
      child: Row(
        children: [
          Expanded(child: Container(
            padding: EdgeInsets.only(left: 10,top:2,bottom: 2),
            child: Text("${p.like_count} thích",style: TextStyle(
              fontSize: 11,
              fontFamily: 'Roboto_regular'),))),
          Expanded(child: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 10,top:2,bottom: 2),
            child: Text("${p.comment_count} bình luận",style: TextStyle(
              fontSize: 11,
              fontFamily: 'Roboto_regular'))))
        ],
      ),
    );
  }
}