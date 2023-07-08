import 'package:appchat_socket/blocs/bloc_post/post_bloc.dart';
import 'package:appchat_socket/goRouter/app_route.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:appchat_socket/view/widget/post/add_new_post.dart';
import 'package:appchat_socket/view/widget/post/list_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NewsScreen extends StatefulWidget {
  final int currentIndex;
  NewsScreen({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  TextEditingController txtControllerSearch = TextEditingController();
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    context.read<PostBloc>().add(PostShowList(action: "post",user: sharedPreferences.getString(keyShared.IDUSER)));
    super.initState();
    _scrollController.addListener(() {
       if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // đã kéo đến cuối danh sách, tải thêm dữ liệu
    
         context.read<PostBloc>().add(showPostPlus(action: "post",user: sharedPreferences.getString(keyShared.IDUSER)));
      }
    });
  }

  //PostBloc _postBloc = PostBloc();
  @override
  Widget build(BuildContext context) {
    //_postBloc.add(PostShowList());
    Future refresh() async {
      context.read<PostBloc>().add(PostShowList(action: "post",user: sharedPreferences.getString(keyShared.IDUSER)));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: GlobalColors.mainColor,
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Bảng tin",
                style: TextStyle(
                    color: Colors.black, fontSize: 25, fontFamily: 'Roboto'),
              ),
            ),
            Container(
              decoration: BoxDecoration(),
              child: IconButton(
                  onPressed: () {
                    context.push(AppRoute.VIEWNOTIFICATION);
                  },
                  icon: Icon(
                    Icons.notifications_none_sharp,
                    color: Colors.black,
                  )),
            )
          ],
        ),
      ),
      body: SafeArea(
          child: RefreshIndicator(
              color: Colors.black,
              strokeWidth: 0.7,
              onRefresh: refresh,
              child:
                  SingleChildScrollView(
                     controller: _scrollController,
                    child: Column(
                      children: [
                        addNewPost(
                              action: "post",
                            ),
                        BlocBuilder<PostBloc, PostState>(builder: (context, state) {
                                  if (state is PostLoading) {
                        return Center(child: CircularProgressIndicator());
                                  } else if (state is PostShowed) {
                       if(state.listPost.length==0){
                              return SizedBox();
                            }else{
                               return listPost(scrollSingle: BouncingScrollPhysics(),state: state.listPost,action: "post" );
                            }
                       
                       
                                  } 
                                  return Center(child: Text("Đã xảy ra lỗi"));
                                }),
                      ],
                    ),
                  )
              )
              ),
    );
  }
}
 