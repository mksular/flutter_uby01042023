class TodoFire {
  String? id;
  String? title;
  bool? isComplated;
  bool? isStar;

  TodoFire(
      {this.id, this.title, this.isComplated = false, this.isStar = false});

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
    isComplated = data["isComplated"];
    isStar = data["isStar"];
  }
}
