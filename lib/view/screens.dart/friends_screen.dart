import 'package:appchat_socket/blocs/friendBloc/friend_bloc_bloc.dart';
import 'package:appchat_socket/goRouter/app_route.dart';
import 'package:appchat_socket/models/conversasion_model.dart';
import 'package:appchat_socket/repostiory/conversasion_repository.dart';
import 'package:appchat_socket/repostiory/user_repository.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/utils/key.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
class FriendsScreen extends StatelessWidget {
  final int currentIndex;
  final FriendBlocBloc _friendBlocBloc = FriendBlocBloc(friend: userRe);
  FriendsScreen({Key? key, required this.currentIndex}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    _friendBlocBloc.add(FriendShowed());
    return BlocProvider(
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
                            "Bạn bè",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontFamily: 'Roboto'),
                          )),
                    ),
                    Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: GlobalColors.backgroundAddFriends,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 9,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(top: 22, right: 17),
                      child: IconButton(
                          onPressed: () {
                            context.push(AppRoute.VIEWSEARCH);
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            Icons.person_add,
                            size: 18,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    color: GlobalColors.backgroundChat),
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
                              context.pushNamed("mainprofile", params: {
                          "userid":
                              state.friendlist[index].id
                        });
                            },
                            leading: ClipOval(
                              child: Container(
                                width: 46,
                                height: 45,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        state.friendlist![index].avatar.contains("http")
                                        ?state.friendlist![index].avatar
                                        :keyS.LOADIMAGEUSER+state.friendlist![index].avatar),
                                    fit: BoxFit.cover,
                                  ),
                                  
                                ),
                              ),
                            ),
                            // title: Text(snapshot.data![index].email),
                            subtitle: Text(
                              state.friendlist![index].email,
                              style: TextStyle(fontFamily: 'Roboto_regular'),
                            ),
                            title: Text(
                              state.friendlist![index].name,
                              style: TextStyle(fontFamily: 'Roboto_regular'),
                            ),
                            trailing: Container(
                              child: IconButton(
                                  onPressed: () async {
                                    //check conversasion
                                  conversasionModel data = await conRepo.getcheckconversasionByUserId(
                                      sharedPreferences.getString(keyShared.IDUSER)
                                      ,
                                       state.friendlist![index].id);
                                    context.pushNamed("message", params: {
                                      "conversasionid": data.id,
                                      "userid": state.friendlist![index].id,
                                      "avatar": state.friendlist![index].avatar,
                                      "name": state.friendlist![index].name,
                                      "seen":sharedPreferences.getString(keyShared.IDUSER)
                                    });
                                  },
                                  icon: Image.asset(
                                    "assets/icon/messenger.png",
                                    width: 25,
                                    filterQuality: FilterQuality.high,
                                  )),
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
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
