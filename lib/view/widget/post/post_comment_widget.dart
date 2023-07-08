import 'package:appchat_socket/blocs/bloc_post_comment/post_comment_bloc.dart';
 
import 'package:appchat_socket/models/post.dart';
 
import 'package:appchat_socket/view/widget/post/cart_comment_widget.dart';
import 'package:appchat_socket/view/widget/post/expandsion_title_comment.dart';

import 'package:appchat_socket/view/widget/post/show_count_like_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class postCommentWidget extends StatefulWidget {
  final textEditing;
  final post p;

  postCommentWidget({Key? key, required this.p, required this.textEditing})
      : super(key: key);

  @override
  State<postCommentWidget> createState() => _postCommentWidgetState();
}

class _postCommentWidgetState extends State<postCommentWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCommentBloc, PostCommentState>(
      builder: (context, state) {
        if (state is PostCommentLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PostCommentShowed) {
          if (state.listComment.length == 0) {
            return Column(
              children: [
                Container(
                  height: 35,
                  child: showCountLikeAndComment(p: widget.p),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Hãy là người đầu tiên bình luận bài viết này.",
                      style: TextStyle(fontFamily: 'Roboto'),
                    ),
                  ),
                )
              ],
            );
          }
          return Column(
            children: [
              Container(
                height: 35,
                child: showCountLikeAndComment(p: widget.p),
              ),
              Expanded(
                child: Container(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: state.listComment.length,
                    itemBuilder: (context, index) {
                      return Container(child: Column(
                        children: [
                          cardComment(state: state, index: index,edittext: widget.textEditing,action: "comment",indexreply: null),
                          state.listComment[index].userReply.length>0
                          ?ExpansionTileComment(state: state,index: index,edittext: widget.textEditing)
                          :SizedBox(),
                        ],
                      ));
                    },
                  ),
                ),
              ),
            ],
          );
        }
        return Center(child: Text("Đã xảy ra lỗi vui lòng thử lại sau"));
      },
    );
  }

  
}



