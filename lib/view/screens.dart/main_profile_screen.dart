import 'dart:io';

import 'package:appchat_socket/blocs/friendBloc/friend_bloc_bloc.dart';
import 'package:appchat_socket/blocs/userBloc/bloc_user_detail_edit/user_detail_bloc.dart';
import 'package:appchat_socket/cubits/cubit_user_action_friends/action_friends_cubit.dart';
import 'package:appchat_socket/goRouter/app_route.dart';
import 'package:appchat_socket/models/user_model.dart';
import 'package:appchat_socket/repostiory/user_repository.dart';
import 'package:appchat_socket/utils/format_time.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/utils/image_cropper.dart';
import 'package:appchat_socket/utils/key.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:appchat_socket/utils/snackbar_show_notification.dart';
import 'package:appchat_socket/view/screens.dart/image_screen.dart';
import 'package:appchat_socket/view/widget/loading_widget_anim.dart';
import 'package:appchat_socket/view/widget/loading_widget_anim_single.dart';
import 'package:appchat_socket/view/widget/post/add_new_post.dart';
import 'package:appchat_socket/view/widget/post/list_post.dart';
import 'package:appchat_socket/models/conversasion_model.dart';
import 'package:appchat_socket/repostiory/conversasion_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:appchat_socket/blocs/bloc_post/post_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'post_screen/createPostScreen.dart';

class mainProfileScreen extends StatefulWidget {
  final String user;
  const mainProfileScreen({super.key, required this.user});
  @override
  State<mainProfileScreen> createState() => _mainProfileScreenState();
}

class _mainProfileScreenState extends State<mainProfileScreen> {
  File? imageFile;
  File? imageFileBackground;
  final FriendBlocBloc _friendBlocBloc = FriendBlocBloc(friend: userRe);
  final UserDetailBloc _userDetailBloc = UserDetailBloc(userRe);
  bool showDialogLoading = true;
  final ActionFriendsCubit _friendsCubit =
      ActionFriendsCubit(userRepos: userRe);
  @override
  void initState() {
    // TODO: implement initState
    _friendBlocBloc.add(FriendShowedForUser(user: widget.user));
    _friendsCubit.checkFriends(widget.user);
    context
        .read<PostBloc>()
        .add(PostShowList(action: "user", user: widget.user));
    _userDetailBloc.add(showInformation(user: widget.user));
    super.initState();
  }

