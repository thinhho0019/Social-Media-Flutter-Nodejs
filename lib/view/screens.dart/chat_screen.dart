import 'dart:convert';
import 'package:appchat_socket/blocs/conversasionBloc.dart/conversasion_bloc.dart';
import 'package:appchat_socket/repostiory/conversasion_repository.dart';
import 'package:appchat_socket/utils/format_time.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:appchat_socket/utils/socket_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
class ChatScreen extends StatefulWidget {
  final int currentIndex;
  ChatScreen({Key? key, required this.currentIndex}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ConversasionBloc _conversasionBloc = ConversasionBloc(repo: conRepo);
  TextEditingController txtControllerSearch = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SocketUtil.listenToConversation((data) {
      Map<String, dynamic> con = json.decode(data);
      _conversasionBloc.add(conversasionShowAllChats());
      SocketUtil.socket?.emit('verify_message_received', con);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("thongbao:" + "da huy event listen");
    //SocketUtil.cancelEventListenConversation();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("thongbao:" + "da mo event listen");
  }

  @override
  Widget build(BuildContext context) {
    _conversasionBloc.add(conversasionShowAllChats());
    return BlocProvider(
      create: (context) => _conversasionBloc,
      child: SafeArea(
        child: Container(
          color: GlobalColors.mainColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(top: 0, left: 30),
                  child: Text(
                    "Đoạn chat",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'Roboto'),
                  )),
              //search
              Container(
                margin: EdgeInsets.only(left: 20,right: 10),
                child: SearchBarAnimation(textEditingController: txtControllerSearch,
                hintText: "Tìm kiếm",
                  textInputType: TextInputType.name,
                 isOriginalAnimation:false,
                  trailingWidget:const Icon(
                              Icons.search,
                              size: 20,
                              color: Colors.black,
                            ),
                  enableKeyboardFocus: true,
                   secondaryButtonWidget: const Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.black,
                            ),
                   buttonWidget: const Icon(
                              Icons.search,
                              size: 20,
                              color: Colors.black,
                            ),),
              ),
               
              //ContainerSearch(txtControllerSearch: txtControllerSearch),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    color: GlobalColors.backgroundChat),
                child: BlocBuilder<ConversasionBloc, ConversasionState>(
                  builder: (context, state) {
                    if (state is ConversasionLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is ConversasionShowed) {
                      String a = state.converList[0].members[0]['_id'];
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.converList.length,
                        itemBuilder: (context, index) {
                          var countMessage =
                              state.converList[index].messages.length;
                          var checkCurrentUser =
                              sharedPreferences.getString(keyShared.IDUSER) ==
                                      state.converList[index].members[0]['_id']
                                  ? 0
                                  : 1;
                          return Container(
                            child: ListTile(
                              onTap: () {
                                context.pushNamed("message", params: {
                                  "conversasionid": state.converList[index].id,
                                  "userid": checkCurrentUser == 0
                                      ? state.converList[index].members[1]
                                          ['_id']
                                      : state.converList[index].members[0]
                                          ['_id'],
                                  "avatar": checkCurrentUser == 0
                                      ? state.converList[index].members[1]
                                          ['avatar']
                                      : state.converList[index].members[0]
                                          ['avatar'],
                                  "name": checkCurrentUser == 0
                                      ? state.converList[index].members[1]
                                          ['name']
                                      : state.converList[index].members[0]
                                          ['name'],
                                  "seen": state.converList[index].messages[countMessage-1]['sender']
                                  ==sharedPreferences.getString(keyShared.IDUSER)
                                  ?"dont":"active"
                                });
                              },
                              leading: Container(
                                height: 46,
                                width: 46,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(23),
                                  image:  DecorationImage(
                                      image: checkCurrentUser == 0?
                                  NetworkImage(state.converList[index]
                                        .members[1]['avatar'])
                                  :NetworkImage(state.converList[index]
                                        .members[0]['avatar']),
                                ),
                                
                                  ),
                              ),
                              title: checkCurrentUser == 0
                                  ? Text(
                                      state.converList[index].members[1]
                                          ['name'],
                                      style: state.converList[index]
                                                      .messages[countMessage - 1]
                                                  ['status'] ==
                                              "seen"
                                          ? TextStyle(
                                              fontFamily: "Roboto_regular",
                                              fontSize: 17,
                                              color: HexColor("585858"))
                                          : state.converList[index].messages[
                                                          countMessage - 1]
                                                      ['sender'] !=
                                                  sharedPreferences.getString(
                                                      keyShared.IDUSER)
                                              ? TextStyle(
                                                  fontFamily: "Roboto_regular",
                                                  fontSize: 17,
                                                  color: Colors.black)
                                              : TextStyle(
                                                  fontFamily: "Roboto_regular",
                                                  fontSize: 17,
                                                  color: HexColor("585858")))
                                  : Text(state.converList[index].members[0]['name'],
                                      style: state.converList[index].messages[countMessage - 1]['status'] == "seen"
                                          ? TextStyle(fontFamily: "Roboto_regular", fontSize: 17, color: HexColor("585858"))
                                          : state.converList[index].messages[countMessage - 1]['sender'] != sharedPreferences.getString(keyShared.IDUSER)
                                              ? TextStyle(fontFamily: "Roboto_regular", fontSize: 17, color: Colors.black)
                                              : TextStyle(fontFamily: "Roboto_regular", fontSize: 17, color: HexColor("585858"))),
                              subtitle: Text(
                                state.converList[index]
                                                .messages[countMessage - 1]
                                            ['sender'] ==
                                        sharedPreferences
                                            .getString(keyShared.IDUSER)
                                    ? "Bạn: " +
                                        state.converList[index]
                                            .messages[countMessage - 1]['text']
                                    : state.converList[index]
                                        .messages[countMessage - 1]['text'],
                                style: state.converList[index]
                                                .messages[countMessage - 1]
                                            ['status'] ==
                                        "seen"
                                    ? TextStyle(
                                        fontFamily: "Roboto_light",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: HexColor("585858"))
                                    : state.converList[index]
                                                    .messages[countMessage - 1]
                                                ['sender'] !=
                                            sharedPreferences
                                                .getString(keyShared.IDUSER)
                                        ? TextStyle(
                                            fontFamily: "Roboto_regular",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Colors.black)
                                        : TextStyle(
                                            fontFamily: "Roboto_light",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: HexColor("585858")),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                formatTime.convertUtcToVnConversasion(state
                                    .converList[index]
                                    .messages[countMessage - 1]['created_at']),
                                style: state.converList[index]
                                                .messages[countMessage - 1]
                                            ['status'] ==
                                        "seen"
                                    ? TextStyle(
                                        fontFamily: "Roboto_medium",
                                        fontSize: 10,
                                        color: HexColor("585858"))
                                    : state.converList[index]
                                                    .messages[countMessage - 1]
                                                ['sender'] !=
                                            sharedPreferences
                                                .getString(keyShared.IDUSER)
                                        ? TextStyle(
                                            fontFamily: "Roboto_regular",
                                            fontSize: 10)
                                        : TextStyle(
                                            fontFamily: "Roboto_medium",
                                            fontSize: 10,
                                            color: HexColor("585858")),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is ConversasionEmpty) {
                      return Center(
                        child: Text("Trống"),
                      );
                    } else if (state is ConversasionError) {
                      return Center(
                        child: Text("Trống"),
                      );
                    }
                    return Center(
                      child: Text("Trống"),
                    );
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
