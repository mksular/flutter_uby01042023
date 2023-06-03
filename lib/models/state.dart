import 'package:flutter/material.dart';
import 'package:myapp/models/todo.dart';

class StateModel extends ChangeNotifier {
  int currentIndex = 0;
  String routeName = "/";
  List<Todo> todoListMysql = [];
  List<Todo> todoListFirestore = [];

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

  void setTodoListFirestore(List<Todo> list) {
    todoListFirestore = list;

    notifyListeners();
  }
}
