import 'package:appchat_socket/blocs/bloc_post_comment/post_comment_bloc.dart';
import 'package:appchat_socket/view/widget/post/cart_comment_widget.dart';
import 'package:flutter/material.dart';
 
 

class ExpansionTileComment extends StatefulWidget {
  final PostCommentShowed state;
  final int index;
  final TextEditingController edittext;
  const ExpansionTileComment({super.key, required this.state, required this.index, required this.edittext});

  @override
  State<ExpansionTileComment> createState() => _ExpansionTileCommentState();
}

class _ExpansionTileCommentState extends State<ExpansionTileComment> {
  bool _customTileExpanded = false;
  List<Widget> ds =  [];
 
  @override
  Widget build(BuildContext context) {
        ds = widget.state.listComment[widget.index].userReply.map((e)=>cardComment(state: widget.state, index: widget.index,edittext:  widget.edittext,action: "reply",indexreply: e)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _customTileExpanded = true;
            });
          },
          child: Container(
            
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top:10,left: 65),
            child: _customTileExpanded?SizedBox():Text("xem thêm trả lời",
            style: TextStyle(
              fontFamily: 'Roboto_regular',
              fontSize: 12
            ),
            )),
        ),
        Visibility(
          visible: _customTileExpanded,
          child: AnimatedOpacity(
            opacity: _customTileExpanded ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: Container(
              margin: EdgeInsets.only(left: 45),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ds,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
