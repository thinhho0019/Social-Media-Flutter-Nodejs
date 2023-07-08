part of 'conversasion_bloc.dart';

abstract class ConversasionState extends Equatable {
  const ConversasionState();
  
  @override
  List<Object> get props => [];
}

class ConversasionInitial extends ConversasionState {}
class ConversasionLoading extends ConversasionState {
 
  
  @override
  List<Object> get props => [];
}
class ConversasionShowed extends ConversasionState {
  final List<conversasionModel> converList;
  ConversasionShowed({required this.converList});
  
  @override
  List<Object> get props => [converList];
}
 
class ConversasionError extends ConversasionState {
  final String error;
  ConversasionError({required this.error});
  
  @override
  List<Object> get props => [error];
}
class ConversasionEmpty extends ConversasionState {
 
  ConversasionEmpty();
  
  @override
  List<Object> get props => [];
}
class messageChatShowed extends ConversasionState {
  final List<messageModel> converList;
  messageChatShowed({required this.converList});
  
  @override
  List<Object> get props => [converList];
}
class messageReceiverChatShowed extends ConversasionState {
  final List<messageModel> converList;
  messageReceiverChatShowed({required this.converList});
  
  @override
  List<Object> get props => [converList];
}