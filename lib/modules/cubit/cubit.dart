import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolsit/modules/cubit/states.dart';
import '../archive tasks/archive.dart';
import '../donetasks/donetasks.dart';
import '../tasks/newtasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  List<Widget> screens = [
    newtasks(),
    donetasks(),
    archive(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  int currentIndex = 0;
  late Database database;
  void changeScreen(index) {
    currentIndex = index;
    emit(AppChangeBottomNaviState());
  }

  void createDB() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print("Database created");
        database
            .execute(
                'CREATE TABLE TASKS (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error when created Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDatabase(database);
        print('database opend');
      },
    ).then((value) {
      database = value;
      emit(AppCreaateDBState());
    });
  }

  insertToDb({
    required String? title,
    required String? time,
    required String? date,
  }) async {
    print("im here");
    database.transaction((txn) async {
      await txn
          .rawInsert(
        'INSERT INTO TASKS (title,date,time,status) VALUES("$title","$date","$time","new")',
      )
          .then((value) {
        print("${value} inserted seccessfully");
        emit(AppInsertDBState());
        getDatabase(database);
      }).catchError((error) {
        print("error when insert to table ${error.toString()}");
      });
      return null;
    });
  }

  void getDatabase(database)  {
      newTasks=[];
      doneTasks=[];
      archivedTasks=[];
     database.rawQuery('SELECT * FROM TASKS').then((value) {
       value.forEach((elment){
         if(elment['status']=='new'){
           newTasks.add(elment);
         }else if(elment['status']=='done'){
           doneTasks.add(elment);
         }else{
           archivedTasks.add(elment);
         }
       });
       emit(AppGetDBState());
     });
  }

  void UpdateDate({
    required int id,
    required String status,
    })async
  {
   database.rawUpdate('UPDATE TASKS SET status = ? WHERE id = ?',['$status',id]).then((value){
     emit(AppUpdateDBState());
     getDatabase(database);
   });
  }
  void deleteDate({
    required int id,
  })
  {
    database.rawDelete('DELETE FROM TASKS WHERE id = ?',[id]).then((value){
      emit(AppDeleteDBState());
      getDatabase(database);
    });
  }
  bool isbottomsheetState = false;
  IconData fabIcon = Icons.edit;
  void changeIcon({
    required bool isShow,
    required IconData icon,
  }) {
    isbottomsheetState = isShow;
    fabIcon = icon;
    emit(AppChangeIcon());
  }
}
