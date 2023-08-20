import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/todo_cubit/Todo_States.dart';

class TodoCubit extends Cubit<TodoStates>{
  TodoCubit():super(TodoInitalState());

  static TodoCubit get(context)=> BlocProvider.of(context);

  late Database database;

  var titelController = new TextEditingController();
  var timeController = new TextEditingController();
  var dateController = new TextEditingController();


  var isBottomSheetShown=false;
  IconData bottomSheetIcon=Icons.edit;
  void createDatabase() {
    openDatabase(
      'todoDB.db',
      version: 1,
      onCreate: (db, version) {
        print("Database Created");
        db
            .execute(
                "Create Table tasks (id INTEGER PRIMARY KEY, title TEXT,date TEXT ,time TEXT)")
            .then((value) {
          print("Table created");
        }).catchError((onError) {
          print("Catched Error is ${onError.toString()}");
        });
      },
      onOpen: (db) {
        print("Database Opened");
        getDataFromDatabase(database: db);
      },
    ).then((value) {
      database = value;
      emit(createDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String date,
    required String time
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'Insert into tasks (title,date,time) VALUES ("${title}","${date}","${time}")')
          .then((value) {
        print("$value insteresd successfully");
        emit(insertToDatabaseState());
        getDataFromDatabase(database: database);

      }).catchError((onError) {
        print("inserting Error is ${onError.toString()}");
      });
    });
  }


  List<Map> tasks=[];

   void getDataFromDatabase({
    required Database database
   }){
    database.rawQuery("Select * from tasks").then((value){
      tasks=value;
      emit(getDataFromDatabaseState());
      print(tasks);
    });
   }

   void deleteFromDatabase(
    {
      required int id
    }
   ){
    database.rawDelete("delete from tasks where id=?",[id]).then((value) {
      getDataFromDatabase(database: database);
      emit(deleteFromDatabaseState());
    }
    );
   }

   void changeBottomSheet({
    required bool isShown,
    required IconData icon
   }){
    isBottomSheetShown=isShown;
    bottomSheetIcon=icon;
    emit(changeBottomSheetState());
   }
}