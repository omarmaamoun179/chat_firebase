class AllUsersModel{ 
  List<UserModel>? users;
  AllUsersModel({this.users});
  factory AllUsersModel.fromJson(List<dynamic> json){
    return AllUsersModel(
      users: json.map((e) => UserModel.fromJson(e)).toList()
    );
  }
}

class UserModel {
  String? id;
  String? name;
  String? email;
  String? lastMessage;
  UserModel({this.id, this.name, this.email, this.lastMessage});
  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      lastMessage: json['lastMessage']
    );
  }
}