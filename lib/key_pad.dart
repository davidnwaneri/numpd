import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyPad extends StatelessWidget {
  const KeyPad({
    super.key,
    required this.number,
    required this.onKeyPress,
  });

  final int number;
  final VoidCallback onKeyPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFF1F4FE),
          shape: const CircleBorder(),
        ),
        onPressed: () {
          onKeyPress();
          HapticFeedback.lightImpact();
        },
        child: Text('$number'),
      ),
    );
  }
}
