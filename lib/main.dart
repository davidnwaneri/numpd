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
      home: const CustomNumPadScreen(),
    );
  }
}

class CustomNumPadScreen extends StatefulWidget {
  const CustomNumPadScreen({super.key});

  @override
  State<CustomNumPadScreen> createState() => _CustomNumPadScreenState();
}

class _CustomNumPadScreenState extends State<CustomNumPadScreen> {
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
  bool get isCursorBetweenText => !isTextSelected && !isCursorAtEnd;

  void inputNumber(int value) {
    if (isTextSelected) {
      _replaceTextSelection(value);
      return;
    }
    if (isCursorAtEnd) {
      _inputNumberAtEnd(value);
      return;
    }
    if (isCursorBetweenText) {
      _inputNumberBetweenText(value);
      return;
    }
  }

  void _replaceTextSelection(int value) {
    final currentNumbers = _controller.text;
    final numbersBeforeSelection =
        currentNumbers.substring(0, cursorStartPosition);
    final numbersAfterSelection = currentNumbers.substring(cursorEndPosition);
    _controller.value = _controller.value.copyWith(
      // Set the new text, ignoring the selected text.
      text: numbersBeforeSelection + value.toString() + numbersAfterSelection,
      selection: TextSelection.collapsed(
        offset: cursorStartPosition + 1,
      ),
    );
  }

  void _inputNumberBetweenText(int value) {
    final currentNumbers = _controller.text;
    final numbersBeforeCursor =
        currentNumbers.substring(0, cursorStartPosition);
    final numbersAfterCursor = currentNumbers.substring(cursorStartPosition);
    _controller.value = _controller.value.copyWith(
      text: numbersBeforeCursor + value.toString() + numbersAfterCursor,
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
    if (_controller.text.isEmpty) return;
    if (isTextSelected) {
      _clearTextSelection();
      return;
    }
    if (isCursorAtEnd) {
      _clearNumberAtEnd();
      return;
    }
    if (isCursorBetweenText) {
      _clearNumberBetweenText();
      return;
    }
  }

  void _clearTextSelection() {
    final currentNumbers = _controller.text;
    final textBeforeSelection =
        currentNumbers.substring(0, cursorStartPosition);
    final textAfterSelection = currentNumbers.substring(cursorEndPosition);
    _controller.value = _controller.value.copyWith(
      text: textBeforeSelection + textAfterSelection,
      selection: TextSelection.collapsed(
        offset: cursorStartPosition,
      ),
    );
  }

  void _clearNumberBetweenText() {
    final currentNumbers = _controller.text;
    final numbersBeforeCursor =
        currentNumbers.substring(0, cursorStartPosition);
    final numbersAfterCursor = currentNumbers.substring(cursorStartPosition);
    _controller.value = _controller.value.copyWith(
      text: numbersBeforeCursor.substring(0, numbersBeforeCursor.length - 1) +
          numbersAfterCursor,
      selection: TextSelection.collapsed(
        offset: cursorStartPosition - 1,
      ),
    );
  }

  void _clearNumberAtEnd() {
    final currentNumbers = _controller.text;
    _controller.value = _controller.value.copyWith(
      text: currentNumbers.substring(0, currentNumbers.length - 1),
      selection: TextSelection.collapsed(
        offset: currentNumbers.length - 1,
      ),
    );
  }

  void clearAllInput() {
    if (_controller.text.isEmpty) return;
    if (isCursorAtEnd) {
      _clearAll();
      return;
    }
    if (isCursorBetweenText) {
      _clearAllBeforeCursor();
      return;
    }
  }

  void _clearAll() {
    _controller.value = _controller.value.copyWith(
      text: '',
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  void _clearAllBeforeCursor() {
    _controller.value = _controller.value.copyWith(
      text: _controller.text.substring(cursorStartPosition),
      selection: const TextSelection.collapsed(offset: 0),
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
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _controller,
                autofocus: true,
                showCursor: true,
                // keyboardType: TextInputType.none,
                readOnly: true,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            )),
          ),
          Expanded(
            flex: 2,
            child: NumericPad(
              onInputNumber: inputNumber,
              onClearLastInput: clearLastInput,
              onClearAll: clearAllInput,
            ),
          ),
        ],
      ),
    );
  }
}
