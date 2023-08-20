import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/MyBlocObserver.dart';
import 'package:todo/ToDo_App.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoApp()
    );
  }
}
