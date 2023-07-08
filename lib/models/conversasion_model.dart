class conversasionModel {
  final String id;
  final String created_at;
  final String updated_at;
  final List<dynamic> members;
  final List<dynamic> messages;
  conversasionModel({required this.id,required this.members,required this.messages,required this.created_at,required this.updated_at});
  factory conversasionModel.fromJson(Map<String,dynamic>  map){
    return conversasionModel(
      id  : map['_id'],
      members: map['members'], 
      messages: map['messages'],
      created_at : map['created_at'],
      updated_at : map['updated_at']
      );
  }
}

// map['messages'].map((e)=>messageModel.fromJson(e)).toList()