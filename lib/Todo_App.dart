import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/todo_cubit/Todo_Cubit.dart';
import 'package:todo/todo_cubit/Todo_States.dart';

class TodoApp extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoCubit>(
      create: (context) => TodoCubit()..createDatabase(),
      child: BlocConsumer<TodoCubit, TodoStates>(
        listener: (context, state) {
          if (state is insertToDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          TodoCubit cubit = TodoCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(title: Text("ToDo App")),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: cubit.titelController.text,
                        date: cubit.dateController.text,
                        time: cubit.timeController.text);
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                          (context) => Container(
                                padding: EdgeInsets.all(20),
                                width: double.infinity,
                                color: Colors.grey[200],
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: cubit.titelController,
                                        style: TextStyle(fontSize: 16),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "Tast Tiltle",
                                            prefixIcon: Icon(Icons.title)),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Tilte Must Not Be Empty";
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        controller: cubit.timeController,
                                        style: TextStyle(fontSize: 16),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "Tast Time",
                                            prefixIcon: Icon(
                                                Icons.watch_later_outlined)),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Time Must Not Be Empty";
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        controller: cubit.dateController,
                                        style: TextStyle(fontSize: 16),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "Tast Date",
                                            prefixIcon:
                                                Icon(Icons.calendar_month)),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Date Must Not Be Empty";
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          elevation: 40)
                      .closed
                      .then((value) {
                    cubit.changeBottomSheet(isShown: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheet(isShown: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.bottomSheetIcon),
            ),
          body: ConditionalBuilder(
            condition: cubit.tasks.length >0,
            builder: (context) {
              return  ListView.separated(itemBuilder: (context, index) =>
              Dismissible(
                key:Key(cubit.tasks[index]['id'].toString()),
                onDismissed: (direction) {
                  cubit.deleteFromDatabase(id: cubit.tasks[index]['id']);
                },
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Text(cubit.tasks[index]['time']
                      ,style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1),
                      radius: 40, 
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cubit.tasks[index]['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),),
                          Text(cubit.tasks[index]['date'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey
                          ),)
                        ],
                      ),
                    ),
                    IconButton(onPressed: () {
                      cubit.deleteFromDatabase(id: cubit.tasks[index]['id']);
                    }, icon: Icon(Icons.check_box_rounded),
                    color: Colors.green[200])
                  ],
                ),
                          ),
              ) ,
             separatorBuilder: (context, index) => Container(
              color: Colors.amber[200],
              height: 2,
              width: double.infinity,
             ),
              itemCount: cubit.tasks.length);
            },
            fallback: (context) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.menu
                    ,color: Colors.grey,size: 70,),
                    Text("No Tasks Yet",style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),)
                  ],
                ),
              );
            },
          
          ),
          );
        },
      ),
    );
  }
}