  Future _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  Future _pickImageBackground() async {
    final pickedImageBackground =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImageBackground != null) {
      setState(() {
        imageFileBackground = File(pickedImageBackground.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _friendBlocBloc,
        ),
        BlocProvider(
          create: (context) => _friendsCubit,
        ),
        BlocProvider(
          create: (context) => _userDetailBloc,
        ),
      ],
      child: BlocListener<UserDetailBloc, UserDetailState>(
        listener: (context, state) {
          if (state is UserDetaiLoading) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return loadingWidgetSingle();
              },
            );
          } else if (state is UserDetaiStopLoading) {
            context.pop();
          }
        },
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                  color: GlobalColors.mainColor,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<UserDetailBloc, UserDetailState>(
                          builder: (context, state) {
                            if (state is UserShowInformation) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 300,
                                    child: Stack(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      imageScreen(
                                                    imageUrl: state
                                                        .user
                                                        .user_detail
                                                        .background_image,
                                                  ),
                                                ));
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 270,
                                            child: Image.network(
                                              state.user.user_detail
                                                      .background_image
                                                      .contains("https")
                                                  ? state.user.user_detail
                                                      .background_image
                                                  : keyS.LOADIMAGEUSER +
                                                      state.user.user_detail
                                                          .background_image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 10,
                                          bottom: 0,
                                          child: InkWell(
                                            onTap: () {
                                              widget.user ==
                                                      sharedPreferences
                                                          .getString(
                                                              keyShared.IDUSER)
                                                  ? showModalBottomSheet(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                            height: 120.0,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    context
                                                                        .pop();
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              imageScreen(
                                                                            imageUrl:
                                                                                state.user.avatar,
                                                                          ),
                                                                        ));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border(bottom: BorderSide(color: Colors.black, width: 0.1))),
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                10),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    height: 60,
                                                                    width: double
                                                                        .infinity,
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .remove_red_eye_rounded,
                                                                          color:
                                                                              Colors.black,
                                                                          size:
                                                                              17,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                            "Xem hình đại diện"),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    context
                                                                        .pop();
                                                                    await _pickImage();
                                                                    imageFile =
                                                                        await imageCropper
                                                                            .cropImage(imageFile);
                                                                    if (imageFile !=
                                                                        null) {
                                                                      XFile?
                                                                          img =
                                                                          await XFile(
                                                                              imageFile!.path);
                                                                      _userDetailBloc.add(updateImageAvatar(
                                                                          fileimage:
                                                                              img,
                                                                          userid: state
                                                                              .user
                                                                              .id,
                                                                          namefileole: state
                                                                              .user
                                                                              .avatar));
                                                                      notificationSnackbar.showSnackBar(
                                                                          context,
                                                                          "Bạn đã thay đổi ảnh đại diện");
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                10),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    height: 60,
                                                                    width: double
                                                                        .infinity,
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .image_outlined,
                                                                          color:
                                                                              Colors.black,
                                                                          size:
                                                                              17,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                            "Thay đổi hình đại diện"),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ));
                                                      },
                                                    )
                                                  :  
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        imageScreen(
                                                      imageUrl:
                                                          state.user.avatar,
                                                    ),
                                                  ));
                                            },
                                            child: Container(
                                              height: 150,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 2.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          75)),
                                              child: ClipOval(
                                                child: Image.network(
                                                  state.user.avatar
                                                          .contains("https")
                                                      ? state.user.avatar
                                                      : keyS.LOADIMAGEUSER +
                                                          state.user.avatar,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 30,
                                          left: 12,
                                          // button back
                                          child: Container(
                                            height: 37,
                                            width: 37,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                color: GlobalColors
                                                    .backGroundColorButtonBack),
                                            child: InkWell(
                                              onTap: () {
                                                context.pop();
                                              },
                                              child: Icon(
                                                Icons.arrow_back,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 12,
                                          bottom: 40,
                                          // button back
                                          child: InkWell(
                                            onTap: () async {
                                              await _pickImageBackground();
                                              imageFileBackground =
                                                  await imageCropper.cropImage(
                                                      imageFileBackground);
                                              if (imageFileBackground != null) {
                                                XFile? img = await XFile(
                                                    imageFileBackground!.path);
                                                _userDetailBloc.add(
                                                    updateImageBackground(
                                                        fileimage: img,
                                                        userid: state.user
                                                            .user_detail.id,
                                                        namefileole:
                                                            state.user.user_detail.background_image));
                                                notificationSnackbar.showSnackBar(
                                                    context,
                                                    "Bạn đã thay đổi ảnh bìa");
                                              }
                                            },
                                            child: widget.user ==
                                                    sharedPreferences.getString(
                                                        keyShared.IDUSER)
                                                ? Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20)),
                                                        color: GlobalColors
                                                            .backGroundColorButtonChoseImage),
                                                    child: Icon(
                                                      Icons.camera_enhance,
                                                      color: Colors.black,
                                                      size: 15,
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ),
                                        ),
                                        Positioned(
                                          left: 125,
                                          bottom: 10,
                                          // button back
                                          child: InkWell(
                                            onTap: () async {
                                              await _pickImage();
                                              imageFile = await imageCropper
                                                  .cropImage(imageFile);
                                              if (imageFile != null) {
                                                XFile? img = await XFile(
                                                    imageFile!.path);
                                                _userDetailBloc.add(
                                                    updateImageAvatar(
                                                        fileimage: img,
                                                        userid: state.user.id,
                                                        namefileole:
                                                            state.user.avatar));
                                                notificationSnackbar.showSnackBar(
                                                    context,
                                                    "Bạn đã thay đổi ảnh đại diện");
                                              }
                                            },
                                            child: widget.user ==
                                                    sharedPreferences.getString(
                                                        keyShared.IDUSER)
                                                ? Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20)),
                                                        color: GlobalColors
                                                            .backGroundColorButtonChoseImage),
                                                    child: Icon(
                                                      Icons.camera_enhance,
                                                      color: Colors.black,
                                                      size: 15,
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //container name
                                  Container(
                                    margin: EdgeInsets.only(left: 12, top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.user.name,
                                          style: TextStyle(
                                              fontFamily: 'Roboto_medium',
                                              fontSize: 25),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        //bio
                                        if (state.user.user_detail.bio !=
                                            "null")
                                          Text(
                                            state.user.user_detail.bio,
                                            style: TextStyle(
                                                fontFamily: 'Roboto_medium',
                                                fontSize: 15),
                                          ),
                                      ],
                                    ),
                                  ),
                                  //container if else client or for me
                                  yourProfileTop(state.user.name, state.user),

                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 5, bottom: 5),
                                    child: Divider(
                                      color: Colors.black,
                                    ),
                                  ),
                                  profileBottom(state.user),
                                  Container(
                                    padding: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Divider(
                                      color: Colors.black,
                                    ),
                                  ),
                                  //friends
                                  Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 5,
                                          bottom: 5),
                                      child: Text(
                                        "Bạn bè",
                                        style: TextStyle(
                                            fontSize: 20, fontFamily: 'Roboto'),
                                      )),
                                  Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 5,
                                          bottom: 5),
                                      child: Text(
                                        "${state.user.friends.length} người bạn",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Roboto_light'),
                                      )),
                                  Container(
                                      height: state.user.friends.length > 3
                                          ? 250
                                          : 150,
                                      width: double.infinity,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: showMyfriends(_userDetailBloc)),
                                  Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                        BlocBuilder<PostBloc, PostState>(
                            builder: (context, state) {
                          if (state is PostLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is PostShowed) {
                            if (state.listPostUser.length == 0) {
                              return SizedBox();
                            } else {
                              return listPost(
                                scrollSingle: BouncingScrollPhysics(),
                                state: state.listPostUser,
                                action: "user",
                              );
                            }
                          }
                          return Center(child: Text("Đã xảy ra lỗi"));
                        })
                      ])),
            ),
          ),
        ),
      ),
    );
  }

  BlocProvider showMyfriends(UserDetailBloc userDetailB) {
    return BlocProvider(
      create: (context) => _friendBlocBloc,
      child: BlocBuilder<FriendBlocBloc, FriendBlocState>(
        bloc: _friendBlocBloc,
        builder: (context, state) {
          if (state is FriendStateLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is FriendStateLoaded) {
            return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    state.friendlist.length > 6 ? 6 : state.friendlist.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      context.pushNamed("mainprofile", params: {
                        "userid": state.friendlist![index].id,
                      });
                    },
                    child: Container(
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: Image.network(
                            state.friendlist![index].avatar.contains("http")
                                ? state.friendlist![index].avatar
                                : keyS.LOADIMAGEUSER +
                                    state.friendlist![index].avatar,
                            fit: BoxFit.cover,
                          )),
                    ),
                  );
                });
          } else {
            return Center(child: Text("Hãy kết nối với mọi người"));
          }
        },
      ),
    );
  }

  Container profileBottom(userModel state) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (state.user_detail.job != "null")
            infoRow(Icons.work, "Đến từ ", state.user_detail.job),
          if (state.user_detail.address_from != "null")
            infoRow(Icons.where_to_vote_outlined, "Đến từ ",
                state.user_detail.address_from),
          if (state.user_detail.address_live != "null")
            infoRow(Icons.home_rounded, "Sống tại ",
                state.user_detail.address_live),
          if (state.user_detail.studying != "null")
            infoRow(Icons.school, "Học tại ", state.user_detail.studying),
          infoRow(Icons.cake, "Sinh nhật ",
              "${formatTime.convertUtcToVn_birthday(state.user_detail.birthday)}"),
          infoRow(Icons.where_to_vote_outlined, "Đã tham gia từ ",
              "${formatTime.convertUtcToVn_birthday(state.create_at)}"),
        ],
      ),
    );
  }

  Container infoRow(icon, textTemplate, text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(
            icon,
            size: 15,
            color: GlobalColors.iconColorInfoBottom,
          ),
          SizedBox(
            width: 7,
          ),
          Flexible(
            child: Row(
              children: [
                Text(
                  textTemplate,
                  softWrap: true,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: 'Roboto_ligth'),
                ),
                Text(
                  text,
                  softWrap: true,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: 'Roboto_medium'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container yourProfileTop(String name, userModel userM) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<ActionFriendsCubit, ActionFriendsState>(
              builder: (context, state) {
                if (state is ActionFriendsLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ActionFriendsMyProfile) {
                  return myProfileTop(userM, _userDetailBloc);
                } else if (state is ActionFriendsCancleAwaitFriends) {
                  return InkWell(
                      onTap: () {
                        _friendsCubit.cancleAwaitFriends(widget.user);
                      },
                      child: statusCancleFriends());
                } else if (state is ActionFriendsAcceptFriends) {
                  return statusFeedbackFriends();
                } else if (state is ActionFriendsAddFriend) {
                  return InkWell(
                      onTap: () {
                        _friendsCubit.addFriends(widget.user);
                      },
                      child: statusAddFriends());
                } else if (state is ActionFriendsCancleFriends) {
                  return InkWell(
                      onTap: () {
                        dialogShowCancelFriends(context, name);
                      },
                      child: statusFriends());
                }
                return SizedBox();
              },
            ),
          ),
          SizedBox(
            width: 10,
          ),
          if (widget.user != sharedPreferences.getString(keyShared.IDUSER))
            Expanded(
              child: InkWell(
                onTap: () {},
                child: InkWell(
                  onTap: () async {
                    conversasionModel data =
                        await conRepo.getcheckconversasionByUserId(
                            sharedPreferences.getString(keyShared.IDUSER),
                            userM.id);

                    context.pushNamed("message", params: {
                      "conversasionid": data.id,
                      "userid": userM.id,
                      "avatar": userM.avatar,
                      "name": userM.name,
                      "seen":sharedPreferences.getString(keyShared.IDUSER)
                    });
                  },
                  child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: GlobalColors.backGroundColorButtonEditProfile,
                          borderRadius: BorderRadius.circular(7)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/messenger.svg",
                            height: 15,
                            width: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Nhắn tin",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                  fontSize: 15)),
                        ],
                      )),
                ),
              ),
            )
        ],
      ),
    );
  }

  Future<dynamic> dialogShowCancelFriends(BuildContext context, String name) {
    return showDialog(
      context: context,
      builder: (context) {
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
                    fontFamily: 'Roboto_medium',
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Thu hồi kết bạn với ' + name,
                  style: TextStyle(fontFamily: 'Roboto_medium', fontSize: 16),
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
                        style: TextStyle(
                            fontFamily: 'Roboto_medium', color: Colors.grey),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _friendsCubit.cancleFriends(widget.user);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Đồng ý',
                        style: TextStyle(
                          fontFamily: 'Roboto_medium',
                        ),
                      ),
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

  Container statusAddFriends() {
    return Container(
        height: 35,
        decoration: BoxDecoration(
            color: GlobalColors.backGroundColorButtonAddFriends,
            borderRadius: BorderRadius.circular(7)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_alt_1,
              color: GlobalColors.textColorButtonAddFriends,
              size: 17,
            ),
            SizedBox(
              width: 5,
            ),
            Text("Kết bạn",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    color: GlobalColors.textColorButtonAddFriends,
                    fontSize: 15)),
          ],
        ));
  }

  Container statusCancleFriends() {
    return Container(
        height: 35,
        decoration: BoxDecoration(
            color: GlobalColors.backGroundColorButtonCancelFriends,
            borderRadius: BorderRadius.circular(7)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/person-dash.svg",
                color: GlobalColors.textColorButtonCancleFriends),
            SizedBox(
              width: 5,
            ),
            Text("Hủy lời mời",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    color: GlobalColors.textColorButtonCancleFriends,
                    fontSize: 15)),
          ],
        ));
  }

  InkWell statusFeedbackFriends() {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
                height: 120.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        _friendsCubit.acceptFriends(widget.user);
                        context.pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.black, width: 0.1))),
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        height: 60,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_add_alt_1,
                              color: Colors.black,
                              size: 17,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Đồng ý kết bạn"),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _friendsCubit.cancleAcceptFriends(widget.user);
                        context.pop();
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        height: 60,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 17,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Không chấp nhận"),
                          ],
                        ),
                      ),
                    )
                  ],
                ));
          },
        );
      },
      child: Container(
          height: 35,
          decoration: BoxDecoration(
              color: GlobalColors.backGroundColorButtonCancelFriends,
              borderRadius: BorderRadius.circular(7)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/images/person-lines-fill.svg",
                  color: GlobalColors.textColorButtonCancleFriends),
              SizedBox(
                width: 5,
              ),
              Text("Phản hồi",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      color: GlobalColors.textColorButtonCancleFriends,
                      fontSize: 15)),
            ],
          )),
    );
  }

  Container statusFriends() {
    return Container(
        height: 35,
        decoration: BoxDecoration(
            color: GlobalColors.backGroundColorButtonCancelFriends,
            borderRadius: BorderRadius.circular(7)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/person-check.svg",
                color: GlobalColors.textColorButtonCancleFriends),
            SizedBox(
              width: 5,
            ),
            Text("Bạn bè",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    color: GlobalColors.textColorButtonCancleFriends,
                    fontSize: 15)),
          ],
        ));
  }

  Container myProfileTop(userModel userM, UserDetailBloc userD) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return createPostScreen(
                    action: "user",
                    idpost: "",
                    listImage: [],
                    titlePost: "",
                  );
                },
              ));
            },
            child: Container(
              height: 35,
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  color: GlobalColors.backGroundColorButtonAddPost,
                  borderRadius: BorderRadius.circular(7)),
              child: Center(
                  child: Text(
                "+ Thêm bài viết mới",
                style: TextStyle(fontFamily: 'Roboto', color: Colors.white),
              )),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              context.push(AppRoute.VIEWEDITMAINPROFILE,
                  extra: {"arg1": userM, "arg2": userD});
            },
            child: Container(
                height: 35,
                margin: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    color: GlobalColors.backGroundColorButtonEditProfile,
                    borderRadius: BorderRadius.circular(7)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.create,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Chỉnh sửa trang cá nhân",
                        style: TextStyle(
                            fontFamily: 'Roboto', color: Colors.black)),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
