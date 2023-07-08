import 'package:bloc/bloc.dart';
enum BottomNavigationEvent {post, home, friends, profile }
class NavBlocBloc extends Bloc<BottomNavigationEvent, int> {

  NavBlocBloc() : super(0) {
    on<BottomNavigationEvent>(_choseBottom);
  }

  void _choseBottom(BottomNavigationEvent event, Emitter<int> emit) {
    switch (event) {
      case BottomNavigationEvent.post:
        emit(0);
        break;
      case BottomNavigationEvent.home:
        emit(1);
        break;
      case BottomNavigationEvent.friends:
        emit(2);
        break;
      case BottomNavigationEvent.profile:
        emit(3);
        break;
    }
  }
}
