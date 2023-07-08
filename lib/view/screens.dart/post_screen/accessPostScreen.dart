
import 'package:appchat_socket/cubits/cubit_post/post_access_cubit.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
 

enum postAccessRadio { public, friend, private }

class AccessPostScreen extends StatefulWidget {
   postAccessRadio? postRadio;
  AccessPostScreen({super.key,required this.postRadio});

  @override
  State<AccessPostScreen> createState() => _AccessPostScreenState();
}

class _AccessPostScreenState extends State<AccessPostScreen> {
   
  PostAccessCubit _accessCubit = PostAccessCubit();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: GlobalColors.mainColor,
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Đối tượng của bài viết",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Roboto_light',
                    fontSize: 15),
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
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "Ai có thể xem bài viết bạn?\n\n",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                  TextSpan(
                      text:
                          "Bài viết của bạn có thể hiện thị trên bảng tin, trang cá nhân\n",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          fontFamily: "DancingScript")),
                  TextSpan(
                      text: "Tuy mặc định là ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          fontFamily: "DancingScript")),
                  TextSpan(
                      text: "chỉ mình tôi",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: "DancingScript")),
                  TextSpan(
                      text:
                          ", nhưng bạn có thể thay đổi đối tượng của riêng bài viết này\n\n",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          fontFamily: "DancingScript")),
                  TextSpan(
                      text: "Chọn đối tượng\n",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                ]),
              ),
            ),
            Expanded(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 6,
                  crossAxisCount: 1, // Số cột của lưới
                ),
                itemCount: 3, // Số lượng phần tử
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.grey, width: 1))),
                      child: Row(
                        children: [
                          Radio(
                            value: index == 0
                                ? postAccessRadio.public
                                : index == 1
                                    ? postAccessRadio.friend
                                    : index == 2
                                        ? postAccessRadio.private
                                        : postAccessRadio.public,
                            groupValue: widget.postRadio,
                            onChanged: (value) {
                              setState(() {
                                widget.postRadio = value;
                              });
                            },
                          ),
                          Container(
                              height: 22,
                              width: 22,
                              child: index == 0
                                  ? SvgPicture.asset(
                                      "assets/icon/Ionic-Ionicons-Earth.svg")
                                  : index == 1
                                      ? Icon(Icons.people)
                                      : index == 2
                                          ? SvgPicture.asset(
                                              "assets/icon/lock-svgrepo-com.svg")
                                          : null),
                          SizedBox(
                            width: 10,
                          ),
                          index==0?titleWidget(title: "Công khai",des:"Bất kì ai cũng có thể xem bài viết")
                          :index==1?titleWidget(title: "Bạn bè",des:"Chỉ có bạn bè mới có thể xem bài viết")
                          :index==2?titleWidget(title: "Riêng tư",des:"Không ai được xem bài viết ngoài bạn"):SizedBox()
                        ],
                      ));
                },
              ),
            )
          ],
        ),
      ),
      bottomSheet: SizedBox(
        width: double.infinity,
        height: 40,
        child: InkWell(
          onTap: () {
            if(widget.postRadio==postAccessRadio.public){
               context.read<PostAccessCubit>().public();
               
            }else if(widget.postRadio==postAccessRadio.friend){
              context.read<PostAccessCubit>().friend();
            }else{
             context.read<PostAccessCubit>().private();
            }
            Navigator.pop(context);
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
                  "Xong",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class titleWidget extends StatelessWidget {
  final String title;
  final String des;
  const titleWidget({
    Key? key, required this.title, required this.des,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(children: <TextSpan>[
          TextSpan(
              text: "$title\n",
              style: TextStyle(
                  color: Colors.black, fontSize: 12)),
          TextSpan(
              text: "$des",
              style: TextStyle(
                  color: Color.fromARGB(255, 61, 61, 61), fontSize: 11)),
        ]))
      ],
    ));
  }
}
