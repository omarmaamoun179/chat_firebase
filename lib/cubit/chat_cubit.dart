import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final firestore = FirebaseFirestore.instance;

  String generateChatRoomId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join("_");
  }

  void getUsers() {
    emit(GetUserLoading());

    try {
      firestore.collection('users').snapshots().listen((snapshot) {
        final users = snapshot.docs.map((e) {
          final data = e.data();
          log("User: ${data['name']}");
          return {
            "id": e.id,
            "name": e['name'],
            "lastMessage":
                e.data().containsKey('lastMessage') ? e['lastMessage'] : "",
          };
        }).toList();
        emit(GetAllUsersSuccess(users));
      });
    } on Exception catch (e) {
      emit(GetUserError(e.toString()));
    }
  }

  void fetchMessages(String userId, String otherUserId) {
    emit(ChatLoading());

    String chatRoomId = generateChatRoomId(userId, otherUserId);

    firestore
        .collection('chat')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      final messages = snapshot.docs.map((doc) {
        final data = doc.data();
        print("Fetched message: ${data['messageText']}");
        return {
          'messageText': data['messageText'] ?? 'No message content',
          'senderId': data['senderId'] ?? '',
          'timestamp': data['timestamp'] ?? Timestamp.now(),
        };
      }).toList();

      emit(ChatLoaded(messages));
    }, onError: (error) {
      emit(ChatError(error.toString()));
    });
  }

  Future<void> sendMessage(
      String message, String userId, String otherUserId) async {
    if (message.isEmpty) return;

    String chatRoomId = generateChatRoomId(userId, otherUserId);
    final timestamp = Timestamp.now();

    try {
      await firestore
          .collection('chat')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'messageText': message,
        'senderId': userId,
        'receiverId': otherUserId,
        'timestamp': timestamp,
      });

      await firestore.collection('chat').doc(chatRoomId).set({
        'message': message,
        'userId': userId,
        'createdAt': timestamp,
      }, SetOptions(merge: true));

      await firestore.collection('users').doc(userId).update({
        'lastMessage': message,
      });

      // Optionally, update last message in the other user's document as well
      await firestore.collection('users').doc(otherUserId).update({
        'lastMessage': message,
      });
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
