import 'package:flutter/material.dart';
import 'package:numpad/numeric_pad.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get cursorBasePosition => _controller.selection.baseOffset;
  int get cursorExtentPosition => _controller.selection.extentOffset;
  bool get isTextSelected => cursorBasePosition != cursorExtentPosition;
  bool get isCursorAtEnd => cursorBasePosition == _controller.text.length;

  void inputNumber(int value) {
    if (isTextSelected) {
      final text = _controller.text;
      final firstPart = text.substring(0, cursorBasePosition);
      final lastPart = text.substring(cursorExtentPosition);
      _controller.value = _controller.value.copyWith(
        text: firstPart + value.toString() + lastPart,
        selection: TextSelection.collapsed(
          offset: cursorBasePosition + 1,
        ),
      );
    } else if (isCursorAtEnd) {
      _controller.value = _controller.value.copyWith(
        text: _controller.text + value.toString(),
        selection: TextSelection.collapsed(
          offset: _controller.text.length + 1,
        ),
      );
    } else {
      final text = _controller.text;
      final firstPart = text.substring(0, cursorBasePosition);
      final lastPart = text.substring(cursorBasePosition);
      _controller.value = _controller.value.copyWith(
        text: firstPart + value.toString() + lastPart,
        selection: TextSelection.collapsed(
          offset: cursorBasePosition + 1,
        ),
      );
    }
  }

  void clearLastInput() {
    final value = _controller.text;
    if (value.isEmpty) return;
    _controller.value = _controller.value.copyWith(
      text: value.substring(0, value.length - 1),
      selection: TextSelection.collapsed(
        offset: _controller.text.length - 1,
      ),
    );
  }

  void clearAll() {
    if (_controller.text.isEmpty) return;
    _controller.value = _controller.value.copyWith(
      text: '',
      selection: const TextSelection.collapsed(offset: -1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1E33),
      appBar: AppBar(
        title: const Text('Numeric Keypad'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
                child: TextField(
              controller: _controller,
              autofocus: true,
              showCursor: true,
              keyboardType: TextInputType.none,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
              ),
            )),
          ),
          Expanded(
            child: NumericPad(
              onInputNumber: inputNumber,
              onClearLastInput: clearLastInput,
              onClearAll: clearAll,
            ),
          ),
        ],
      ),
    );
  }
}
