import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cubit_login_state.dart';

class CubitLoginCubit extends Cubit<CubitLoginState> {
  CubitLoginCubit() : super(const CubitLoginState.unauthenticated());

  void unknowns(){
    emit(const CubitLoginState.unknown());
  }
  void login(){
    emit(const CubitLoginState.authenticated());
  }
  void logout(){
    emit(const CubitLoginState.unauthenticated());
  }
}
