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

  int get cursorStartPosition => _controller.selection.baseOffset;
  int get cursorEndPosition => _controller.selection.extentOffset;
  bool get isTextSelected => cursorStartPosition != cursorEndPosition;
  bool get isCursorAtEnd => cursorStartPosition == _controller.text.length;

  void inputNumber(int value) {
    if (isTextSelected) {
      _replaceTextSelection(value);
    } else if (isCursorAtEnd) {
      _inputNumberAtEnd(value);
    } else {
      _inputNumberBetweenText(value);
    }
  }

  void _replaceTextSelection(int value) {
    final text = _controller.text;
    final firstPart = text.substring(0, cursorStartPosition);
    final lastPart = text.substring(cursorEndPosition);
    _controller.value = _controller.value.copyWith(
      text: firstPart + value.toString() + lastPart,
      selection: TextSelection.collapsed(
        offset: cursorStartPosition + 1,
      ),
    );
  }

  void _inputNumberBetweenText(int value) {
    final text = _controller.text;
    final firstPart = text.substring(0, cursorStartPosition);
    final lastPart = text.substring(cursorStartPosition);
    _controller.value = _controller.value.copyWith(
      text: firstPart + value.toString() + lastPart,
      selection: TextSelection.collapsed(
        offset: cursorStartPosition + 1,
      ),
    );
  }

  void _inputNumberAtEnd(int value) {
    _controller.value = _controller.value.copyWith(
      text: _controller.text + value.toString(),
      selection: TextSelection.collapsed(
        offset: _controller.text.length + 1,
      ),
    );
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
