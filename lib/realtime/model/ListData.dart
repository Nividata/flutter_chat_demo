
class ListData {
  String id;
  Map<dynamic, dynamic> data;

  ListData(String id, Map<dynamic, dynamic> data) {
    this.id = id;
    this.data = data;
  }

  Object get(String key) {
    if (data != null) {
      return data[key];
    }
    return null;
  }

  String getId() {
    return id;
  }

  Map<String, Object> getData() {
    return data;
  }
}
