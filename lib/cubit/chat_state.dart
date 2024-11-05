abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Map<String, dynamic>> messages;

  ChatLoaded(this.messages);
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}

class GetAllUsersSuccess extends ChatState {
  final List<Map<String, dynamic>> users;

  GetAllUsersSuccess(this.users);
}

class GetUserLoading extends ChatState {}

class GetUserError extends ChatState {
  final String message;

  GetUserError(this.message);
}
