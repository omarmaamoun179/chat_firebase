import 'dart:developer';

import 'package:chat_firebase/cubit/auth_cubit.dart';
import 'package:chat_firebase/cubit/chat_cubit.dart';
import 'package:chat_firebase/cubit/chat_state.dart';
import 'package:chat_firebase/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllChat extends StatefulWidget {
  const AllChat({super.key});

  static String allChatRoute = '/allChat';

  @override
  State<AllChat> createState() => _AllChatState();
}

class _AllChatState extends State<AllChat> {
  @override
  void didUpdateWidget(covariant AllChat oldWidget) {
    super.didUpdateWidget(oldWidget);
    context.read<ChatCubit>().getUsers();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = context.read<AuthCubit>().user;
    return Scaffold(
      body: BlocBuilder<ChatCubit, ChatState>(
        buildWhen: (previous, current) =>
            current is GetAllUsersSuccess || current is GetUserError,
        builder: (context, state) {
          if (state is GetAllUsersSuccess) {
            final filteredUsers = state.users
                .where((user) => user["id"] != currentUser?.uid)
                .toList();
            return Column(
              children: [
                Expanded(
                  child: filteredUsers.isEmpty
                      ? const Center(
                          child: Text(
                              "No Users , Please wait until any one send you"),
                        )
                      : ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (ctx, index) {
                            return GestureDetector(
                              onTap: () {
                                log('User ID: ${filteredUsers[index]["id"]}');

                                Navigator.pushNamed(
                                    context, ChatScreen.ChatRoute,
                                    arguments: filteredUsers[index]["id"]);
                              },
                              child: ListTile(
                                title: Text(
                                    'User Name: ${filteredUsers[index]["name"]}'),
                                // subtitle:
                                //     Text(state.users[index]["lastMessage"] ?? ""),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          } else if (state is GetUserError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
