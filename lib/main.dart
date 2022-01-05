import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'homelayout.dart';
import 'package:sqflite/sqflite.dart';

import 'shared/bloc abserver.dart';

void main (){
  Bloc.observer = MyBlocObserver();
  runApp(Database());}

class Database extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeLeyout() ,
    );
  }
}



