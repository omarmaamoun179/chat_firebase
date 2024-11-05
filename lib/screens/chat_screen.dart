import 'package:chat_firebase/cache_helper.dart';
import 'package:chat_firebase/cubit/auth_cubit.dart';
import 'package:chat_firebase/cubit/chat_cubit.dart';
import 'package:chat_firebase/cubit/chat_state.dart';
import 'package:chat_firebase/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  final _controller = TextEditingController();
  static String ChatRoute = '/chat';

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App with Cubit'),
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
                        date: message['createdAt'].toString(),
                        message['message'],
                        message['userId'] == userId,
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
                    context
                        .read<ChatCubit>()
                        .sendMessage(_controller.text, userId!.uid);
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

  const MessageBubble(this.message, this.isMe, {super.key, required this.date});

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
