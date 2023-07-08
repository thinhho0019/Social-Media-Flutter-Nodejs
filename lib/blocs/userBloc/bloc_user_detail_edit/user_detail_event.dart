part of 'user_detail_bloc.dart';

class UserDetailEvent extends Equatable {
  const UserDetailEvent();

  @override
  List<Object> get props => [];
}
class showInformation extends UserDetailEvent {
  final String user;
  const showInformation({required this.user});
  @override
  List<Object> get props => [];
}

class updateProfile extends UserDetailEvent {
  final userDetail user;
  const updateProfile({required this.user});

  @override
  List<Object> get props => [user];
}

class updateImageAvatar extends UserDetailEvent {
  final String userid;
  final String namefileole;
  final XFile fileimage;
  const updateImageAvatar( {required this.fileimage, required this.userid,required this.namefileole,});

  @override
  List<Object> get props => [userid,namefileole,fileimage];
}
class updateImageBackground extends UserDetailEvent {
  final String userid;
  final String namefileole;
  final XFile fileimage;
  const updateImageBackground( {required this.fileimage, required this.userid,required this.namefileole,});

  @override
  List<Object> get props => [userid,namefileole,fileimage];
}