part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  const NotificationState();
  
  @override
  List<Object> get props => [];
}

class NotificationLoading extends NotificationState {}
class NotificationShowed extends NotificationState {
  final List<notificationModel> data;
   const  NotificationShowed({required this.data});
  
  @override
  List<Object> get props => [data];
}
class NotificationError extends NotificationState {}