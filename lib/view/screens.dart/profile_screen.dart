import 'package:appchat_socket/blocs/userBloc/bloc_user_detail_edit/stream_user_detail_edit_bloc/stream_infor_user.dart';
import 'package:appchat_socket/cubits/cubit/cubit_login_cubit.dart';
import 'package:appchat_socket/goRouter/app_route.dart';
import 'package:appchat_socket/repostiory/user_repository.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/utils/google_sign_in.dart';
import 'package:appchat_socket/utils/key.dart';
import 'package:appchat_socket/utils/socket_util.dart';
import 'package:flutter/material.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
class ProfileScreen extends StatelessWidget {
  final int currentIndex;
  List<String> options = [
    'Trang cá nhân',
    'Thông báo mới',
    'Lời mời kết bạn đã gửi',
    'Lời mời kết bạn đã nhận',
    'Cập nhật tài khoản',
    'Đăng xuất',
    
    // Thêm các ảnh khác vào đây...
  ];
  List<IconData> icons = [
    Icons.person,
    Icons.notifications,
    Icons.person_add,
    Icons.person_outlined,
    Icons.person_pin_outlined,
    Icons.logout
  ];
  ProfileScreen({Key? key, required this.currentIndex}) : super(key: key);
  SignInWithGoogle googleSigninAccount = SignInWithGoogle();
  @override
  Widget build(BuildContext context) {
    googleSigninAccount.initGoogleLogin();
    
    void showSnackbar(String title) {
      final snackBar = SnackBar(
        content: Text(title!),
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

    return SafeArea(
      child: Container(
        color: GlobalColors.mainColor,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 0),
              child: Row(
                children: [
                  StreamBuilder(
                          stream: streamInforU.avatar.stream,
                          builder: (context, snapshot) {
                            if(snapshot.connectionState==ConnectionState.waiting){
                              return Center(child: CircularProgressIndicator());
                            }
                            
                         return Container(
                    margin: EdgeInsets.only(top: 25, left: 20),
                    height: 50,
                    width: 50,
                    padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(100))
            ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          snapshot.data!.contains("http")?snapshot.data!
                            :keyS.LOADIMAGEUSER+snapshot.data!),
                    ),
                  );
                          },
                        ),
                  
                  Padding(
                    padding: const EdgeInsets.only(left: 17, top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sharedPreferences
                              .getString(keyShared.GOOGLENAMEDISPLAY),
                          style: TextStyle(),
                        ),
                        Text(
                          sharedPreferences.getString(keyShared.GOOGLEGMAIL),
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              fontFamily: 'Roboto_light'),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: GridView.builder(
              itemCount: options.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // Số cột tối đa trong lưới
                mainAxisSpacing: 0, // Khoảng cách giữa các hàng
                crossAxisSpacing: 0, // Khoảng cách giữa các cột
                childAspectRatio: 7, // Tỷ lệ chiều rộng / chiều cao của mỗi ô
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    switch (index) {
                      case 0:
                        context.pushNamed("mainprofile",params: {
                          "userid":sharedPreferences.getString(keyShared.IDUSER)
                        });
                        break;
                      case 1:
                        print(1);
                        break;
                      case 2:
                        context.push(AppRoute.VIEWSENTADDFRIENDS);
                        break;
                      case 3:
                        context.push(AppRoute.VIEWRECEIVEDADDFRIENDS);
                        break;
                      case 5 :

                            userRe.logOutUser();
                            SocketUtil.cancelEventReceiver();
                            SocketUtil.disconnect();
                            context.go(AppRoute.LOGIN);
                            sharedPreferences.setString(
                                keyShared.GOOGLEGMAIL, "");
                            sharedPreferences.setString(
                                keyShared.GOOGLEIMAGE, "");
                            sharedPreferences.setString(
                                keyShared.GOOGLENAMEDISPLAY, "");
                            sharedPreferences.setString(keyShared.IDUSER, "");
                            SocketUtil.socket = null;
                            googleSigninAccount.signOut();
                            context.read<CubitLoginCubit>().logout();
                        break;
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10, left: 4, right: 4),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            offset: Offset(0, 2),
                          ),
                        ],
                        color: HexColor("ffffff"),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(icons[index]),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          options[index],
                          style: TextStyle(fontFamily: 'Roboto'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
