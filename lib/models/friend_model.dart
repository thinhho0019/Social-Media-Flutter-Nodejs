class friendModel {
  final String user1;
  final String user2;
  final String status;
  final String create_at;
  final String action_user;
  final String update_at;
  friendModel({
    required this.user1,
    required this.user2,
    required this.status,
    required this.action_user,
    required this.create_at,
    required this.update_at
  });
  factory friendModel.fromJson(Map<String, dynamic> map) {
    return friendModel(
      user1: map['user1'],
      user2: map['user2'],
      create_at: map['create_at'] ?? "",
      status: map['status'] ?? "",
      action_user: map['action_user'] ?? "",
      update_at: map['update_at']??""
    );
  }
}
