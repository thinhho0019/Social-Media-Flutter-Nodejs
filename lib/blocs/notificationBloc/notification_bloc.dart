import 'dart:async';

import 'package:appchat_socket/models/notification_model.dart';
import 'package:appchat_socket/repostiory/notification_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  notificationRepository _noti;
  NotificationBloc({required notificationRepository noti}) : _noti=noti,super(NotificationLoading()) {
    on<NotificationEventShowNoti>(_NotificationEventShowNoti);
  }

  void _NotificationEventShowNoti(NotificationEventShowNoti event, Emitter<NotificationState> emit) async{
    emit(NotificationLoading());
    try{
      List<notificationModel> result = await _noti.getAllNotification();
      emit(NotificationShowed(data: result.reversed.toList()));
    }catch(e){
       emit(NotificationError());
    }
  }
}
