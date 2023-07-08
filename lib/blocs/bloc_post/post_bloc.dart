import 'dart:async';

import 'package:appchat_socket/models/image_post.dart';
import 'package:appchat_socket/models/post.dart';
import 'package:appchat_socket/repostiory/post_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostLoading()) {
    on<PostShowList>(_PostShowList);
    on<addPost>(_addPost);
    on<likePost>(_likePost);
    on<commentUpCountPost>(_commentUpCountPost);
    on<deletePost>(_deletePost);
    on<updatePost>(_updatePost);
    on<showPostPlus>(_showPostPlus);
  }

  void _PostShowList(PostShowList event, Emitter<PostState> emit) async {
    final state = this.state;
    String action = event.action;
    String user = event.user;
    try {
      if (event.action == "post") {
        emit(PostLoading());
        List<post> data = await postRe.getPost();
        emit(await PostShowed(listPost: data, listPostUser: []));
      } else if (event.action == "user") {
        if (state is PostShowed) {
          List<post> dataUser = await postRe.getPostForUser(user);
          emit(await PostShowed(
              listPost: state.listPost, listPostUser: dataUser));
        }
      }
    } catch (e) {
      emit(PostShowError(e.toString()));
    }
  }

  void _addPost(addPost event, Emitter<PostState> emit) async {
    final state = this.state;
    try {
      if (state is PostShowed) {
        List<post> result = state.listPost ?? [];
        List<post> resultUser = state.listPostUser ?? [];
        if (event.action == "post") {
          result = List.from(state.listPost)..insert(0, event.Post);
        } else if (event.action == "user") {
          resultUser = List.from(state.listPostUser)..insert(0, event.Post);
        }

        emit(await PostShowed(listPost: result, listPostUser: resultUser));
      }
    } catch (e) {
      emit(PostShowError(e.toString()));
    }
  }

  void _likePost(likePost event, Emitter<PostState> emit) async {
    final state = this.state;

    try {
      if (state is PostShowed) {
        List<post> result = state.listPost;
        List<post> resultUser = state.listPostUser;
        if (event.action == "post") {
          post data = state.listPost[event.index];
          int like_count = data.like_count;
          bool temp = data.liked;
          result = List.from(state.listPost)..removeAt(event.index);
          if (temp) {
            await postRe.likePost(data.id,event.userReceiNoti);
            like_count = like_count - 1;
            result.insert(
                event.index,
                data.copyWith(null, like_count, null, null, null, false, null,
                    null, null));
          } else {
            await postRe.likePost(data.id,event.userReceiNoti);
            like_count = like_count + 1;
            result.insert(
                event.index,
                data.copyWith(null, like_count, null, null, null, true, null,
                    null, null));
          }
        } else if (event.action == "user") {
          post data = state.listPostUser[event.index];
          int like_count = data.like_count;
          bool temp = data.liked;
        
          if (List.from(state.listPostUser).length > 1) {
            resultUser = List.from(state.listPostUser)..removeAt(event.index);
            if (temp) {
              await postRe.likePost(data.id,event.userReceiNoti);
              like_count = like_count - 1;
              resultUser.insert(
                  event.index,
                  data.copyWith(null, like_count, null, null, null, false, null,
                      null, null));
            } else {
              await postRe.likePost(data.id,event.userReceiNoti);
              like_count = like_count + 1;
              resultUser.insert(
                  event.index,
                  data.copyWith(null, like_count, null, null, null, true, null,
                      null, null));
            }
          } else {
            resultUser = [];
            if (temp) {
              await postRe.likePost(data.id,event.userReceiNoti);
              like_count = like_count - 1;
              resultUser.insert(
                  event.index,
                  data.copyWith(null, like_count, null, null, null, false, null,
                      null, null));
            } else {
              await postRe.likePost(data.id,event.userReceiNoti);
              like_count = like_count + 1;
              resultUser.insert(
                  event.index,
                  data.copyWith(null, like_count, null, null, null, true, null,
                      null, null));
            }
          }
        }
        //post

        emit(await PostShowed(listPost: result, listPostUser: resultUser));
      }
    } catch (e) {
      emit(PostShowError(e.toString()));
    }
  }

  void _commentUpCountPost(
      commentUpCountPost event, Emitter<PostState> emit) async {
    final state = this.state;
    try {
      if (state is PostShowed) {
        List<post> result = state.listPost;
        List<post> resultUser = state.listPostUser;
        if (event.action == "post") {
          post data = state.listPost[event.index];
          int comment_count = data.comment_count;
          bool temp = data.liked;
          result = List.from(state.listPost)..removeAt(event.index);
          comment_count = comment_count + 1;
          result.insert(
              event.index,
              data.copyWith(null, null, null, null, null, false, comment_count,
                  null, null));
        } else if (event.action == "user") {
          post data = state.listPostUser[event.index];
          int comment_count = data.comment_count;
          bool temp = data.liked;
          resultUser = List.from(state.listPost)..removeAt(event.index);
          comment_count = comment_count + 1;
          resultUser.insert(
              event.index,
              data.copyWith(null, null, null, null, null, false, comment_count,
                  null, null));
        }

        emit(await PostShowed(listPost: result, listPostUser: resultUser));
      }
    } catch (e) {
      emit(PostShowError(e.toString()));
    }
  }

  void _deletePost(deletePost event, Emitter<PostState> emit) async {
    final state = this.state;
    try {
      if (state is PostShowed) {
        List<post> result = state.listPost ?? [];
        List<post> resultUser = state.listPostUser ?? [];
        List<String> ds = [];
        event.image.forEach((element) {
          ds.add(element.image_url);
        });
        bool check = await postRe.deletePost(event.idpost, ds);
        if (check) {
          if (event.index == 0) {
            resultUser = [];
          } else {
            resultUser = List.from(state.listPostUser)..removeAt(event.index);
          }

          emit(await PostShowed(listPost: result, listPostUser: resultUser));
        }
      }
    } catch (e) {
      emit(PostShowError(e.toString()));
    }
  }

  void _updatePost(updatePost event, Emitter<PostState> emit) async {
    final state = this.state;
    try {
      if (state is PostShowed) {
        List<post> result = state.listPost ?? [];
        List<post> resultUser = state.listPostUser ?? [];
        List<imagePost> img = await postRe.updatePost(event.image,
            event.content, event.access, event.imageold, event.idpost);

        //update
        post p = resultUser[event.index];
        resultUser = List.from(state.listPostUser)..removeAt(event.index);

        post resultp = p.copyWith(null, null, null, event.access, null, null,
            null, img, event.content);
        resultUser.insert(0, resultp);

        emit(await PostShowed(listPost: result, listPostUser: resultUser));
      }
    } catch (e) {
      emit(PostShowError(e.toString()));
    }
  }

  void _showPostPlus(showPostPlus event, Emitter<PostState> emit) async {
    final state = this.state;
    try {
      if (state is PostShowed) {
        List<post> result = state.listPost ?? [];
        List<post> resultUser = state.listPostUser ?? [];
        if (event.action == "post" && result !=[]) {
          List<post> data = await postRe.getPost();
          if(data.length!=0)
          for (post r in data) {
            int flag = 0;
            int dem = 0;
            int index = 0;
            
            for (post d in result) {
              
              if (r.id == d.id) {
                
                flag = 1;
              }
            }
            if (flag == 0) {
              result = List.from(state.listPost)..add(r);
            }
          }
        } else if (event.action == "user") {
          List<post> dataUser = await postRe.getPostForUser(event.user);
          resultUser.addAll(dataUser);
        }

        emit(await PostShowed(listPost: result, listPostUser: resultUser));
      }
    } catch (e) {
      emit(PostShowError(e.toString()));
    }
  }
}
