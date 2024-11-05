import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final firestore = FirebaseFirestore.instance;

  void getUsers() {
    firestore.collection('chat').snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        log("User Chat: $doc");
      }
    });
  }

  void fetchMessages() {
    emit(ChatLoading());
    firestore
        .collection('chat')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .listen((snapshot) {
      final messages = snapshot.docs
          .map((doc) => {
                'message': doc['message'],
                'userId': doc['userId'],
                'createdAt': doc['createdAt'],
              })
          .toList();

      emit(ChatLoaded(messages));
    });
  }

  Future<void> sendMessage(String message, String userId) async {
    if (message.isEmpty) return;

    try {
      await firestore.collection('chat').add({
        'message': message,
        'createdAt': DateTime.fromMillisecondsSinceEpoch(
                DateTime.now().millisecondsSinceEpoch)
            .toIso8601String(),
        'userId': userId,
      });
      await firestore.collection('users').doc(userId).update({
        'lastMessage': message,
 
      });
    } catch (e) {
      log(e.toString());
      emit(ChatError(e.toString()));
    }
  }
}
