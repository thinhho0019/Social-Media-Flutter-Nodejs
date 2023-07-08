import 'package:appchat_socket/blocs/bloc_post/post_bloc.dart';
import 'package:appchat_socket/goRouter/app_route.dart';
import 'package:appchat_socket/models/image_post.dart';
import 'package:appchat_socket/models/post.dart';
import 'package:appchat_socket/utils/StringUrlToXFile.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/view/screens.dart/post_screen/createPostScreen.dart';
import 'package:appchat_socket/view/widget/loading_widget_anim.dart';
import 'package:appchat_socket/view/widget/post/add_new_post.dart';
import 'package:appchat_socket/view/widget/post/like_and_comment.dart';
import 'package:appchat_socket/view/widget/post/show_count_like_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:appchat_socket/utils/format_time.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:appchat_socket/utils/key.dart';

class listPost extends StatelessWidget {
 
  final String action;
  final List<post> state;
  final ScrollPhysics scrollSingle;
  const listPost({
    Key? key,
    required this.scrollSingle,
    required this.state,
    required this.action 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
       
      physics: scrollSingle,
      itemCount: action=="user"?state.length: state.length+1,
      itemBuilder: (context, index) {
        return index >= state.length?const loadingWidget():Container(
          color: GlobalColors.mainColor,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: index == 0
                      ? Border(
                          bottom: BorderSide(
                          color: Color.fromARGB(255, 214, 213, 213),
                          width: 0.0,
                        ))
                      : Border(
                          top: BorderSide(
                          color: Color.fromARGB(255, 214, 213, 213),
                          width: 3.0,
                        )),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    InkWell(
                      onTap: () {
                        context.pushNamed("mainprofile", params: {
                          "userid":
                              state[index].user.id
                        });
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              height: 35,
                              width: 36,
                              child: ClipOval(
                                child: Image.network(
                                    fit: BoxFit.cover,
                                    state[index].user.avatar.contains("http")
                                    ?state[index].user.avatar
                                    :keyS.LOADIMAGEUSER+state[index].user.avatar),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  state[index].user.name,
                                  style: TextStyle(
                                      fontFamily: 'Robot_regular',
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      formatTime.convertTimePost(
                                          state[index].create_at),
                                      style: TextStyle(
                                          fontFamily: 'Roboto_light',
                                          fontSize: 10),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    stateAccess(
                                      index: state[index].access,
                                    )
                                  ],
                                ),
                              ],
                            )),
                            PopupMenuButton<String>(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0))),
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                if (state[index].user.id !=
                                    sharedPreferences
                                        .getString(keyShared.IDUSER))
                                  const PopupMenuItem<String>(
                                    value: 'report',
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.report),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Báo cáo',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto-regular'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                //check user
                                if (state[index].user.id ==
                                    sharedPreferences
                                        .getString(keyShared.IDUSER))
                                  PopupMenuItem<String>(
                                    value: 'remove',
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                                Icons.bookmark_remove_outlined),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Gỡ bài viết',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto-regular'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                if (state[index].user.id ==
                                    sharedPreferences
                                        .getString(keyShared.IDUSER))
                                  PopupMenuItem<String>(
                                    value: 'update',
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                                Icons.bookmarks_outlined),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Chỉnh sửa bài viết',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto-regular'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                              icon: Icon(
                                Icons.more_horiz,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onSelected: (String value) {
                                // Xử lý khi người dùng chọn một tùy chọn
                                switch(value){
                                  case "remove":
                                      showDialogDeletePost(context, index);
                                  case "update":
                                      Navigator.push(context,MaterialPageRoute(builder: (context) => createPostScreen(action: "user",titlePost: state[index].content, idpost: state[index].id, listImage: StringUrlToXFile.convertObjectImageToString(state[index].image),index: index, ),));
                                      
                                }
                              },

                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 5),
                        padding: EdgeInsets.all(5),
                        child: Text(
                          state[index].content,
                          style: TextStyle(
                              fontFamily: 'Roboto_regular', fontSize: 14),
                        )),
                    GestureDetector(
                      onTap: () {
                         
                        context.push(AppRoute.VIEWDETAILPOST,
                            extra: {"post": state[index], "index": index,"action":action});
                      },
                      child: Container(
                        width: double.infinity,
                        child: state[index].image.length == 1
                            ? Container(
                                height: 300,
                                child: Image.network(
                                  keyS.LOADIMAGE +
                                      state[index].image[0].image_url,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : showManyImage(
                                count: state[index].image.length,
                                image: state[index].image),
                      ),
                    ),
                    showCountLikeAndComment(p: state[index]),
                    componentLikeAndComment(p: state[index], index: index, action: action)
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> showDialogDeletePost(BuildContext context, int index) {
    return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Thông báo',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Bạn thật sự muốn xóa bài viết này'
                                          ,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Hủy',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            context.read<PostBloc>().add(deletePost(idpost: state[index].id, index: index,image: state[index].image));
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Đồng ý'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
  }
}

class showManyImage extends StatelessWidget {
  final int count;
  final List<imagePost> image;
  const showManyImage({
    Key? key,
    required this.count,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String a = keyS.LOADIMAGE + image[1].image_url;
    return count == 3
        ? StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: [
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: Container(
                  child: Image.network(
                    keyS.LOADIMAGE + image[0].image_url,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: Container(
                  child: Image.network(
                    keyS.LOADIMAGE + image[1].image_url,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: Container(
                  child: Image.network(
                    keyS.LOADIMAGE + image[2].image_url,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          )
        : count == 2
            ? StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1,
                    child: Container(
                      child: Image.network(
                        keyS.LOADIMAGE + image[0].image_url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1,
                    child: Container(
                      child: Image.network(
                        keyS.LOADIMAGE + image[1].image_url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              )
            : StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1,
                    child: Container(
                      child: Image.network(
                        keyS.LOADIMAGE + image[0].image_url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1,
                    child: Container(
                      child: Image.network(
                        keyS.LOADIMAGE + image[1].image_url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      child: Container(
                        child: Stack(
                          children: [
                            Container(
                              height: double.infinity,
                              child: Image.network(
                                keyS.LOADIMAGE + image[2].image_url,
                                color: Colors.white.withOpacity(0.5),
                                colorBlendMode: BlendMode.modulate,
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Center(
                              child: Text(
                                "Xem thêm",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Roboto_regular',
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          ],
                        ),
                      )),
                ],
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
                    ? Icon(
                        Icons.lock,
                        size: 11,
                      )
                    : null);
  }
}
