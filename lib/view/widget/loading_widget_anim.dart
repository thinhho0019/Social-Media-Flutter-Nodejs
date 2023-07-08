import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class loadingWidget extends StatelessWidget {
  const loadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: LoadingAnimationWidget.inkDrop(
            color: Colors.black,
            size: 30,
          ),
        ),
      );
  }
}