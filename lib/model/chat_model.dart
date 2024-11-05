class ChatModel {
  final String? name;
  final String? message;
  final String? time;
  final String? avatarUrl;

  ChatModel({this.name, this.message, this.time, this.avatarUrl});


  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      name: json['name'],
      message: json['message'],
      time: json['time'],
      avatarUrl: json['avatarUrl'],
    );
  }
}