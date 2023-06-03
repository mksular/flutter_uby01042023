import 'package:flutter/material.dart';
import 'package:myapp/models/todo.dart';
import 'package:myapp/screens/tododetail.dart';
import 'package:myapp/utils/myappbar.dart';
import 'package:myapp/utils/mydrawer.dart';
import 'package:mysql1/mysql1.dart';

class TodoListMysql extends StatefulWidget {
  const TodoListMysql({super.key});

  @override
  State<TodoListMysql> createState() => _TodoListMysqlState();
}

class _TodoListMysqlState extends State<TodoListMysql> {
  List<Todo> todoListMysql = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  late String title;
  String keyword = "";

  late final MySqlConnection conn;
  late Todo todo;
  bool isObsecure = false;
  bool isLoading = false;
  bool isEdit = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          isEdit ? updateTodoMysql(todo) : addTodo();
        },
        child: Icon(isEdit ? Icons.save : Icons.add),
      ),
      drawer: const MyDrawer(),
      appBar:
          const MyAppBar() /* AppBar(
          title: TextFormField(
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
          setState(() {
            keyword = newValue;
            getData();
          });
        },
      )) */
      ,
      body: Stack(children: [
        isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                  semanticsLabel: "yükleniyor...",
                ),
              )
            : const SizedBox(),
        Column(children: [
          Expanded(
              flex: 1,
              child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  color: Colors.yellow[200],
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: titleController,
                      obscureText: isObsecure,
                      decoration: InputDecoration(
                          labelText: "Başlık",
                          suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  isObsecure = !isObsecure;
                                });
                              },
                              child: Icon(isObsecure
                                  ? Icons.visibility_off
                                  : Icons.visibility))),
                      keyboardType: TextInputType.text,
                      onSaved: (newValue) {
                        setState(() {
                          title = newValue!;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Boş geçilemez";
                        }
                        return null;
                      },
                      autovalidateMode: autoValidateMode,
                    ),
                  ))),
          Expanded(
              flex: 5,
              child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 100),
                  alignment: Alignment.topLeft,
                  child: todoListMysql.isEmpty
                      ? const Center(
                          child: Text("Kayıt bulunamadı"),
                        )
                      : ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                                height: 2,
                                color: Colors.white,
                              ),
                          itemCount: todoListMysql.length,
                          itemBuilder: (BuildContext context, int index) {
                            var element = todoListMysql[index];
                            return ListTile(
                              tileColor: element.isComplated!
                                  ? Colors.red[200]
                                  : Colors.green[200],
                              leading: Checkbox(
                                onChanged: (newValue) {
                                  setState(() {
                                    element.isComplated = !element.isComplated!;
                                  });
                                  updateIsComplatedMysql(element);
                                },
                                value: element.isComplated,
                              ),
                              title: Text(
                                element.title,
                                style: TextStyle(
                                    decoration: element.isComplated!
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        updateTodo(element);
                                      },
                                      child: const Icon(
                                        Icons.edit,
                                      )),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          element.isStar = !element.isStar!;
                                        });
                                        updateIsStarMysql(element);
                                      },
                                      child: Icon(
                                        Icons.star,
                                        color: element.isStar!
                                            ? Colors.amber
                                            : Colors.black45,
                                      )),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          todoListMysql.remove(element);
                                        });
                                        deleteTodoMysql(element);
                                      },
                                      child: const Icon(Icons.delete)),
                                  InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TodoDetail(
                                                      todo: element,
                                                    )));
                                      },
                                      child: const Icon(
                                        Icons.more_vert,
                                      )),
                                ],
                              ),
                            );
                          }))),
        ])
      ]),
    );
  }

  /*  void createList() {
    for (var i = 0; i < 100; i++) {
      Todo todo = Todo(
          id: todoListMysql.isEmpty ? 1 : todoListMysql.last.id + 1,
          title: "Başlık ${todoListMysql.isEmpty ? 1 : todoListMysql.last.id + 1}");

      setState(() {
        todoListMysql.add(todo);
      });
    }
    debugPrint(todoListMysql.toString());
  } */

  Future successAlert(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Icon(
                  Icons.check,
                  size: 120,
                  color: Colors.green,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Kapat'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
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

    //debugPrint("veritabanına bağlandı!");
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

    //debugPrint(results.toString());
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
  }

  Future addTodo() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        isLoading = true;
        titleController.text = "";
      });
      await conn.query(
          'insert into todo(title, iscomplated, isstar) values(?,?,?)',
          [title, 0, 0]).then((value) {
        setState(() {
          isLoading = false;
        });
      }).catchError((onError) {
        debugPrint(onError.toString());
      });

      successAlert("Tebrikler");
      formKey.currentState!.reset();
      getData();
    } else {
      setState(() {
        autoValidateMode = AutovalidateMode.always;
      });
    }
  }

  Future updateIsComplatedMysql(Todo element) async {
    setState(() {
      isLoading = true;
    });
    await conn.query('update todo set iscomplated=? where id=?',
        [element.isComplated, element.id]).then((value) {
      setState(() {
        isLoading = false;
      });
    }).catchError((onError) {
      debugPrint(onError);
    });
  }

  Future updateIsStarMysql(Todo element) async {
    setState(() {
      isLoading = true;
    });
    await conn.query('update todo set isstar=? where id=?',
        [element.isStar, element.id]).then((value) {
      setState(() {
        isLoading = false;
      });
    }).catchError((onError) {
      debugPrint(onError);
    });
  }

  void updateTodo(Todo element) {
    setState(() {
      titleController.text = element.title;
      isEdit = true;
      todo = element;
    });
  }

  Future updateTodoMysql(Todo element) async {
    setState(() {
      isLoading = true;
    });
    await conn.query('update todo set title=? where id=?',
        [titleController.text, element.id]).then((value) {
      setState(() {
        isLoading = false;
        isEdit = false;
        titleController.text = "";
      });
      successAlert("Kayıt Güncellendi!");
      getData();
    }).catchError((onError) {
      debugPrint(onError);
    });
  }

  Future deleteTodoMysql(Todo element) async {
    setState(() {
      isLoading = true;
    });
    await conn.query('delete from todo where id=?', [element.id]).then((value) {
      setState(() {
        isLoading = false;
      });
    }).catchError((onError) {
      debugPrint(onError);
    });
  }
}
