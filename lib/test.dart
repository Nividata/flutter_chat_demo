import 'package:flutter_chat_demo/utility/mergeAll.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  Stream.fromIterable([])
      .map((event) => event * 2)
  .defaultIfEmpty(2)
      .listen(print, onDone: () {
    print("ok");
  });
}
