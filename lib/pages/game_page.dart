import 'package:flutter/material.dart';
import '../game/snake_game.dart';
import '../widgets/game_area.dart';
import '../ui/app_theme.dart';
import 'game/game_over_overlay.dart';
import 'game/game_controls.dart';




class GamePage extends StatefulWidget {
  final SnakeGame game;
  final VoidCallback onRestart;
  const GamePage({required this.game, required this.onRestart, super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    super.initState();
    widget.game.scoreManager.scoreNotifier.addListener(_onScoreChanged);
    widget.game.scoreManager.bestScoreNotifier.addListener(_onScoreChanged);
  }

  @override
  void dispose() {
    widget.game.scoreManager.scoreNotifier.removeListener(_onScoreChanged);
    widget.game.scoreManager.bestScoreNotifier.removeListener(_onScoreChanged);
    super.dispose();
  }

  void _onScoreChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    final onRestart = widget.onRestart;
    return Scaffold(
      body: Stack(
        children: [
          // Fondo degradado
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF232526), Color(0xFF414345)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Área de juego responsiva
          GameArea(
            game: game,
            overlayBuilderMap: {
              'GameOver': (context, gameInstance) => GameOverOverlay(
                snakeGame: gameInstance as SnakeGame,
                onRestart: onRestart,
              ),
            },
            initialActiveOverlays: const [],
          ),
          // Puntaje flotante y botón de reinicio flotante dentro del área de juego
          Positioned(
            top: 25,
            right: 25,
            child: Material(
              color: AppTheme.overlayGray,
              shape: const CircleBorder(),
              elevation: 8,
              child: IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white, size: 28),
                tooltip: 'Reiniciar',
                onPressed: onRestart,
                splashRadius: 28,
              ),
            ),
          ),
          Positioned(
            top: 25,
            left: 25,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.yellow, size: 28),
                  const SizedBox(width: 8),
                  ValueListenableBuilder<int>(
                    valueListenable: game.scoreManager.scoreNotifier,
                    builder: (context, value, _) {
                      return Text(
                        '$value',
                        style: const TextStyle(
                          fontFamily: 'Bit32',
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  ValueListenableBuilder<int>(
                    valueListenable: game.scoreManager.bestScoreNotifier,
                    builder: (context, best, _) {
                      return Text(
                        'Mejor: $best',
                        style: const TextStyle(
                          fontFamily: 'Bit32',
                          fontSize: 16,
                          color: AppTheme.overlayGray,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Controles responsivos SIEMPRE visibles abajo
          Align(
            alignment: Alignment.bottomLeft,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8),
                child: GameControls(game: game),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
