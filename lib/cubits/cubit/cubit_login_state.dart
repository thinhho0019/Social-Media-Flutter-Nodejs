part of 'cubit_login_cubit.dart';


enum AuthStatus{unknown,authenticated,unauthenticated}

 class CubitLoginState extends Equatable{
    final AuthStatus status;
    const CubitLoginState._({this.status = AuthStatus.unknown});
    const CubitLoginState.authenticated() : this._(status: AuthStatus.authenticated);
    const CubitLoginState.unauthenticated() :this._(status: AuthStatus.unauthenticated);
    const CubitLoginState.unknown() :this._(status: AuthStatus.unknown);
    @override
    List<Object?> get props => [status];
}

 
