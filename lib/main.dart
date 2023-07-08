import 'dart:async';
import 'dart:ui';
import 'package:appchat_socket/api/firebase_api.dart';
import 'package:appchat_socket/blocs/bloc_post/post_bloc.dart';
import 'package:appchat_socket/blocs/notificationBloc/notification_bloc.dart';
import 'package:appchat_socket/cubits/cubit/cubit_login_cubit.dart';
import 'package:appchat_socket/cubits/cubit_post/post_access_cubit.dart';
import 'package:appchat_socket/goRouter/app_page.dart';
import 'package:appchat_socket/repostiory/notification_repository.dart';
import 'package:appchat_socket/utils/global.color.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await sharedPreferences.initPreference();
  await Firebase.initializeApp();
  await FirebaseApi.initNotification();
  requestNotificationPermission();
  runApp(const MyApp());
}



//ask permison
Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;
  if (status != PermissionStatus.granted) {
    final result = await Permission.notification.request();
    if (result != PermissionStatus.granted) {
      throw Exception('User declined to grant notification permissions');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          GlobalColors.mainColor, // sử dụng màu chủ đạo của giao diện
      statusBarIconBrightness: Brightness.dark,
    ));
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CubitLoginCubit()),
        BlocProvider(
          create: (context) => PostAccessCubit(),
        ),
        BlocProvider(
          create: (context) => PostBloc(),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(noti: notiRe),
        ),
      ],
      child: Builder(builder: (context) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          routerConfig: AppPage(context.read<CubitLoginCubit>()).goRoute,
        );
      }),
    );
  }
}
