import 'package:appchat_socket/models/post.dart';
import 'package:appchat_socket/models/user_model.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'dart:async';
import 'package:appchat_socket/cubits/cubit/cubit_login_cubit.dart';
import 'package:appchat_socket/goRouter/app_route.dart';
import 'package:appchat_socket/view/bottom_navigation.dart';
import 'package:appchat_socket/view/chat_view.dart';
import 'package:appchat_socket/view/first_view_login.dart';
import 'package:appchat_socket/view/login_view.dart';
import 'package:appchat_socket/view/screens.dart/edit_main_profile_screen.dart';
import 'package:appchat_socket/view/screens.dart/friends_received_screen.dart';
import 'package:appchat_socket/view/screens.dart/friends_request_screen.dart';
import 'package:appchat_socket/view/screens.dart/main_profile_screen.dart';
import 'package:appchat_socket/view/screens.dart/notification_screen.dart';
import 'package:appchat_socket/view/screens.dart/post_screen/detailPostScreen.dart';
import 'package:appchat_socket/view/search_view.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppPage {
  final CubitLoginCubit loginCubit;
  AppPage(this.loginCubit);
  late final GoRouter goRoute = GoRouter(
    debugLogDiagnostics: true,
    routes: <GoRoute>[
      GoRoute(
        path: AppRoute.HOME,
        name: 'home',
        builder: (context, state) => FirstViewLogin(),
      ),
      GoRoute(
        path: AppRoute.VIEWCHAT,
        builder: (context, state) => BottomNavigation(
          idpage: 0,
        ),
      ),
      GoRoute(
        path: AppRoute.VIEWDETAILPOST,
        name: AppRoute.VIEWDETAILPOST,
        builder: (context, state) {
           Map<String,dynamic> data =  state.extra as Map<String,dynamic>;
          return deTailPostScreen(postDetail: data['post'] ,action: data['action'],index: data['index'],);
        } 
      ),
      GoRoute(
          path: AppRoute.VIEWMAINPROFILE,
          name: 'mainprofile',
          builder: (context, state) => mainProfileScreen(user: state.params['userid']??"",)),
      GoRoute(
          path: AppRoute.VIEWEDITMAINPROFILE,
          name: 'editmainprofile',
          builder: (context, state) {
            Map<String,dynamic> data =  state.extra as Map<String,dynamic>;
 

            return editMainProfileScreen(user: data['arg1'],userD: data['arg2'],);
          } 
          
          ),
      GoRoute(
          path: AppRoute.LOGIN,
          name: 'login',
          builder: (context, state) =>const loginView()),
      GoRoute(
          path: AppRoute.VIEWSENTADDFRIENDS,
          name: 'sentaddfriend',
          builder: (context, state) => friendsRequest()),
      GoRoute(
          path: AppRoute.VIEWRECEIVEDADDFRIENDS,
          name: 'sentreceivedfriend',
          builder: (context, state) => friendsReceiced()),
      GoRoute(
          path: AppRoute.VIEWNOTIFICATION,
         
          builder: (context, state) => notificationScreen()),
      GoRoute(
        path: "/backviewchat/:id",
        name: "backviewchat",
        builder: (context, state) => BottomNavigation(
          idpage: int.parse(state.params['id']!),
        ),
      ),
      GoRoute(
          path: AppRoute.VIEWMESSAGE,
          name: 'message',
          builder: (context, state) =>  chatView(
                conversasionid: state.params['conversasionid'] ?? "",
                userid: state.params['userid'] ?? "",
                avatar: state.params['avatar'] ?? "",
                name: state.params['name'] ?? "",
                seen: state.params['seen'] ?? "",
              )),
      GoRoute(
          path: AppRoute.VIEWSEARCH,
          name: 'search_friend',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: SearchView(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutBack)
                      .animate(animation),
                  child: child,
                );
              },
            );
          }),
    ],
    redirect: ((context, state) async {
      final bool loggedIn = loginCubit.state.status == AuthStatus.authenticated;
      final bool unknown =
          loginCubit.state.status == AuthStatus.unauthenticated;
      final bool loggingIn = state.subloc == "/login";
      final bool home = state.subloc == "/";
      final currentAccount = sharedPreferences.getString(keyShared.GOOGLEGMAIL);
      if(state.subloc== AppRoute.VIEWSEARCH){
        return AppRoute.VIEWSEARCH;
      }

      if (home == true) {
        return AppRoute.HOME;
      }
      if (unknown == true && state.subloc == "/login") {
        return AppRoute.LOGIN;
      }
      
      switch (state.subloc) {
        case AppRoute.VIEWSEARCH:
          return AppRoute.VIEWSEARCH;
        case AppRoute.VIEWCHAT + "/viewfriend" + "/2":
          return AppRoute.VIEWCHAT + "/viewfriend" + "/2";
        case "/backviewchat/1":
          return "/backviewchat" + "/1";
        case AppRoute.LOGIN:
          return !currentAccount.isEmpty ? AppRoute.VIEWCHAT : AppRoute.LOGIN;
        case AppRoute.VIEWMESSAGE:
          return AppRoute.VIEWMESSAGE;
        case AppRoute.VIEWSENTADDFRIENDS:
          return AppRoute.VIEWSENTADDFRIENDS;
        case AppRoute.VIEWRECEIVEDADDFRIENDS:
          return AppRoute.VIEWRECEIVEDADDFRIENDS;
        default:
          break;
      }

      return null;
    }),
    refreshListenable: GoRouterRefeshStream(loginCubit.stream),
  );
}

class GoRouterRefeshStream extends ChangeNotifier {
  GoRouterRefeshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }
  late final StreamSubscription<dynamic> _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
