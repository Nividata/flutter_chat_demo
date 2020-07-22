import 'package:flutter_chat_demo/utility/mergeAll.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  MergeAllStream([
    Stream.periodic(Duration(seconds: 1))
        .flatMap((value) => Stream.fromIterable([4, 5])),
    Stream.fromIterable([2, 1])
  ]).listen(print);
}
