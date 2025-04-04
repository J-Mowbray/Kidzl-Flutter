// Enum representing different clue states for letters
enum Clue {
  absent, // Letter is not in the word
  elsewhere, // Letter is in the word but in the wrong position
  correct, // Letter is in the correct position
  notInKeyboardSpec, // Letter is not allowed in the current keyboard specification
  none, // No clue assigned
}

// Class to represent a letter with its associated clue
class CluedLetter {
  final String letter;
  final Clue? clue;

  const CluedLetter({required this.letter, this.clue = Clue.none});

  // Method to get the clue word description
  String get clueWord {
    switch (clue) {
      case Clue.absent:
        return 'no';
      case Clue.elsewhere:
        return 'elsewhere';
      case Clue.correct:
        return 'correct';
      case Clue.notInKeyboardSpec:
        return 'not in keyboard';
      case Clue.none:
      default:
        return '';
    }
  }

  // Method to get the CSS-like class name for styling
  String get clueClass {
    switch (clue) {
      case Clue.absent:
        return 'letter-absent';
      case Clue.elsewhere:
        return 'letter-elsewhere';
      case Clue.correct:
        return 'letter-correct';
      case Clue.notInKeyboardSpec:
        return 'letter-notinkeyboardspec';
      case Clue.none:
      default:
        return '';
    }
  }

  // Method to describe the clue in a readable format
  String describe() {
    return '${letter.toUpperCase()} $clueWord';
  }
}

// Utility function to check if a letter is allowed based on difficulty
class LetterChecker {
  static final List<String> whitelistedLettersByDifficulty = [
    "satpin *%",
    "satpin *%",
    "satpinckehrmd *%",
    "satpinckehrmd *%",
    "satpinckehrmdgoulfbn *%",
    "satpinckehrmdgoulfbn *%",
    "satpinckehrmdgoulfbnjzwv *%",
    "satpinckehrmdgoulfbnjzwv *%",
    // ... (continue the pattern from the original implementation)
  ];

  static bool isLetterAllowed(String letter, int currentDifficultyJP) {
    // Ensure the difficulty is within bounds
    final clampedDifficulty = currentDifficultyJP.clamp(
      1,
      whitelistedLettersByDifficulty.length,
    );

    return whitelistedLettersByDifficulty[clampedDifficulty - 1].contains(
      letter.toLowerCase(),
    );
  }

  // Method to generate clues for a guess compared to a target word
  static List<CluedLetter> generateClues(String guess, String target) {
    // Create a list to track letters that are not yet matched
    List<String> elusive = target.split('').toList();

    return guess.split('').map((letter) {
      final index = guess.indexOf(letter);

      // Check if the letter is in the correct position
      if (target[index] == letter) {
        elusive.remove(letter);
        return CluedLetter(letter: letter, clue: Clue.correct);
      }

      // Check if the letter is elsewhere in the word
      final elusiveIndex = elusive.indexOf(letter);
      if (elusiveIndex != -1) {
        elusive.removeAt(elusiveIndex);
        return CluedLetter(letter: letter, clue: Clue.elsewhere);
      }

      // Check if the letter is not in the keyboard specification
      // Note: This would require passing the current difficulty
      // return CluedLetter(letter: letter, clue: Clue.notInKeyboardSpec);

      // If none of the above, the letter is absent
      return CluedLetter(letter: letter, clue: Clue.absent);
    }).toList();
  }
}
