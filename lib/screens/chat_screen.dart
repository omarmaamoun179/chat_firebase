import 'dart:developer';

import 'package:chat_firebase/cache_helper.dart';
import 'package:chat_firebase/cubit/auth_cubit.dart';
import 'package:chat_firebase/cubit/chat_cubit.dart';
import 'package:chat_firebase/cubit/chat_state.dart';
import 'package:chat_firebase/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  static String ChatRoute = '/chat';

  final String otherUserId;

  const ChatScreen({super.key, required this.otherUserId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final currentUserId = context.read<AuthCubit>().user!.uid;
    log("Other User ID: ${widget.otherUserId}");
    context.read<ChatCubit>().fetchMessages(currentUserId, widget.otherUserId);
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthCubit>().user?.uid;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              CacheHelper.removeData(key: 'token').then((value) {
                context.read<AuthCubit>().signOut();
                if (value) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.loginRoute, (route) => false);
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              buildWhen: (previous, current) => current is ChatLoaded,
              builder: (ctx, chatState) {
                if (chatState is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (chatState is ChatLoaded) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: chatState.messages.length,
                    itemBuilder: (ctx, index) {
                      final message = chatState.messages[index];
                      return MessageBubble(
                        date: message['timestamp'].toDate().toString(),
                        message: message['messageText'] ??
                            'No message content', // استخدام قيمة افتراضية
                        isMe: message['senderId'] == currentUserId,
                      );
                    },
                  );
                } else if (chatState is ChatError) {
                  return Center(child: Text(chatState.message));
                }
                return Container();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(labelText: 'Send a message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    context.read<ChatCubit>().sendMessage(
                          _controller.text,
                          currentUserId ?? '',
                          widget.otherUserId,
                        );
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String date;

  const MessageBubble(
      {required this.message,
      required this.isMe,
      required this.date,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isMe ? Colors.grey[300] : Colors.blue[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(message),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(textAlign: TextAlign.start, date.substring(11, 16)),
        ],
      ),
    );
  }
}
