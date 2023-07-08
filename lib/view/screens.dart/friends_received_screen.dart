import 'package:appchat_socket/blocs/friendBloc/friend_bloc_bloc.dart';
import 'package:appchat_socket/repostiory/user_repository.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';

class friendsReceiced extends StatelessWidget {
  final FriendBlocBloc _friendBlocBloc = FriendBlocBloc(friend: userRe);
  friendsReceiced({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    _friendBlocBloc.add(FriendReceivedShowed());
    return WillPopScope(
      onWillPop: () async {
        context.pop(context);
        return true;
      },
      child: Material(
        child: BlocProvider(
          create: (context) => _friendBlocBloc,
          child: SafeArea(
            child: Container(
              color: GlobalColors.mainColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.only(top: 25, left: 30),
                              child: Text(
                                "Lời mời đã nhận",
                                style: TextStyle(fontSize: 25),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: BlocBuilder<FriendBlocBloc, FriendBlocState>(
                    bloc: _friendBlocBloc,
                    builder: (context, state) {
                      if (state is FriendStateLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is FriendStateLoaded) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black))
                          ),
                          child: ListView.builder(
                            itemCount: state.friendlist.length,
                            itemBuilder: (context, index) => Container(
                              child: ListTile(
                                
                                leading: Container(
                                  width: 45,
                                  height: 45,
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                        state.friendlist![index].avatar),
                                  ),
                                ),
                                 
                                 
                                title: Text(
                                  state.friendlist![index].name,
                                  style: TextStyle(),
                                ),
                                subtitle: Row(
                                   
                                  children: [
                                    InkWell(
                                      onTap: (() {
                                        userRe.acceptAddFriends(
                                            state.friendlist[index].id);
                                        _friendBlocBloc
                                            .add(FriendReceivedShowed());
                                      }),
                                      child: Container(
                                          height: 30,
                                          width: 80,
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: HexColor("#40E0D0"),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                textAlign: TextAlign.center,
                                                "Chấp nhận",
                                                style: TextStyle(
                                                    fontFamily: 'Roboto_medium',
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          )),
                                    ),
                                     SizedBox(width: 20,),
                                    InkWell(
                                      onTap: () {
                                        userRe.cancelWaitFriend(
                                            state.friendlist[index].id,
                                            "cancle_wait_receiver");
                                        _friendBlocBloc
                                            .add(FriendReceivedShowed());
                                      },
                                      child: Container(
                                          height: 30,
                                          width: 80,
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: HexColor("#40E0D0"),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                textAlign: TextAlign.center,
                                                "Từ chối",
                                                style: TextStyle(
                                                    fontFamily: 'Roboto_medium',
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (state is FriendStateError) {
                        return Center(
                          child: Text("Đã có lỗi xảy ra!!vui lòng thử lại sau"),
                        );
                      } else if (state is FriendStateEmpty) {
                        return Center(
                            child: Text("Hãy kết nối với nhau !! Tìm bạn đi"));
                      }
                      return Center(
                          child: Text("Hãy kết nối với nhau !! Tìm bạn đi"));
                    },
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
