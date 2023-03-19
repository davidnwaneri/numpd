import 'package:flutter/material.dart';

class ClearButton extends StatelessWidget {
  const ClearButton({
    super.key,
    required this.onClearLastInput,
    required this.onClearAll,
  });

  final VoidCallback onClearLastInput;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onClearAll,
      child: IconButton(
        onPressed: onClearLastInput,
        icon: const Icon(
          Icons.backspace,
          color: Color(0xFFF1F4FE),
        ),
      ),
    );
  }
}
