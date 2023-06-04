import 'package:flutter/material.dart';
import 'package:myapp/models/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/todofire.dart';
import 'package:provider/provider.dart';

class SearchTodoFirestore extends StatefulWidget {
  const SearchTodoFirestore({super.key});

  @override
  State<SearchTodoFirestore> createState() => _SearchTodoFirestoreState();
}

class _SearchTodoFirestoreState extends State<SearchTodoFirestore> {
  String keyword = "";
  TextEditingController searchController = TextEditingController();
  List<TodoFire> todoListFirestore = [];
  late StateModel state;
  bool isLoading = false;
  var colRef = FirebaseFirestore.instance.collection("todo");

  @override
  void initState() {
    getData();
    state = Provider.of<StateModel>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: searchController,
      decoration: const InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          labelText: "Firestore Todo Ara",
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

  Future getData() async {
    setState(() {
      isLoading = true;
    });
    todoListFirestore.clear();

    colRef.get().then(
      (value) {
        value.docs.map((doc) {
          var data = doc.data();
          var id = doc.id;
          TodoFire todo = TodoFire();
          todo.fromJson(data);
          todoListFirestore.add(todo);
        }).toList();

        state.setTodoListFirestore(todoListFirestore);
      },
    ).catchError((onError) {
      debugPrint("hata : $onError");
    });

    setState(() {
      isLoading = false;
    });
  }
}
