import 'dart:async';

class _LiftErrorStreamSink<S> implements EventSink<S> {
  final EventSink<S> _outputSink;

  _LiftErrorStreamSink(this._outputSink);

  @override
  void add(S data) => _outputSink.add(data);

  @override
  void addError(e, [st]) {
    _outputSink.addError(e, st);
  }

  @override
  void close() => _outputSink.close();
}

class LiftErrorStreamTransformer<S> extends StreamTransformerBase<S, S> {
  LiftErrorStreamTransformer();

  @override
  Stream<S> bind(Stream<S> stream) =>
      Stream.eventTransformed(stream, (sink) => _LiftErrorStreamSink<S>(sink));
}

extension LiftErrorExtension<S> on Stream<S> {
  Stream<S> liftError() => transform(LiftErrorStreamTransformer());
}

void main() {
  Stream.fromIterable([1, 2, 3, 4])
      .map((event) {
        if (event == 4)
          throw Exception("error");
        else
          return event;
      })
      .liftError()
      .listen((event) {
        print("$event");
      });
}
