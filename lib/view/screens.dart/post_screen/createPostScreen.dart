import 'dart:io';
import 'package:appchat_socket/cubits/cubit_post/post_access_cubit.dart';
import 'package:appchat_socket/repostiory/post_repository.dart';
import 'package:appchat_socket/utils/StringUrlToXFile.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/utils/key.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:appchat_socket/view/screens.dart/post_screen/accessPostScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appchat_socket/blocs/bloc_post/post_stream/postImage.dart';
import 'package:appchat_socket/blocs/bloc_post/post_bloc.dart';
import 'package:appchat_socket/models/post.dart';
class createPostScreen extends StatefulWidget {
  final String action;
  final String idpost;
  final List<String> listImage;
  final String titlePost;
  final int? index;
  createPostScreen({super.key, required this.action, required this.idpost,required this.listImage,required this.titlePost, this.index});
  @override
  State<createPostScreen> createState() => _createPostScreenState();
}
class _createPostScreenState extends State<createPostScreen> {
  List<XFile> images=[];
  List<String> imageold=[];
  final textTitle = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    checkInit();
    super.initState();
  }
  checkInit()async {
      if(widget.idpost!=""){
        imageold = widget.listImage;
        textTitle.text = widget.titlePost;
        for(final element in widget.listImage){
          XFile? data = await StringUrlToXFile.getImageXFileByUrl(keyS.LOADIMAGE+element);
          if(data !=null){
            images.add(data);
          }
        }
        postImage.postImageController.sink.add(images);
      }
    }
  @override
  Widget build(BuildContext context) {
    
    final ImagePicker _imagePicker = ImagePicker();
    
    void selectImagePicker() async {
      images = await _imagePicker.pickMultiImage();
      if (images!.isNotEmpty) {
        postImage.postImageController.sink.add(images);
      }
    }
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: GlobalColors.mainColor,
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Tạo bài viết",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Roboto_light',
                    fontSize: 17),
              ),
            ),
            Container(
              height: 30,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("1a74e4")),
                  onPressed: () async {
                    switch (context.read<PostAccessCubit>().state.status) {
                      case AccessStatus.public:
                        String check = checkPost(textTitle.text, images.length);
                        if (check=="oke") {
                          if(widget.idpost==""){
                              post result = await postRe.uploadPost(
                              images, textTitle.text, "public");
                              context.read<PostBloc>().add(addPost(Post: result,action: widget.action));
                          }else{
                              context.read<PostBloc>().add(
                                updatePost(access: "public",content: textTitle.text
                              ,idpost: widget.idpost,image: images,index: widget.index??0,imageold: imageold)
                              );
                               
                          }
                          

                          Navigator.pop(context);
                        } else if(check=="empty") {
                           
                            showSnackbar('Hình ảnh và tiêu đê không được để trống');
                       
                        }else if(check=="image") {
                          showSnackbar('Hình ảnh tối đa là 6!');
                        }else if(check=="text"){
                          showSnackbar('Bài đăng tối đa là 5000 kí tự!');
                        }

                        break;
                      case AccessStatus.friend:
                        String check = checkPost(textTitle.text, images.length);
                        if (check=="oke") {
                         if(widget.idpost==""){
                              post result = await postRe.uploadPost(
                              images, textTitle.text, "friend");
                              context.read<PostBloc>().add(addPost(Post: result,action: widget.action));
                          }else{
                              context.read<PostBloc>().add(
                                updatePost(access: "friend",content: textTitle.text
                              ,idpost: widget.idpost,image: images,index: widget.index??0,imageold: imageold)
                              );
                               
                          }

                          Navigator.pop(context);
                        } else if(check=="empty"){
                          showSnackbar('Hình ảnh và tiêu đê không được để trống');
                        }else if(check=="image") {
                          showSnackbar('Hình ảnh tối đa là 6!');
                        }else if(check=="text"){
                          showSnackbar('Bài đăng tối đa là 5000 kí tự!');
                        }
                        break;
                      case AccessStatus.private:
                        String check = checkPost(textTitle.text, images.length);
                        if (check=="oke") {
                         if(widget.idpost==""){
                              post result = await postRe.uploadPost(
                              images, textTitle.text, "private");
                              context.read<PostBloc>().add(addPost(Post: result,action: widget.action));
                          }else{
                              context.read<PostBloc>().add(
                                updatePost(access: "private",content: textTitle.text
                              ,idpost: widget.idpost,image: images,index: widget.index??0,imageold: imageold)
                              );
                               
                          }

                          Navigator.pop(context);
                        } else if(check=="empty"){
                          showSnackbar('Hình ảnh và tiêu đê không được để trống');
                        }else if(check=="image") {
                          showSnackbar('Hình ảnh tối đa là 6!');
                        }else if(check=="text"){
                          showSnackbar('Bài đăng tối đa là 5000 kí tự!');
                        }
                        break;
                      default:
                        break;
                    }
                  },
                  child: Text(
                    widget.idpost==""?"Đăng":"Cập nhật",
                    style: TextStyle(fontSize: 17, fontFamily: 'Roboto_light'),
                  )),
            )
          ],
        ),
        leading: GestureDetector(
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
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  height: 40,
                  width: 40,
                  child: ClipOval(
                    child: Image.network(
                        sharedPreferences.getString(keyShared.GOOGLEIMAGE).contains("http")
                        ?sharedPreferences.getString(keyShared.GOOGLEIMAGE)
                        :keyS.LOADIMAGEUSER+sharedPreferences.getString(keyShared.GOOGLEIMAGE),fit: BoxFit.cover,),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sharedPreferences
                            .getString(keyShared.GOOGLENAMEDISPLAY),
                        style: TextStyle(fontFamily: 'Roboto'),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      BlocBuilder<PostAccessCubit, PostAccessState>(
                        builder: (context, state) {
                          return state.status == AccessStatus.public
                              ? widgetPostAccess(
                                  title: "Cộng đồng",
                                  icon: Icons.public,
                                  name: "public")
                              : state.status == AccessStatus.friend
                                  ? widgetPostAccess(
                                      title: "Bạn bè",
                                      icon: Icons.people,
                                      name: "friend")
                                  : state.status == AccessStatus.private
                                      ? widgetPostAccess(
                                          title: "Riêng tư",
                                          icon: Icons.lock,
                                          name: "private")
                                      : Text("");
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
            //input textfile here
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      maxLines: null,
                      controller: textTitle,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Bạn đang nghĩ gì?"),
                    ),
                  ),
                )
              ],
            ),
            // using streambuilder show image
            Expanded(
              child: StreamBuilder(
                stream: postImage.postImageController.stream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return snapshot.data!.length > 1
                        ? GridView.builder(
                            itemCount: snapshot.data!.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 2),
                            itemBuilder: (context, index) {
                              return Stack(
                                fit: StackFit.passthrough,
                                children: [
                                  Container(
                                    child: Image.file(
                                      File(snapshot.data![index].path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: InkWell(
                                      onTap: () {
                                        var a = snapshot.data!;
                                        a.removeAt(index);
                                        postImage.postImageController.add(a);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 175, 169, 169),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        margin: EdgeInsets.all(2),
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        : snapshot.data!.length == 1
                        
                            ? Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 0.5)
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Container(
                                      height: 300,
                                      child: Image.file(
                                        File(snapshot.data![0].path),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  Positioned(
                                      top: 6,
                                      right: 6,
                                      child: InkWell(
                                        onTap: () {
                                          var a = snapshot.data!;
                                          a.removeAt(0);
                                          postImage.postImageController.add(a);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 175, 169, 169),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          margin: EdgeInsets.all(2),
                                          padding: EdgeInsets.all(2),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )
                            : SizedBox();
                  }
                  return SizedBox();
                },
              ),
            )
          ],
        ),
      ),
      //button click chose image in storage
      bottomSheet: SizedBox(
        width: double.infinity,
        height: 50,
        child: InkWell(
          onTap: () {
            selectImagePicker();
          },
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: HexColor("1a74e4"),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Chọn hình ảnh",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    
  }

  void showSnackbar(String title) {
    final snackBar = SnackBar(
      content: Text(title),
      action: SnackBarAction(
        label: '',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String checkPost(String title, int dsImage) {
    if (title.isEmpty || dsImage <= 0) {
      return "empty";
    }else if(dsImage>6){
      return "image";
    }else if(title.length>=5000){
      return "text";
    }
    return "oke";
  }
}

class widgetPostAccess extends StatelessWidget {
  final String title;
  final IconData icon;
  final String name;
  const widgetPostAccess({
    Key? key,
    required this.title,
    required this.icon,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            if (name == "public") {
              return AccessPostScreen(postRadio: postAccessRadio.public);
            } else if (name == "friend") {
              return AccessPostScreen(postRadio: postAccessRadio.friend);
            } else {
              return AccessPostScreen(postRadio: postAccessRadio.private);
            }
          },
        ));
      },
      child: Container(
        padding: EdgeInsets.only(top: 4, bottom: 4, left: 7, right: 7),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: HexColor("e7f3ff")),
        child: Row(
          children: [
            Icon(
              icon,
              size: 13,
              color: HexColor("1764d0"),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              title,
              style: TextStyle(color: HexColor("1764d0"), fontSize: 10),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 15,
              color: HexColor("1764d0"),
            )
          ],
        ),
      ),
    );
  }
}
