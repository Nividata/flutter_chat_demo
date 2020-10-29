extension ListExtension on List<Map<String, dynamic>> {
  Map<String, dynamic> asFirebaseMap() {
    Map<String, dynamic> map = Map();
    this.forEach((Map<String, dynamic> element) {
      map[element.keys.first] = element.values.first;
    });

    return map;
  }
}
