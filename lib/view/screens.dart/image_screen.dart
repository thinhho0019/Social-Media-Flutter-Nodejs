

import 'package:appchat_socket/utils/key.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class imageScreen extends StatelessWidget {
  final String imageUrl;
  const imageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          child: InteractiveViewer(
            
            child: Center(
              child: Container(
                height: 400,
                width: double.infinity,
                child: Image.network(imageUrl.contains("http")?imageUrl:keyS.LOADIMAGEUSER+imageUrl)),
            ),
            boundaryMargin: EdgeInsets.all(20),
            minScale: 0.1,
            maxScale: 5.0, 
          ),
          onTap: () => Navigator.pop(context),
        ),
      ),
    );
  }
}