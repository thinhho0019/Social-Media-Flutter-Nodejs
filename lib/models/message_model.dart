class messageModel {
  final String id;
  final String sender;
  final String text;
  final String createdAt;
   String status;
  messageModel(
      {required this.id,
      required this.sender,
      required this.text,
      required this.createdAt,required this.status,});
  factory messageModel.fromJson(Map<String, dynamic> map) {
    return messageModel(
        id: map['_id'],
        sender: map['sender'],
        text: map['text'],
        createdAt: map['created_at'],
        status: map['status']);
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sender': sender,
      'text': text,
      'create_at': createdAt,
      'status': status
    };
  }
}
