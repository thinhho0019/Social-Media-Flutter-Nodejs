import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
class widgetNoFriend extends StatelessWidget {
  const widgetNoFriend({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: HexColor("#40E0D0"),
      ),
      
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.center,
            "Thêm bạn bè",
            style: TextStyle( fontSize: 9,color: Colors.white),),
        ],
      )
      
      );
  }
}
