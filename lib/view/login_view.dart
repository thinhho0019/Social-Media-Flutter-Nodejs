import 'dart:async';
import 'package:appchat_socket/api/api_auth.dart';
import 'package:appchat_socket/cubits/cubit/cubit_login_cubit.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/utils/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
 

class loginView extends StatefulWidget {
  const loginView({super.key});
  @override
  State<loginView> createState() => _loginViewState();
}

class _loginViewState extends State<loginView> {
  final TextEditingController emailControler = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  SignInWithGoogle signInWithGoogle = SignInWithGoogle();
  bool changeColor = false;
  String welcome = "hello signIn now";
  @override
  void initState(){
    super.initState();
    signInWithGoogle.initGoogleLogin();
 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
                
                height: 120,
                width: 120,
                child: ClipOval(
                    child: Image.asset(
                  "assets/images/main.png",
                  fit: BoxFit.contain,filterQuality: FilterQuality.high
                ))),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Xin chào,",
                      style: TextStyle(
                          color: GlobalColors.textColorlogin,
                          fontSize: 18,
                          fontFamily: 'Roboto'),
                    ),
                    Text(
                      "Mừng bạn đã trở lại",
                      style: TextStyle(
                          color: GlobalColors.textColorlogin,
                          fontSize: 18,
                          fontFamily: 'Roboto'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "ĐĂNG NHẬP VỚI TÀI KHOẢN",
                      style: TextStyle(
                          color: GlobalColors.textColorlogin,
                          fontSize: 14,
                          fontFamily: 'Roboto_light'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.all(5),
              width: double.infinity,
               
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      getString();
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black,width: 0.2),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Row(
                         
                         
                        children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 30,
                          width: 30,
                          child: SvgPicture.asset("assets/images/google.svg")),
                          SizedBox(width: 10,),
                        Expanded(child: Center(child: Text("Google     ",
                        style: TextStyle(fontFamily: 'Roboto',fontSize: 16),)))
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      signInWithGoogle.signOut();
                          showSnackbar("log out");
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black,width: 0.2),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Row(
                        
                        children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 30,
                          width: 30,
                          child: SvgPicture.asset("assets/images/facebook.svg")),
                        SizedBox(width: 10,),
                        Expanded(child: Center(child: Text("Facebook",
                        style: TextStyle(fontFamily: 'Roboto',fontSize: 16))))
                      ]),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      )),
      bottomSheet:   Container(
        height: 12,
        color: GlobalColors.mainColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Bản quyền thuộc về Xuân Thịnh",
            style: TextStyle(fontFamily: 'Roboto_ligth',fontSize: 8,color: Colors.black), 
          ),
          ],
        ),
      ),
    );
  }

  Future getString() async {
    try{
      String token = await signInWithGoogle.googleLogin();
      await ApiAuth.LoginAuth(token);

    context.read<CubitLoginCubit>().login();
    }catch(e){
      print(e);
    }
    
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
}
