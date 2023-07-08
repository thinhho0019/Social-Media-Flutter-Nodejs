import 'dart:async';
import 'dart:convert';
import 'package:appchat_socket/blocs/conversasionBloc.dart/conversasion_bloc.dart';
import 'package:appchat_socket/blocs/userBloc/user_online.dart';
import 'package:appchat_socket/blocs/userBloc/user_typing.dart';
import 'package:appchat_socket/models/message_model.dart';
import 'package:appchat_socket/repostiory/conversasion_repository.dart';
import 'package:appchat_socket/utils/format_time.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/utils/key.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:appchat_socket/utils/socket_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
class chatView extends StatefulWidget {
    chatView(
      {super.key,
      required this.userid,
      required this.conversasionid,
      required this.avatar,
      required this.name, required this.seen});
  final String seen;
  final String userid;
  final String conversasionid;
  final String avatar;
  final String name;

  @override
  State<chatView> createState() => _chatViewState();
}

class _chatViewState extends State<chatView> {
  TextEditingController textController = TextEditingController();
  bool isTyping = false;
  String conversationId="";
  final ConversasionBloc _conversasionBloc = ConversasionBloc(repo: conRepo);
  final FocusNode _focusNode = FocusNode();
  final _scrollController = ScrollController();
  late Timer _timer;
 
