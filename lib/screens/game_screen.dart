import 'package:flutter/material.dart';
import '../models/dictionary.dart';
import '../models/clue.dart';
import '../widgets/keyboard.dart';

class GameScreen extends StatefulWidget {
  final Dictionary dictionary;

  const GameScreen({super.key, required this.dictionary});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Game state variables
  late String _targetWord;
  late int _wordLength;
  late int _currentDifficulty;

  // List to track guesses
  List<List<CluedLetter>> _guesses = [];
  String _currentGuess = '';
  Map<String, Clue> _letterInfo = {};
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame({int wordLength = 4, int difficulty = 4}) {
    setState(() {
      _wordLength = wordLength;
      _currentDifficulty = difficulty;

      // Pick a random word based on difficulty and length
      _targetWord =
          widget.dictionary
              .getWordsByDifficulty(_currentDifficulty, length: _wordLength)
              .first;

      _guesses = [];
      _currentGuess = '';
      _letterInfo = {};
      _gameOver = false;
    });
  }

  void _onKeyPressed(String key) {
    if (_gameOver) return;

    setState(() {
      if (key == 'Backspace') {
        if (_currentGuess.isNotEmpty) {
          _currentGuess = _currentGuess.substring(0, _currentGuess.length - 1);
        }
      } else if (key == 'Enter') {
        _submitGuess();
      } else if (_currentGuess.length < _wordLength) {
        // Only add the key if it's allowed and we haven't reached word length
        if (LetterChecker.isLetterAllowed(key, _currentDifficulty)) {
          _currentGuess += key.toLowerCase();
        }
      }
    });
  }

  void _submitGuess() {
    if (_currentGuess.length != _wordLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Guess must be $_wordLength letters long')),
      );
      return;
    }

    if (!widget.dictionary.isValidWord(_currentGuess)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Not a valid word')));
      return;
    }

    setState(() {
      final clues = LetterChecker.generateClues(_currentGuess, _targetWord);
      _guesses.add(clues);

      // Update letter information for keyboard
      for (var cluedLetter in clues) {
        String letter = cluedLetter.letter.toLowerCase();
        Clue? existingClue = _letterInfo[letter];

        // Update letter info based on priority: Correct > Elsewhere > Absent
        if (existingClue == null ||
            (cluedLetter.clue != null &&
                _getClueRank(cluedLetter.clue!) > _getClueRank(existingClue))) {
          _letterInfo[letter] = cluedLetter.clue!;
        }
      }

      // Check for win condition
      if (_currentGuess == _targetWord) {
        _gameOver = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Congratulations! You won!')),
        );
      }
      // Check for lose condition
      else if (_guesses.length >= 6) {
        _gameOver = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Game over. The word was $_targetWord')),
        );
      }

      _currentGuess = '';
    });
  }

  // Helper method to rank clues for prioritization
  int _getClueRank(Clue clue) {
    switch (clue) {
      case Clue.correct:
        return 3;
      case Clue.elsewhere:
        return 2;
      case Clue.absent:
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kidzl'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _gameOver ? () => _initializeGame() : null,
          ),
        ],
      ),
      body: Column(
        children: [
          Text('Target word length: $_wordLength'),
          Expanded(
            child: ListView.builder(
              itemCount: _guesses.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      _guesses[index].map((cluedLetter) {
                        return Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.all(2),
                          color: _getColorForClue(cluedLetter.clue),
                          child: Center(
                            child: Text(cluedLetter.letter.toUpperCase()),
                          ),
                        );
                      }).toList(),
                );
              },
            ),
          ),
          Text('Current Guess: ${_currentGuess.toUpperCase()}'),
          GameKeyboard(
            layout: 'qwertyuiop-asdfghjkl-BzxcvbnmE',
            letterInfo: _letterInfo,
            onKeyPressed: _onKeyPressed,
          ),
        ],
      ),
    );
  }

  Color _getColorForClue(Clue? clue) {
    switch (clue) {
      case Clue.correct:
        return Colors.green;
      case Clue.elsewhere:
        return Colors.yellow;
      case Clue.absent:
        return Colors.grey;
      case Clue.notInKeyboardSpec:
        return Colors.black;
      default:
        return Colors.white;
    }
  }
}
