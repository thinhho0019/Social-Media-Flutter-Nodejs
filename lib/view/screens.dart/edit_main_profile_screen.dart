 
import 'dart:async';
import 'dart:io';

import 'package:appchat_socket/blocs/userBloc/bloc_user_detail_edit/stream_user_detail_edit_bloc/stream_image_edit_profile_bloc.dart';
import 'package:appchat_socket/blocs/userBloc/bloc_user_detail_edit/user_detail_bloc.dart';
import 'package:appchat_socket/models/user_detail.dart';
import 'package:appchat_socket/models/user_model.dart';
import 'package:appchat_socket/utils/StringUrlToXFile.dart';
import 'package:appchat_socket/utils/format_time.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/utils/image_cropper.dart';
import 'package:appchat_socket/utils/key.dart';
import 'package:appchat_socket/view/widget/loading_widget_anim.dart';
import 'package:appchat_socket/view/widget/loading_widget_anim_single.dart';
 

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class editMainProfileScreen extends StatefulWidget {
  final userModel user;
  final UserDetailBloc userD;
  const editMainProfileScreen(
      {super.key, required this.user, required this.userD});

  @override
  State<editMainProfileScreen> createState() => _editMainProfileScreenState();
}

class _editMainProfileScreenState extends State<editMainProfileScreen> {
  DateTime datePicker = DateTime.now();

  File? avatar;
  File? background_image;
  TextEditingController textBio = TextEditingController();
  TextEditingController textJob = TextEditingController();
  TextEditingController textStudy = TextEditingController();
  TextEditingController textAddress = TextEditingController();
  TextEditingController textFrom = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    checkInit();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    freeMemory();
    imageEditProfile.dispose();
    super.dispose();
  }

  void freeMemory() async {
    await File(avatar!.path).delete();
    await File(background_image!.path).delete();
  }

  void checkInit() async {
    DateTime birthday =
        formatTime.convertUtcToVN_editprofile(widget.user.user_detail.birthday);
    // avatar = await StringUrlToXFile.getImageXFileByUrl(widget.user.avatar);
    // background_image = await StringUrlToXFile.getImageXFileByUrl(
    //     widget.user.user_detail.background_image);
    // imageEditProfile.avatarController.sink.add(avatar);
    // imageEditProfile.backgroundController.sink.add(background_image);
    setState(() {
      datePicker = birthday;
    });
    if (widget.user.user_detail.bio != "null") {
      textBio.text = widget.user.user_detail.bio;
    }
    if (widget.user.user_detail.job != "null") {
      textJob.text = widget.user.user_detail.job;
    }
    if (widget.user.user_detail.studying != "null") {
      textStudy.text = widget.user.user_detail.studying;
    }
    if (widget.user.user_detail.address_live != "null") {
      textAddress.text = widget.user.user_detail.address_live;
    }
    if (widget.user.user_detail.address_from != "null") {
      textFrom.text = widget.user.user_detail.address_from;
    }
  }
