import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class loadingWidgetSingle extends StatelessWidget {
  const loadingWidgetSingle({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child:Stack(
       children: [
        Center(
          child: Container(
            height: 100,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                LoadingAnimationWidget.inkDrop(
                     color: Colors.white,
                     size: 30,
                   ),
                SizedBox(height: 10,),
                Text("Đang xử lí",style: TextStyle(
                  fontFamily: 'Roboto_medium',
                  color: Colors.white,
                  fontSize: 13
                ),)
              ],
            ),
          ),
        ),
       ],
      ),
    );
  }
}
// return  AlertDialog(
      
//       backgroundColor: Colors.grey,
//       title: Container(
         
    
//          padding: EdgeInsets.all(10),
//          child: LoadingAnimationWidget.inkDrop(
//            color: Colors.black,
//            size: 30,
//          ),
//        ),
//       contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 1.0),
//       titlePadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 1.0),
      
//       content: Container(
//         width: 40,
//         height: 40,
//         child: Text("Đang xử lí")),
//     );