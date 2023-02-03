import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numpad/main.dart';

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
    return OutlinedButton(
      onPressed: (){
        onKeyPress();
        HapticFeedback.lightImpact();
      },
      child: Text('$number'),
    );
  }
}
