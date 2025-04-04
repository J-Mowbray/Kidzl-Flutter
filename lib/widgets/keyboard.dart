import 'package:flutter/material.dart';
import '../models/clue.dart';

class GameKeyboard extends StatelessWidget {
  final String layout;
  final Map<String, Clue> letterInfo;
  final Function(String) onKeyPressed;

  const GameKeyboard({
    super.key,
    this.layout = 'qwertyuiop-asdfghjkl-BzxcvbnmE',
    required this.letterInfo,
    required this.onKeyPressed,
  });

  // Parse the keyboard layout into rows
  List<List<String>> _parseLayout() {
    return layout
        .split('-')
        .map(
          (row) =>
              row
                  .split('')
                  .map(
                    (key) => key
                        .replaceAll('B', 'Backspace')
                        .replaceAll('E', 'Enter'),
                  )
                  .toList(),
        )
        .toList();
  }

  // Determine the color for a key based on its clue
  Color _getKeyColor(String key, BuildContext context) {
    // Special handling for control keys
    if (key == 'Backspace' || key == 'Enter') {
      return Theme.of(context).primaryColorLight;
    }

    // Normalize the key (remove special characters)
    String normalizedKey = key.toLowerCase();

    // Check if the letter is in letterInfo
    Clue? clue = letterInfo[normalizedKey];

    switch (clue) {
      case Clue.correct:
        return Colors.green;
      case Clue.elsewhere:
        return Colors.yellow;
      case Clue.absent:
        return Colors.grey;
      case Clue.notInKeyboardSpec:
        return Colors.black;
      case Clue.none:
      default:
        return Theme.of(context).primaryColorLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardRows = _parseLayout();

    return Column(
      children:
          keyboardRows.map((row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  row.map((key) {
                    // Determine if the key is wide (Backspace or Enter)
                    bool isWideKey = key == 'Backspace' || key == 'Enter';

                    return Expanded(
                      flex: isWideKey ? 2 : 1,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getKeyColor(key, context),
                            padding: EdgeInsets.symmetric(
                              horizontal: isWideKey ? 20 : 8,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () => onKeyPressed(key),
                          child: Text(
                            key == 'Backspace'
                                ? '⌫'
                                : key == 'Enter'
                                ? '↵'
                                : key.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isWideKey ? 14 : 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            );
          }).toList(),
    );
  }
}
