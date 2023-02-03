import 'package:flutter/material.dart';

class NumericKeyNotifier extends ValueNotifier<String> {
  NumericKeyNotifier() : super('');

  void inputNumber(int number) {
    value = number.toString();
    notifyListeners();
  }
}

class NumericPadNotifier extends InheritedNotifier<NumericKeyNotifier> {
  const NumericPadNotifier({
    super.key,
    required super.child,
  });

  static NumericKeyNotifier of(BuildContext context) {
    final notifier = context
        .dependOnInheritedWidgetOfExactType<NumericPadNotifier>()!
        .notifier!;
    return notifier;
  }

  void inputNumber(int number) {
    // value = number.toString();
    // notifyListeners();
  }
}
