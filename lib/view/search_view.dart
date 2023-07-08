import 'package:appchat_socket/api/api_search.dart';
import 'package:appchat_socket/blocs/friendBloc/friend_bloc_bloc.dart';
import 'package:appchat_socket/blocs/userBloc/user_bloc.dart';
import 'package:appchat_socket/models/user_model.dart';
import 'package:appchat_socket/repostiory/user_repository.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/utils/key.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:appchat_socket/view/widget/friend/widget_accept_friend.dart';
import 'package:appchat_socket/view/widget/friend/widget_my_friend.dart';
import 'package:appchat_socket/view/widget/friend/widget_no_friend.dart';
import 'package:appchat_socket/view/widget/friend/widget_wait_friend.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class SearchView extends StatefulWidget {
  SearchView({super.key});
  @override
  State<SearchView> createState() => _SearchViewState();
}
class _SearchViewState extends State<SearchView> {
  TextEditingController txtControllerSearch = TextEditingController();
  List<userModel> totalUser = [];
  List<userModel> searchUser = [];
  FriendBlocBloc friendBlocBloc = FriendBlocBloc(friend: userRe);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void search(String searchQuery) async {
    totalUser = [];
    searchUser = [];
    if (searchQuery.length >= 3) {
      totalUser = await apiSearch.getAllUserSearch();
      late userModel userSender;
      List<String> userIdSend = [];
      totalUser.forEach((element) {
        if (element.id == sharedPreferences.getString(keyShared.IDUSER)) {
          userSender = element;
        }
      });
      userSender.wait_friends.forEach((element) {
        if (element != null) {
          userIdSend.add(element);
        }
      });

      totalUser.forEach((user) {
        if (user.name.toLowerCase().contains(searchQuery.toLowerCase())) {
          user.friends.forEach((element) {
            if (element == sharedPreferences.getString(keyShared.IDUSER)) {
              user.status_friend = 3;
            }
          });
          user.wait_friends.forEach((element) {
            if (element == sharedPreferences.getString(keyShared.IDUSER)) {
              user.status_friend = 1;
            }
          });
          userIdSend.forEach((element) {
            if (element == user.id) {
              user.status_friend = 2;
            }
          });
          if (user.id != sharedPreferences.getString(keyShared.IDUSER)) {
            searchUser.add(user);
          }
        }
      });

      userbloc.userController.sink.add(searchUser);
    } else {
      userbloc.userController.sink.add([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
            child: Column(
          children: [
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 15, left: 15, bottom: 15),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        context.pop(context);
                      },
                    )),
                Container(
                    margin: EdgeInsets.only(top: 15, left: 30, bottom: 15),
                    child: Text(
                      "Tìm bạn bè",
                      style: TextStyle(fontSize: 22),
                    )),
              ],
            ),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(18),
                  color: GlobalColors.backgroundSearch),
              child: TextField(
                onChanged: (text) => search(text),
                controller: txtControllerSearch,
                style: TextStyle(fontSize: 15),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Nhập để tìm kiếm...",
                    prefixIcon: Icon(Icons.search)),
              ),
            ),
            Expanded(
              child: userSearchWidget(),
            ),
          ],
        )),
      ),
    );
  }

  Widget userSearchWidget() {
    return StreamBuilder(
      stream: userbloc.userController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text("Trống"),
          );
        } else {
          if (snapshot.data!.length <= 0) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.all(5),
              child: InkWell(
                onTap: () {
                  context.pushNamed("mainprofile", params: {
                          "userid":
                              snapshot.data![index].id
                        });
                },
                child: ListTile(
                    leading: Container(
                      width: 50,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(snapshot.data![index].avatar.contains("http")
                            ?snapshot.data![index].avatar:keyS.LOADIMAGEUSER +snapshot.data![index].avatar ),
                      ),
                    ),
                     
                    title: Text(
                      snapshot.data![index].name,
                      style: TextStyle(),
                    ),
                    trailing: InkWell(
                      onTap: () {
                        if (snapshot.data![index].status_friend == 0) {
                          //apiFriend.awaitAddFriend(snapshot.data![index].id);
              
                          userRe.sendAddFriends(snapshot.data![index].id);
              
                          searchUser
                              .firstWhere((element) =>
                                  element.id == snapshot.data![index].id)
                              .status_friend = 2;
                          userbloc.userController.sink.add(searchUser);
                        } else if (snapshot.data![index].status_friend == 3) {
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
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Hủy kết bạn với ' +
                                            snapshot.data![index].name,
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
                                              userRe.cancelWaitFriend(
                                                  snapshot.data![index].id,
                                                  "cancelfriends");
                                              searchUser
                                                  .firstWhere((element) =>
                                                      element.id ==
                                                      snapshot.data![index].id)
                                                  .status_friend = 0;
                                              userbloc.userController.sink
                                                  .add(searchUser);
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
                        } else if (snapshot.data![index].status_friend == 2) {
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
                                        'Thu hồi kết bạn với ' +
                                            snapshot.data![index].name,
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
                                              userRe.cancelWaitFriend(
                                                  snapshot.data![index].id,
                                                  "cancelwait");
                                              searchUser
                                                  .firstWhere((element) =>
                                                      element.id ==
                                                      snapshot.data![index].id)
                                                  .status_friend = 0;
                                              userbloc.userController.sink
                                                  .add(searchUser);
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
                      },
                      child: snapshot.data![index].status_friend == 0
                          ? widgetNoFriend()
                          : snapshot.data![index].status_friend == 2
                              ? widgetWaitFriend()
                              : snapshot.data![index].status_friend == 1
                                  ? widgetAcceptMyFriend(
                                      user: snapshot.data![index].id,
                                      searchUser: searchUser,
                                    )
                                  : snapshot.data![index].status_friend == 3
                                      ? widgetMyFriend()
                                      : null,
                    )),
              ),
            ),
          );
        }
      },
    );
  }
}
