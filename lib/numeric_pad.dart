import 'package:flutter/material.dart';
import 'package:numpad/clear_button.dart';
import 'package:numpad/key_pad.dart';

class NumericPad extends StatelessWidget {
  const NumericPad({
    super.key,
    required this.onInputNumber,
    required this.onClearLastInput,
    required this.onClearAll,
  });

  final ValueSetter<int> onInputNumber;
  final VoidCallback onClearLastInput;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white10,
      child: Column(
        children: [
          for (int i = 1; i < 4; i++)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int j = 1; j < 4; j++)
                    Expanded(
                      child: KeyPad(
                        number: (i - 1) * 3 + j,
                        onKeyPress: () => onInputNumber((i - 1) * 3 + j),
                      ),
                    ),
                ],
              ),
            ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Expanded(
                    child: KeyPad(
                  number: 0,
                  onKeyPress: () => onInputNumber(0),
                )),
                Expanded(
                  child: ClearButton(
                    onClearLastInput: onClearLastInput,
                    onClearAll: onClearAll,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
