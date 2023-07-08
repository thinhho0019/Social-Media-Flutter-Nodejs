part of 'user_detail_bloc.dart';
class UserDetailState extends Equatable {
  const UserDetailState();
  
  @override
  List<Object> get props => [];
}

class UserDetaiLoading extends UserDetailState {}
class UserDetaiStopLoading extends UserDetailState {}
class UserShowInformation extends UserDetailState {
  final userModel user;
  const UserShowInformation({required this.user});
  
  @override
  List<Object> get props => [user];
}
class UserShowInformationError extends UserDetailState {}