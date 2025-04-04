import 'dart:math';

class Dictionary {
  // The full list of words
  final List<String> words;

  // Sets for efficient lookups
  late final Set<String> _wordSet;
  late final Map<int, List<String>> _wordsByLength;

  Dictionary(this.words) {
    // Create a set for fast containment checks
    _wordSet = Set.from(words);

    // Group words by length for easier filtering
    _wordsByLength = _groupWordsByLength();
  }

  // Private method to group words by their length
  Map<int, List<String>> _groupWordsByLength() {
    final grouped = <int, List<String>>{};
    for (final word in words) {
      grouped.putIfAbsent(word.length, () => []).add(word);
    }
    return grouped;
  }

  // Check if a word is valid
  bool isValidWord(String word) {
    return _wordSet.contains(word.toLowerCase());
  }

  // Get words of a specific length
  List<String> getWordsOfLength(int length) {
    return _wordsByLength[length] ?? [];
  }

  // Pick a random word of a specific length
  String pickRandomWord(int length, {Random? random}) {
    final wordsOfLength = getWordsOfLength(length);

    if (wordsOfLength.isEmpty) {
      throw ArgumentError('No words of length $length found');
    }

    // Use provided random or create a new one
    final rng = random ?? Random();
    return wordsOfLength[rng.nextInt(wordsOfLength.length)];
  }

  // Filter words based on difficulty levels
  List<String> getWordsByDifficulty(int difficultyLevel, {int? length}) {
    // This method would needs to be implemented based on specific difficulty criteria
    // For now, it just returns words of the specified length or all words
    if (length != null) {
      return getWordsOfLength(length);
    }
    return words;
  }

  // Get the total number of words
  int get wordCount => words.length;
}

// Loader for the dictionary
class DictionaryLoader {
  // This is a placeholder. we'll want to load the words from a JSON asset
  static Dictionary loadJollyPhonics() {
    final words = [
      'sat', 'at', 'sit', 'it', 'its', 'pat', 'tap',
      // ... add more words from the original jollyPhonics.json
    ];
    return Dictionary(words);
  }
}
