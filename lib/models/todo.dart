class Todo {
  int id;
  String title;
  bool? isComplated;
  bool? isStar;

  Todo(
      {required this.id,
      required this.title,
      this.isComplated = false,
      this.isStar = false});

  Map<String, dynamic> toData() {
    Map<String, dynamic> data = {};
    data["id"] = id;
    data["title"] = title;
    data["isComplated"] = isComplated;
    data["isStar"] = isStar;

    return data;
  }

  void fromData(Map<String, dynamic> data) {
    id = data["id"];
    title = data["title"];
    isComplated = data["title"];
    isStar = data["isStar"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["id"] = id;
    data["title"] = title;
    data["isComplated"] = isComplated;
    data["isStar"] = isStar;

    return data;
  }

  void fromJson(Map<String, dynamic> data) {
    id = data["id"];
    title = data["title"];
    isComplated = data["title"];
    isStar = data["isStar"];
  }
}
