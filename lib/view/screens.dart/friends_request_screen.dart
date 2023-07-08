import 'package:appchat_socket/blocs/friendBloc/friend_bloc_bloc.dart';
import 'package:appchat_socket/repostiory/user_repository.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/view/widget/friend/widget_wait_friend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
class friendsRequest extends StatelessWidget {
  final FriendBlocBloc _friendBlocBloc = FriendBlocBloc(friend: userRe);
  friendsRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _friendBlocBloc.add(FriendRequestShowed());
    return Material(
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
                              "Lời mời đã gửi",
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
                      return ListView.builder(
                        itemCount: state.friendlist.length,
                        itemBuilder: (context, index) => Container(
                          child: ListTile(
                            onTap: () {
                              showDialog(
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
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            'Hủy lời mời với ' +
                                                state.friendlist[index].name,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Hủy',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              ElevatedButton(
                                                onPressed: ()  {
                                                  Future<bool> a = userRe
                                                      .cancelWaitFriend(state
                                                          .friendlist[index]
                                                          .id,"cancelwait");
                                                  
                                                  _friendBlocBloc.add(FriendRequestShowed());
                                                context.pop(context);
                                                   
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
                            },
                            leading: Container(
                              width: 35,
                              height: 35,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                    state.friendlist![index].avatar),
                              ),
                            ),
                            // title: Text(snapshot.data![index].email),
                            subtitle: Text(state.friendlist![index].email),
                            title: Text(
                              state.friendlist![index].name,
                              style: TextStyle(),
                            ),
                            trailing: widgetWaitFriend(),
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
    );
  }
}
