import 'dart:developer';

import 'package:chat_firebase/bloc_observe.dart';
import 'package:chat_firebase/cache_helper.dart';
import 'package:chat_firebase/constant/constance.dart';
import 'package:chat_firebase/cubit/auth_cubit.dart';
import 'package:chat_firebase/cubit/chat_cubit.dart';
import 'package:chat_firebase/firebase_options.dart';
import 'package:chat_firebase/screens/chat_screen.dart';
import 'package:chat_firebase/screens/login_screen.dart';
import 'package:chat_firebase/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = MyBlocObserver();

  final prefs = await SharedPreferences.getInstance();
  Constance.token = prefs.getString('token');
  log('Token: ${Constance.token}');
  CacheHelper.initCache();

  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => ChatCubit()
            ..fetchMessages()
            ..getUsers(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: (Constance.token?.isNotEmpty ?? false)
            ? ChatScreen.ChatRoute
            : LoginScreen.loginRoute,
        routes: {
          LoginScreen.loginRoute: (context) => const LoginScreen(),
          RegisterScreen.registerRoute: (context) => const RegisterScreen(),
          ChatScreen.ChatRoute: (context) => ChatScreen(),
        },
      ),
    );
  }
}
