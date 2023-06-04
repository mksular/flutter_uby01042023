import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/todo.dart';
import 'package:myapp/models/todofire.dart';

class StateModel extends ChangeNotifier {
  int currentIndex = 0;
  String routeName = "/";
  List<Todo> todoListMysql = [];
  List<TodoFire> todoListFirestore = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> todoListFirestoreDirect =
      [];

  void setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void setRouteName(String value) {
    routeName = value;
    notifyListeners();
  }

  void setTodoListMysql(List<Todo> list) {
    todoListMysql = list;

    notifyListeners();
  }

  void setTodoListFirestore(List<TodoFire> list) {
    todoListFirestore = list;

    notifyListeners();
  }
}
