import 'package:flutter/material.dart';
import 'package:myapp/models/state.dart';
import 'package:myapp/models/todo.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

class SearchTodo extends StatefulWidget {
  const SearchTodo({super.key});

  @override
  State<SearchTodo> createState() => _SearchTodoState();
}

class _SearchTodoState extends State<SearchTodo> {
  String keyword = "";
  TextEditingController searchController = TextEditingController();
  List<Todo> todoListMysql = [];
  late final MySqlConnection conn;
  late StateModel state;
  bool isLoading = false;

  @override
  void initState() {
    state = Provider.of<StateModel>(context, listen: false);
    mysqlConn();
    super.initState();
  }

  @override
  void dispose() {
    conn.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: searchController,
      decoration: const InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          labelText: "Todo Ara",
          suffixIcon: InkWell(
              child: Icon(
            Icons.search,
            color: Colors.white,
          ))),
      keyboardType: TextInputType.text,
      onChanged: (newValue) {
        keyword = newValue;
        getData();
      },
    );
  }

  Future mysqlConn() async {
    conn = await MySqlConnection.connect(ConnectionSettings(
        host: '93.89.225.127',
        port: 3306,
        user: 'ideftp1_testus',
        db: 'ideftp1_testdb',
        password: '123456aA+-'));
    getData();
  }

  Future getData() async {
    setState(() {
      isLoading = true;
    });
    todoListMysql.clear();
    Results results;
    if (keyword != "") {
      results = await conn
          .query('select * from todo where title like ?', ['%$keyword%']);
    } else {
      results = await conn.query('select * from todo');
    }

    results.map((e) {
      Todo todo = Todo(
          id: e["id"],
          title: e["title"],
          isComplated: e["iscomplated"] == 1 ? true : false,
          isStar: e["isstar"] == 1 ? true : false);
      setState(() {
        todoListMysql.add(todo);
      });
    }).toList();
    setState(() {
      isLoading = false;
    });

    debugPrint(todoListMysql.toString());
    state.setTodoListMysql(todoListMysql);
  }
}
