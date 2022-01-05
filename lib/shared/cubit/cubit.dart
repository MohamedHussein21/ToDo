import 'package:bloc/bloc.dart';
import 'package:database/module/archive.dart';
import 'package:database/module/done.dart';
import 'package:database/module/tasks.dart';
import 'package:database/shared/cubit/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  List<Widget> screen = [
    NewTaskes(),
    NewArchive(),
    NewDone(),
  ];
  List<String> titles = [
    'Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  int current = 0;

  void changeIndex(int index) {
    current = index;
    emit(AppChangeBottonNavBarState());
  }

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  late Database database;
  bool isButtonsheetOpen = false;
  IconData fabIcon = Icons.edit;

  void creatDataBase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        print('sucssesed creating');
        await database
            .execute(
                'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, data TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDataBase(database);
        this.database = database;
        print('sucssesed open');
      },
    ).then((value) {
      database = value;
      emit(AppCreatDataBaseState());
    });
  }

  insertDataBase({
    @required String? title,
    @required String? time,
    @required String? data,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO Tasks(title , data,time,status) VALUES("$title", "$data", "$time","new")')
          .then((value) {
        print("$value inserted successfully");
        emit(AppInsertDataBaseState());
        getDataFromDataBase(database);
      }).catchError((error) {
        print("${error.toString()}");
      });
      return null;
    });
  }

  void getDataFromDataBase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'Done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });

      emit(AppGetDataBaseState());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDataBase(database);
      emit(AppUpdateDataBaseState());
    });
  }
  void deleteData({
    required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?',
        [ id]).then((value) {
      getDataFromDataBase(database);
      emit(AppDeleteDataBaseState());
    });
  }


  void changeBottonSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isButtonsheetOpen = isShow;
    fabIcon = icon;

    emit(AppChangBottonSheet());
  }
}
