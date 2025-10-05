import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/menu_page.dart';
import 'pages/game_page.dart';
import 'game/snake_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const SnakeApp());
  });
}

class SnakeApp extends StatefulWidget {
  const SnakeApp({super.key});

  @override
  State<SnakeApp> createState() => _SnakeAppState();
}

class _SnakeAppState extends State<SnakeApp> {
  bool started = false;
  late SnakeGame _game;

  @override
  void initState() {
    super.initState();
    _game = SnakeGame();
    _game.onGameOverCallback = _onGameOver;
  }

  void _startGame() {
    setState(() {
      started = true;
      _game.overlays.remove('GameOver');
      _game.reset();
    });
  }

  void _onGameOver() {

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: started
          ? GamePage(game: _game, onRestart: _startGame)
          : MenuPage(onStart: _startGame),
    );
  }
}

