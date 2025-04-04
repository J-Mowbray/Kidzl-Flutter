import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

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

  // Updated method for difficulty-based filtering
  List<String> getWordsByDifficulty(int difficultyLevel, {int? length}) {
    final List<int> availableTargets = [
      3, // SATPIN
      4, // SATPIN+tricky
      5, // SATPINCKEHRMD
      6, // SATPINCKEHRMD+tricky
      7, // SATPINCKEHRMDGOULFB
      8, // SATPINCKEHRMDGOULFB+tricky
      9, // Full word list
    ];

    // Ensure difficulty is within bounds
    final clampedDifficulty = difficultyLevel.clamp(
      0,
      availableTargets.length - 1,
    );

    // Filter words based on difficulty level
    final filteredWords =
        words
            .where((word) => word.length <= availableTargets[clampedDifficulty])
            .toList();

    // If length is specified, further filter by length
    if (length != null) {
      return filteredWords.where((word) => word.length == length).toList();
    }

    return filteredWords;
  }

  // Get the total number of words
  int get wordCount => words.length;
}

// Updated Loader for the dictionary
class DictionaryLoader {
  // Load words from JSON asset asynchronously
  static Future<Dictionary> loadJollyPhonics() async {
    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString(
        'assets/jollyPhonics.json',
      );

      // Decode the JSON to a list of strings
      final List<dynamic> wordList = json.decode(jsonString);

      // Convert to a list of strings and create Dictionary
      final words = wordList.map((word) => word.toString()).toList();

      return Dictionary(words);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading dictionary: $e');
      }
      // Fallback to an empty dictionary if loading fails
      return Dictionary([]);
    }
  }
}
