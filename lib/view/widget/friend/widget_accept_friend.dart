 
import 'package:appchat_socket/models/user_model.dart';
import 'package:appchat_socket/repostiory/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../blocs/userBloc/user_bloc.dart';

class widgetAcceptMyFriend extends StatelessWidget {
  final List<userModel> searchUser;
  final String user;
  widgetAcceptMyFriend({required this.searchUser, required this.user});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: (() {
            userRe.acceptAddFriends(user);
            searchUser
                .firstWhere((element) => element.id == user)
                .status_friend = 3;
            userbloc.userController.sink.add(searchUser);
          }),
          child: Container(
              height: 20,
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: HexColor("#40E0D0"),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    "Chấp nhận",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                        color: Colors.white),
                  ),
                ],
              )),
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            userRe.cancelWaitFriend(user, "cancle_wait_receiver");
            searchUser
                .firstWhere((element) => element.id == user)
                .status_friend = 0;
            userbloc.userController.sink.add(searchUser);
             
          },
          child: Container(
              height: 20,
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: HexColor("#40E0D0"),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    "Từ chối",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                        color: Colors.white),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
