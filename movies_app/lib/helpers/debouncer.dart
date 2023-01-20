import 'dart:async';
// Creditos
// https://stackoverflow.com/a/52922130/7834829

class Debouncer<String> {
  Debouncer({required this.duration, this.onValue});

  final Duration duration;

  void Function(String value)? onValue;

  String? _value;
  Timer? _timer;

  String get value => _value!;

  set value(String val) {
    _value = val;
    _timer?.cancel();
    _timer = Timer(duration, () => onValue!(_value!));
  }
}