Future _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
  
    if (pickedImage != null) {
      setState(() {
        avatar = File(pickedImage.path);
      });
    }
    
  }
  Future _pickImageBackground() async {
    final pickedImageBackground =
        await ImagePicker().pickImage(source: ImageSource.gallery);
  
    if (pickedImageBackground != null) {
      setState(() {
        background_image = File(pickedImageBackground.path);
      });
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: GlobalColors.mainColor,
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Chỉnh sửa thông tin",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Roboto_light',
                    fontSize: 15),
              ),
            ),
            InkWell(
              onTap: () async {
                showDialog(
                  barrierDismissible: false ,
                  
                  context: context, builder: (context) {
                  return loadingWidgetSingle();
                },);
                 
              
                  if(avatar!=null){
                    XFile? img = await XFile(avatar!.path);
                                              widget.userD.add(
                                              updateImageAvatar(
                                                fileimage: img,
                                                userid: widget.user.id,
                                                namefileole: widget.user.avatar
                                                ));
                                               
                  }
                  if(background_image!=null){
                     XFile? img = await XFile(background_image!.path);
                                              widget.userD.add(
                                              updateImageBackground(
                                                fileimage: img,
                                                userid: widget.user.user_detail.id,
                                                namefileole: widget.user.user_detail.background_image
                                                ));
                                                 
                  }
                 final data = {
                  "_id": widget.user.id,
                  "bio": textBio.text == "" ? "null" : textBio.text,
                  'job': textJob.text == "" ? "null" : textJob.text,
                  'address_from': textFrom.text == "" ? "null" : textFrom.text,
                  'address_live':
                      textAddress.text == "" ? "null" : textAddress.text,
                  'birthday': formatTime.convertVNtoUtc(datePicker),
                  'studying': textStudy.text == "" ? "null" : textStudy.text,
                  'background_image': widget.user.user_detail.background_image,
                };
                userDetail user = userDetail.fromMap(data);
                widget.userD.add(await updateProfile(user: user));
                final snackBar = SnackBar(
                  content: Text('Bạn đã chỉnh sửa thông tin thành công'), 
                );
                Timer(Duration(seconds: 2), () {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  context.pop();
                 });
                
                 
              },
              child: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  children: [
                    Icon(
                      Icons.save,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Center(
                      child: Text("Lưu",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto_light',
                              fontSize: 12)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: GlobalColors.mainColor,
        padding: EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              //Containner display image
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Ảnh đại diện",
                          style: TextStyle(
                              fontFamily: 'Roboto_medium', fontSize: 17),
                        )),
                        InkWell(
                          onTap: () async {
                            await _pickImage();
                            File cropperImage = await imageCropper.cropImage(avatar);
                            XFile? choseAva = XFile(cropperImage.path);
                            imageEditProfile.avatarController.sink
                                .add(choseAva);
                          },
                          child: Text(
                            "Thay đổi",
                            style: TextStyle(
                                fontFamily: 'Roboto_light',
                                fontSize: 12,
                                color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    StreamBuilder(
                        stream: imageEditProfile.avatarController.stream,
                        builder: (context, snapshot) {
                          // if (snapshot.connectionState ==
                          //     ConnectionState.waiting) {
                          //   return Container(
                          //     height: 100,
                          //     width: 100,
                          //     decoration: BoxDecoration(
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(50)),
                          //     ),
                          //     child: Center(
                          //       child: CircularProgressIndicator(),
                          //     ),
                          //   );
                          // } else
                          if (snapshot.hasData) {
                            return Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  image: DecorationImage(
                                      image:
                                          FileImage(File(snapshot.data!.path)),
                                      fit: BoxFit.cover)),
                            );
                          }
                          return Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                image: DecorationImage(
                                    image: NetworkImage(widget.user.avatar.contains("http")
                                    ?widget.user.avatar
                                    :keyS.LOADIMAGEUSER+widget.user.avatar),
                                    fit: BoxFit.cover)),
                          );
                        }),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              //container ảnh bìa
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Ảnh bìa",
                          style: TextStyle(
                              fontFamily: 'Roboto_medium', fontSize: 17),
                        )),
                        InkWell(
                          onTap: () async {
                            await _pickImageBackground();
                            File cropperImage = await imageCropper.cropImage(background_image);
                            XFile? choseAva = XFile(cropperImage.path);      
                            imageEditProfile.backgroundController.sink
                                .add(choseAva);
                                
                          },
                          child: Text(
                            "Thay đổi",
                            style: TextStyle(
                                fontFamily: 'Roboto_light',
                                fontSize: 12,
                                color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    StreamBuilder(
                        stream: imageEditProfile.backgroundController.stream,
                        builder: (context, snapshot) {
                          // if (snapshot.connectionState ==
                          //     ConnectionState.waiting) {
                          //   return Container(
                          //     height: 200,
                          //     width: double.infinity,
                          //     decoration: BoxDecoration(
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(50)),
                          //     ),
                          //     child: Center(
                          //       child: CircularProgressIndicator(),
                          //     ),
                          //   );
                          // } else
                          if (snapshot.hasData) {
                            return Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  image: DecorationImage(
                                      image:
                                          FileImage(File(snapshot.data!.path)),
                                      fit: BoxFit.cover)),
                            );
                          }
                          return Container(
                            height: 200,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                image: DecorationImage(
                                    image: NetworkImage(
                                      widget.user.user_detail.background_image.contains("http")
                                      ?widget.user.user_detail.background_image
                                      :keyS.LOADIMAGEUSER+ widget.user.user_detail.background_image),
                                    fit: BoxFit.cover)),
                          );
                        }),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              // tiểu sử
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Thông tin chi tiết",
                          style: TextStyle(
                              fontFamily: 'Roboto_medium', fontSize: 17),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Tiểu sử")),
                    TextField(
                      controller: textBio,
                      decoration: InputDecoration(
                          hintText: "Mô tả bản thân..",
                          border: InputBorder.none),
                    )
                  ],
                ),
              ),
              //công việc
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Công việc")),
                    TextField(
                      controller: textJob,
                      decoration: InputDecoration(
                          hintText: "Tên nơi công việc..",
                          border: InputBorder.none),
                    )
                  ],
                ),
              ),
              // học vấn
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Học vấn")),
                    TextField(
                      controller: textStudy,
                      decoration: InputDecoration(
                          hintText: "Đã học tại..", border: InputBorder.none),
                    )
                  ],
                ),
              ),
              // nơi ở hiện tại
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Tỉnh/Thành phố hiện tại")),
                    TextField(
                      controller: textAddress,
                      decoration: InputDecoration(
                          hintText: "Sống tại..", border: InputBorder.none),
                    )
                  ],
                ),
              ),
              //quê quán
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Quê quán")),
                    TextField(
                      controller: textFrom,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        hintText: "Đến từ..",
                        border: InputBorder.none,
                      ),
                    )
                  ],
                ),
              ),
              // sinh nhật
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Sinh nhật")),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 30,
                        child: Row(
                          children: [
                            Text(
                              formatTime.convertDatetoString(datePicker),
                              style: TextStyle(color: HexColor("#666666")),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                                onTap: () async {
                                  final DateTime? datePickerT =
                                      await showDatePicker(
                                          context: context,
                                          initialDate: datePicker,
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now());
                                  if (datePickerT == null) return;
                                  setState(() {
                                    datePicker = datePickerT;
                                  });
                                },
                                child: Icon(Icons.calendar_month_outlined))
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
