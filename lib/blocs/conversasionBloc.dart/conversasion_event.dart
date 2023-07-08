part of 'conversasion_bloc.dart';

abstract class ConversasionEvent extends Equatable {
  const ConversasionEvent();

  @override
  List<Object> get props => [];
}
class conversasionShowAllChats extends ConversasionEvent{
   conversasionShowAllChats();

  @override
  List<Object> get props => [];
}
class showMessageChats extends ConversasionEvent{
  final String conversasionid;
  final String userid;
   showMessageChats({required this.userid,required this.conversasionid});

  @override
  List<Object> get props => [userid];
}
class sendMessageChat extends ConversasionEvent{
   final messageModel mess;
   sendMessageChat(this.mess);

  @override
  List<Object> get props => [mess];
}
class receiveConversation extends ConversasionEvent{
  final conversasionModel mes;
  receiveConversation({required this.mes});
  
  @override
  List<Object> get props => [mes];
}
 class receiverMessageChat extends ConversasionEvent{
   final messageModel mes;
   receiverMessageChat(this.mes);

  @override
  List<Object> get props => [mes];
}
 class updateStatusMessage extends ConversasionEvent{
  final String action;
   updateStatusMessage(this.action);

  @override
  List<Object> get props => [action];
 }