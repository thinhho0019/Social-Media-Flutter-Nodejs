import 'package:appchat_socket/models/post.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/utils/key.dart';
import 'package:appchat_socket/view/widget/post/like_and_comment.dart';
import 'package:appchat_socket/view/widget/post/show_count_like_comment.dart';
import 'package:flutter/material.dart';
import 'package:appchat_socket/utils/format_time.dart';
class deTailPostScreen extends StatelessWidget {
  final post postDetail;
  final String action;
  final int index;
  deTailPostScreen({super.key, required this.postDetail, required this.action, required this.index});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
        body: Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          child: Row(
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 10),
                      height: 35,
                      width: 35,
                      child: ClipOval(
                        child: Image.network(
                            fit: BoxFit.cover, postDetail.user.avatar.contains("http")
                            ?postDetail.user.avatar:keyS.LOADIMAGEUSER+postDetail.user.avatar),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          postDetail.user.name,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Text(
                              formatTime.convertTimePost(postDetail.create_at),
                              style: TextStyle(
                                  fontFamily: 'Roboto-light', fontSize: 10),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            stateAccess(
                              index: postDetail.access,
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 7,
        ),
        Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 5),
            padding: EdgeInsets.all(5),
            child: Text(
              postDetail.content,
              style: TextStyle(fontFamily: 'Roboto_regular', fontSize: 14),
            )),
        Expanded(child: ListView.builder(
          itemCount: postDetail.image.length,
          itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: GlobalColors.colorCrossCenter,width: 5)),
                ),
                child: Image.network(keyS.LOADIMAGE+postDetail.image[index].image_url,fit: BoxFit.contain,),
              );
        },))
      ],
    ),
    bottomSheet: Container(
      height: 100,
      child: Column(
      children: [
        
      ],
    ))
    );
  }
}

class stateAccess extends StatelessWidget {
  final String index;
  const stateAccess({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 2),
        child: index == 'public'
            ? Icon(
                Icons.public,
                size: 11,
              )
            : index == 'friend'
                ? Icon(
                    Icons.people,
                    size: 11,
                  )
                : index == 'private'
                    ? Icon(Icons.lock)
                    : null);
  }
}
