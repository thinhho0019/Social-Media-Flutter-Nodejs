import 'package:appchat_socket/blocs/bloc_post/post_bloc.dart';
import 'package:appchat_socket/blocs/bloc_post_comment/post_comment_bloc.dart';
import 'package:appchat_socket/models/post.dart';
import 'package:appchat_socket/repostiory/post_repository.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:appchat_socket/view/widget/post/input_comment.dart';
import 'package:appchat_socket/view/widget/post/post_comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class componentLikeAndComment extends StatelessWidget {
  final String action;
  final int index;
  final post p;
  const componentLikeAndComment({
    Key? key,
    required this.p,
    required this.index, required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: Row(children: [
        Expanded(
          child: p.liked == true
              ? GestureDetector(
                  onTap: () {
                    context.read<PostBloc>().add(likePost(index: index,action: action,userReceiNoti: p.user.id));
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.solidHeart,
                            size: 18, color: GlobalColors.colorButtonLike),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Thích",
                          style: TextStyle(
                              fontFamily: "Roboto_regular",
                              color: GlobalColors.colorButtonLike,
                              fontSize: 12),
                        )
                      ],
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    context.read<PostBloc>().add(likePost(index: index,action: action,userReceiNoti: p.user.id));
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.heart,
                            size: 18, color: Colors.black),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Thích",
                          style: TextStyle(
                              fontFamily: "Roboto_regular", fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
        ),
        Container(),
        Expanded(
            child: GestureDetector(
          onTap: () {
            showModalComment(context, p, index);
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.transparent)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.comment,
                  size: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                const Text(
                  "Bình luận",
                  style: TextStyle(fontFamily: "Roboto_regular", fontSize: 12),
                )
              ],
            ),
          ),
        )),
      ]),
    );
  }

  //show model comment
  Future<dynamic> showModalComment(BuildContext context, post post, int index) {
    final textEdingting = TextEditingController();
    final postConmmentBloc = PostCommentBloc(postRe: postRe);
    final String currentReply = "";
    postConmmentBloc.add(PostCommentShow(post: p.id));
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: GlobalColors.mainColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.96,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: BlocProvider(
              create: (context) => postConmmentBloc,
              child: Container(
                child: Column(
                  children: [
                    
                    Expanded(child: BlocBuilder<PostBloc, PostState>(
                      builder: (context, state) {
                        if (state is PostShowed) {
                          return postCommentWidget(
                            p: action=="post"?state.listPost[index]:state.listPostUser[index],
                            textEditing: textEdingting,
                          );
                        }
                        return SizedBox();
                      },
                    )),
                    inputComment(
                      action: action,
                      textEditing: textEdingting,
                      bloc: postConmmentBloc,
                      p: post,
                      index: index,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      sharedPreferences.setString(keyShared.CURRENTREPLY, "");
      sharedPreferences.setString(keyShared.CURRENTREPLYINDEX, "");
    });
  }
}
 