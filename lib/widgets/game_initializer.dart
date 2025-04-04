import 'package:flutter/material.dart';
import '../models/dictionary.dart';
import '../screens/game_screen.dart';

class GameInitializerWidget extends StatefulWidget {
  const GameInitializerWidget({super.key});

  @override
  State<GameInitializerWidget> createState() => _GameInitializerWidgetState();
}

class _GameInitializerWidgetState extends State<GameInitializerWidget> {
  Dictionary? _dictionary;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDictionary();
  }

  Future<void> _loadDictionary() async {
    try {
      final dictionary = await DictionaryLoader.loadJollyPhonics();
      setState(() {
        _dictionary = dictionary;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load dictionary: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    // Add a null check before creating GameScreen
    if (_dictionary == null) {
      return const Scaffold(
        body: Center(child: Text('Dictionary could not be loaded')),
      );
    }

    return GameScreen(dictionary: _dictionary!);
  }
}
