import 'dart:convert';

import 'package:appchat_socket/blocs/bloc/nav_bloc_bloc.dart';
import 'package:appchat_socket/blocs/conversasionBloc.dart/conversasion_bloc.dart';
import 'package:appchat_socket/blocs/userBloc/bloc_user_detail_edit/stream_user_detail_edit_bloc/stream_infor_user.dart';
import 'package:appchat_socket/repostiory/conversasion_repository.dart';
 
import 'package:appchat_socket/utils/socket_util.dart';
import 'package:appchat_socket/view/screens.dart/friends_screen.dart';
import 'package:appchat_socket/view/screens.dart/chat_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:appchat_socket/view/screens.dart/post_screen/postScreen.dart';
import 'package:appchat_socket/view/screens.dart/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';


class BottomNavigation extends StatefulWidget {
  BottomNavigation({required this.idpage});

  final int idpage;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final bottomNavigationBloc = NavBlocBloc();
  final ConversasionBloc _conversasionBloc = ConversasionBloc(repo: conRepo);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    streamInforU.getInforUser();
    SocketUtil.connect();
    SocketUtil.joinRoom(sharedPreferences.getString(keyShared.IDUSER));
    SocketUtil.listenToConversation((data) {
      Map<String, dynamic> con = json.decode(data);
      _conversasionBloc.add(conversasionShowAllChats());
      SocketUtil.socket?.emit('verify_message_received', con);
    });
    SocketUtil.updateNotifiUser(
      sharedPreferences.getString(keyShared.TOKENNOTIFICATION)
    , sharedPreferences.getString(keyShared.IDUSER));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.idpage == 2) {
      bottomNavigationBloc.add(BottomNavigationEvent.friends);
    } else if (widget.idpage == 1) {
      bottomNavigationBloc.add(BottomNavigationEvent.home);
    }
    return BlocBuilder<NavBlocBloc, int>(
      bloc: bottomNavigationBloc,
      builder: (context, currentIndex) {
        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: <Widget>[
              NewsScreen(currentIndex: currentIndex),
              ChatScreen(currentIndex: currentIndex),
              FriendsScreen(currentIndex: currentIndex),
              ProfileScreen(currentIndex: currentIndex),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(fontFamily: 'Roboto_light'),
            unselectedLabelStyle: TextStyle(fontFamily: 'Roboto_light'),
            currentIndex: currentIndex,
            onTap: (index) {
              switch (index) {
                case 0:
                  bottomNavigationBloc.add(BottomNavigationEvent.post);
                  break;
                case 1:
                  bottomNavigationBloc.add(BottomNavigationEvent.home);
                  break;
                case 2:
                  bottomNavigationBloc.add(BottomNavigationEvent.friends);
                  break;
                case 3:
                  bottomNavigationBloc.add(BottomNavigationEvent.profile);
                  break;
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.house,size: 20,),
                label: 'Bảng tin',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.solidMessage,size: 20,),
                label: 'Đoạn chat',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.userFriends,size: 20,),
                label: 'Bạn bè',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.solidUser,size: 20,),
                label: 'Cá nhân',
              ),
            ],
          ),
        );
      },
    );
  }
}
