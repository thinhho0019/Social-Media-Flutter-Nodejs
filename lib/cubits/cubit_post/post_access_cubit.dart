import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'post_access_state.dart';

class PostAccessCubit extends Cubit<PostAccessState> {
  PostAccessCubit() : super(PostAccessState.public());
  void public(){
    emit( PostAccessState.public());
  }
  void friend(){
    emit( PostAccessState.friend());
  }
  void private(){
    emit( PostAccessState.private());
  }

}
