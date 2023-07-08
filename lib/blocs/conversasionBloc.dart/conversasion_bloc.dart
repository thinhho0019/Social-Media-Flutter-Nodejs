import 'dart:async';

import 'package:appchat_socket/models/conversasion_model.dart';
import 'package:appchat_socket/models/message_model.dart';
import 'package:appchat_socket/repostiory/conversasion_repository.dart';
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:appchat_socket/utils/sort_util.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'conversasion_event.dart';
part 'conversasion_state.dart';

class ConversasionBloc extends Bloc<ConversasionEvent, ConversasionState> {
  conversasionRepository _repo;
  ConversasionBloc({required conversasionRepository repo})
      : _repo = repo,
        super(ConversasionLoading()) {
    on<conversasionShowAllChats>(_conversasionShowAllChats);
    on<showMessageChats>(_showMessageChats);
    on<sendMessageChat>(_sendMessageChat);
    on<receiverMessageChat>(_receiverMessageChat);
    on<updateStatusMessage>(_updateStatusMessageChat);
    on<receiveConversation>(_receiveConversation);
  }

  void _conversasionShowAllChats(
      conversasionShowAllChats event, Emitter<ConversasionState> emit) async {
    emit(ConversasionLoading());
    try {
      List<conversasionModel> value = await _repo
          .getMessageByUserId(sharedPreferences.getString(keyShared.IDUSER));

      if (value.length > 0) {
        emit(ConversasionShowed(converList: sortUtil.sortCoversation(value)));
      } else {
        emit(ConversasionEmpty());
      }
    } catch (e) {
      emit(ConversasionError(error: e.toString()));
    }
  }

  void _showMessageChats(
      showMessageChats event, Emitter<ConversasionState> emit) async {
    emit(ConversasionLoading());
    try {
      List<messageModel> value = [];

      value = await _repo.getChatMessageByUserId(event.conversasionid);
      if (value.length > 0) {
        emit(messageChatShowed(converList: value));
      } else {
        emit(ConversasionEmpty());
      }
    } catch (e) {
      emit(ConversasionError(error: e.toString()));
    }
  }

  void _sendMessageChat(
      sendMessageChat event, Emitter<ConversasionState> emit) async {
    final state = this.state;
    if (state is messageChatShowed) {
      
        emit(await messageChatShowed(
            converList: List.from(state.converList)..insert(0, event.mess)));
      
    }else if(state is ConversasionEmpty){
        List<messageModel> data = [];
        emit(await messageChatShowed(
            converList: data..insert(0, event.mess)));
       
    }
  }

  void _receiverMessageChat(
      receiverMessageChat event, Emitter<ConversasionState> emit) async {
    final state = this.state;
    if (state is messageChatShowed) {
      emit(await messageChatShowed(
          converList: List.from(state.converList)..insert(0, event.mes)));
    }else if(state is ConversasionEmpty){
      List<messageModel> ds = [];
      ds.add(event.mes);
      emit(await messageChatShowed(
          converList: ds));
    }
  }

  void _updateStatusMessageChat(
      updateStatusMessage event, Emitter<ConversasionState> emit) async {
    final state = this.state;
    if (state is messageChatShowed) {
      messageModel index = state.converList[0];
      if (index.status != "seen") {
        state.converList..remove(index);
        index.status = event.action;

        emit(await messageChatShowed(
            converList: List.from(state.converList)..insert(0, index)));
      }
    }
  }

  void _receiveConversation(
      receiveConversation event, Emitter<ConversasionState> emit) async {
    try {
      final state = this.state;
      if (state is ConversasionShowed) {
        emit(ConversasionShowed(
            converList: List.from(state.converList)..insert(0, event.mes)));
      }
    } catch (e) {
      emit(ConversasionError(error: e.toString()));
    }
  }
}
