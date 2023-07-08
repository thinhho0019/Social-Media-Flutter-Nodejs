import 'dart:math';

import 'package:appchat_socket/blocs/notificationBloc/notification_bloc.dart';
import 'package:appchat_socket/goRouter/app_route.dart';
import 'package:appchat_socket/utils/format_time.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/utils/key.dart';
import 'package:appchat_socket/view/widget/loading_widget_anim.dart';
import 'package:appchat_socket/view/widget/loading_widget_anim_single.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';

class notificationScreen extends StatefulWidget {
  const notificationScreen({super.key});

  @override
  State<notificationScreen> createState() => _notificationScreenState();
}

class _notificationScreenState extends State<notificationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<NotificationBloc>().add(NotificationEventShowNoti());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: GlobalColors.mainColor,
        title: Text(
          "Thông báo",
          style: TextStyle(fontFamily: 'Roboto_medium', color: Colors.black),
        ),
        leading: InkWell(
            onTap: () {
              context.pop();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if(state is NotificationLoading){
            return const loadingWidgetSingle();
          }else if(state is NotificationShowed){
            return state.data.length!=0?ListView.builder(
            itemCount: state.data.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: HexColor("#756f6e"), width: 0.1))),
                child: ListTile(
                  onTap: () {
                    context.pushNamed(AppRoute.VIEWDETAILPOST,
                            extra: {"post": state.data[index].p, "index": index,"action":"notification"});
                     
                  },
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                state.data[index].user.avatar.contains("http")
                                ?state.data[index].user.avatar
                                :keyS.LOADIMAGEUSER+state.data[index].user.avatar))),
                  ),
                  subtitle: Row(
               
                    children: [
                      Text(formatTime.convertUtcToVn_online(state.data[index].create_at)+" trước"
                      ,style: TextStyle(color: HexColor("#000000")
                      ,fontSize: 10,fontFamily: 'Roboto_light'))
                    ],
                  ),
                  title: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: state.data[index].user.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Roboto_medium')),
                      TextSpan(
                          text: state.data[index].type=="like"
                          ?" đã thích bài viết của bạn"
                          :" đã bình luận bài viết của bạn",
                          style: TextStyle(color: HexColor("#756f6e"))),
                    ]),
                  ),
                ),
              );
            },
          ):Center(child:Text("Bạn chưa có thông báo!"));
          }else if(state is NotificationError){
            return Center(child:Text("Đã xảy ra lỗi vui lòng thử lại!"));
          }
          return Center(child:Text("Đã xảy ra lỗi vui lòng thử lại!123"));
        },
      ),
    );
  }
}