  @override
  void initState() {
    // TODO: implement initState
 
    super.initState();
    
    //sent message status seen when first open chat
    if(widget.seen=='active'){
      final verify_message_seen = {
            "conversationid": widget.conversasionid,
            "sender": widget.userid,
          };
          SocketUtil.socket?.emit("verify_message_seen", verify_message_seen);
    }
    
    _focusNode.addListener(_onFocusChange);
    SocketUtil.listenToMessage((data) {
      Map<String, dynamic> con = json.decode(data);
      if (widget.conversasionid == con['conversasion']) {
        final verify_message = {
          "conversationid": widget.conversasionid,
          "sender": widget.userid
        };

        DateTime now = DateTime.now();

        messageModel a = messageModel(
            id: "null",
            sender: widget.userid,
            text: con['message'],
            status: 'seen',
            createdAt: formatTime.convertVNtoUtc(now));

        _conversasionBloc.add(receiverMessageChat(a));
        SocketUtil.socket?.emit("verify_message_seen", verify_message);
      }
    });
    SocketUtil.receive_verify_message_received((data) {
      _conversasionBloc.add(updateStatusMessage("received"));
    });
    SocketUtil.receive_verify_message_seen((data) {
      _conversasionBloc.add(updateStatusMessage("seen"));
    });
    SocketUtil.receiverTyping((data) {
      print("had data " + data);
      final temp = json.decode(data);
      if (temp['message'] == "true" &&
          temp['conversasion'] == widget.conversasionid) {
        userTyping.userControllerTyping.sink.add(true);
      } else {
        userTyping.userControllerTyping.sink.add(false);
      }
    });
    //first start socket online
    final mapOnline = {
      "ask": sharedPreferences.getString(keyShared.IDUSER),
      "ques": widget.userid
    };
    SocketUtil.requestOnline(mapOnline);
    //listening socket online
    _timer = Timer.periodic(
      Duration(minutes: 1),
      (timer) {
        SocketUtil.requestOnline(mapOnline);
      },
    );
    SocketUtil.receiveOnline((data) {
      final result = json.decode(data);

      if (result['is_online'] == "0") {
        userOnline.userControllerOnline.sink.add("Đã hoạt động " +
            formatTime.convertUtcToVn_online(result['last_online']) +
            " trước");
      } else {
        userOnline.userControllerOnline.sink.add("Đang hoạt động");
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
    SocketUtil.cancelEventReceiver();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // Mở TextField
      final data = {
        'from': sharedPreferences.getString(keyShared.IDUSER),
        'to': widget.userid,
        'message': "true",
        "conversasion": widget.conversasionid
      };

      SocketUtil.sendTyping(data);

      print('msg :TextField opened');
    } else {
      // Đóng TextField
      final data = {
        'from': sharedPreferences.getString(keyShared.IDUSER),
        'to': widget.userid,
        'message': "false",
        "conversasion": widget.conversasionid
      };

      SocketUtil.sendTyping(data);
      print('msg :TextField closed');
    }
  }

  void _hideKeyboard() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    _conversasionBloc.add(showMessageChats(
        conversasionid: widget.conversasionid, userid: widget.userid));
  
    bool _isListeningToMessages = false;
    return BlocListener<ConversasionBloc, ConversasionState>(
      bloc: _conversasionBloc,
      listener: (context, state) {
        
      },
      child: BlocProvider(
        create: (context) => _conversasionBloc,
        child: GestureDetector(
          onTap: _hideKeyboard,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              elevation: 3,
              toolbarHeight: 70,
              backgroundColor: GlobalColors.mainColor,
              title: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    child: CircleAvatar(
                        radius: 30, backgroundImage: NetworkImage(widget.avatar.contains("http")?widget.avatar:keyS.LOADIMAGEUSER+widget.avatar)),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Roboto_regular',
                            color: Colors.black),
                      ),
                      StreamBuilder(
                        stream: userOnline.userControllerOnline.stream,
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data.toString(),
                            style: const TextStyle(
                                fontSize: 10,
                                fontFamily: 'Roboto_light',
                                color: Colors.black),
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
              leading: Container(
                  child: IconButton(
                      onPressed: () {
                        context.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ))),
            ),
            body: SafeArea(
              child: Container(
                color: GlobalColors.mainColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: BlocBuilder<ConversasionBloc, ConversasionState>(
                      builder: (context, state) {
                        if (state is ConversasionLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is messageChatShowed) {
                           
                          return ListView.builder(
                            controller: _scrollController,
                            reverse: true,
                            itemCount: state.converList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          state.converList[index].sender ==
                                                  sharedPreferences
                                                      .getString(keyShared.IDUSER)
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          
                                          alignment: state
                                                      .converList[index].sender ==
                                                  sharedPreferences
                                                      .getString(keyShared.IDUSER)
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          constraints: BoxConstraints(
                                            minWidth: 70,
                                          ),
                                          margin: EdgeInsets.only(
                                              left: index == 0 &&
                                                      state.converList[index]
                                                              .sender ==
                                                          sharedPreferences
                                                              .getString(keyShared
                                                                  .IDUSER)
                                                  ? 5
                                                  : 18,
                                              top: 2,
                                              right: index == 0 ? 5 : 18),
                                          padding: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              left: 15,
                                              right: 15),
                                          decoration: BoxDecoration(
                                            
                                            color: state.converList[index]
                                                        .sender ==
                                                    sharedPreferences.getString(
                                                        keyShared.IDUSER)
                                                ? GlobalColors.backgroundChatRight
                                                : GlobalColors
                                                    .backgroundChatLeft,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          child: state.converList[index].text
                                                      .length >
                                                  30
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    color: state.converList[index]
                                                                .sender ==
                                                            sharedPreferences
                                                                .getString(
                                                                    keyShared
                                                                        .IDUSER)
                                                        ? GlobalColors
                                                            .backgroundChatRight
                                                        : GlobalColors
                                                            .backgroundChatLeft,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(10)),
                                                  ),
                                                  width: 220,
                                                  child: Text(
                                                    state.converList[index].text,
                                                    style: TextStyle(
                                                        color: state.converList[index]
                                                                .sender ==
                                                            sharedPreferences
                                                                .getString(
                                                                    keyShared
                                                                        .IDUSER)
                                                        ?GlobalColors.textChatRight:GlobalColors.textChatLeft,
                                                        fontFamily:
                                                            'Roboto_regular'),
                                                  ))
                                              : Text(
                                                  state.converList[index].text,
                                                  style: TextStyle(
                                                      color: state.converList[index]
                                                                .sender ==
                                                            sharedPreferences
                                                                .getString(
                                                                    keyShared
                                                                        .IDUSER)
                                                        ?GlobalColors.textChatRight:GlobalColors.textChatLeft,
                                                      fontFamily:
                                                          'Roboto_regular'),
                                                ),
                                        ),
                                        index == 0 &&
                                                state.converList[index].sender ==
                                                    sharedPreferences.getString(
                                                        keyShared.IDUSER)
                                            ? Container(
                                                margin: EdgeInsets.only(
                                                    right: 3, bottom: 3),
                                                child: state.converList[index]
                                                            .status ==
                                                        "sent"
                                                    ? Icon(
                                                        Icons
                                                            .check_circle_outline,
                                                        color: Colors.grey,
                                                        size: 15,
                                                      )
                                                    : state.converList[index]
                                                                .status ==
                                                            "received"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_rounded,
                                                            color: Colors.grey,
                                                            size: 15,
                                                          )
                                                        : Container(
                                                            height: 15,
                                                            width: 15,
                                                            child: ClipOval(
                                                              child:
                                                                  Image.network(
                                                                fit: BoxFit.cover,
                                                                widget.avatar,
                                                              ),
                                                            ),
                                                          ),
                                              )
                                            : Container(child: Text("")),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else if (state is ConversasionEmpty) {
                          return Center(
                            child: const Text(
                              "Hãy bắt đầu trò chuyện!!",
                              style: TextStyle(fontFamily: 'Roboto'),
                            ),
                          );
                        }
                        return Center(
                          child: const Text("Hãy bắt đầu trò chuyện!!",
                              style: TextStyle(fontFamily: 'Roboto')),
                        );
                      },
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder(
                            stream: userTyping.userControllerTyping.stream,
                            builder: (context, snapshot) {
                              return Container(
                                  height: 10,
                                  margin: EdgeInsets.only(left: 20),
                                  child: snapshot.data == true
                                      ? TypingIndicator(isTyping: isTyping)
                                      : Text(""));
                            },
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(left: 10, bottom: 10, top: 10),
                            height: 60,
                            width: double.infinity,
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                // GestureDetector(
                                //   onTap: () {},
                                //   child: Container(
                                //     height: 30,
                                //     width: 30,
                                //     decoration: BoxDecoration(
                                //       color: Colors.lightBlue,
                                //       borderRadius: BorderRadius.circular(30),
                                //     ),
                                //     child: Icon(
                                //       Icons.add,
                                //       color: Colors.white,
                                //       size: 20,
                                //     ),
                                //   ),
                                // ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: textController,
                                    focusNode: _focusNode,
                                    decoration: InputDecoration(
                                        hintText: "Nhập tin nhắn...",
                                        hintStyle:
                                            TextStyle(color: Colors.black54),
                                        border: InputBorder.none),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                FloatingActionButton(
                                  onPressed: () {
                                    if (textController.text.isNotEmpty) {
                                      final data = {
                                        'from': sharedPreferences
                                            .getString(keyShared.IDUSER),
                                        'to': widget.userid,
                                        'message': textController.text,
                                        'conversasion': widget.conversasionid
                                      };
                                      final jsonData = json.encode(data);
                                      SocketUtil.sendMessage(data);
                                      DateTime now = DateTime.now();
                                      messageModel a = messageModel(
                                          id: "null",
                                          sender: data['from'] ?? "",
                                          text: data['message'] ?? "",
                                          createdAt:
                                              formatTime.convertVNtoUtc(now),
                                          status: 'sent');
                                      _conversasionBloc.add(sendMessageChat(a));
                                      textController.text = "";
                                    }
                                  },
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  backgroundColor: Colors.blue,
                                  elevation: 0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TypingIndicator extends StatelessWidget {
  final bool isTyping;

  const TypingIndicator({required this.isTyping});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        fontSize: 10.0,
        color: Colors.black,
        height: 0.2,
      ),
      child: AnimatedTextKit(
        animatedTexts: [
          WavyAnimatedText('Đang soạn tin nhắn...',
              speed: Duration(milliseconds: 200)),
        ],
        isRepeatingAnimation: true,
        onTap: () {
          print("Tap Event");
        },
      ),
    );
  }
}
