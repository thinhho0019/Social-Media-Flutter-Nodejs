import 'dart:async';
import 'package:appchat_socket/cubits/cubit/cubit_login_cubit.dart';
import 'package:appchat_socket/goRouter/app_route.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
class FirstViewLogin extends StatelessWidget {
  FirstViewLogin();
  @override
  Widget build(BuildContext context) {
    TextEditingController emailControler;
    Timer(Duration(seconds: 1), (() {
       try{
      if(!sharedPreferences.getString(keyShared.IDUSER).isEmpty){
        context.go(AppRoute.VIEWCHAT);
        context.read<CubitLoginCubit>().login();
      }else{
        //Navigator.push(context,MaterialPageRoute(builder: (context) => loginView(),));
        
          context.go(AppRoute.LOGIN);
        
        
      }
      }catch(e){
          print(e);
        }
    }));
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body:   Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            height: 150,
            width: 150,
            child: ClipOval(child: Image.asset("assets/images/main.png",fit: BoxFit.cover,filterQuality: FilterQuality.high,))),

          ),
    );
  }
}
