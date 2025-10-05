import 'package:flutter/material.dart';
import '../game/snake_game.dart';
import '../widgets/game_area.dart';
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
          // Puntaje y botón de reinicio
          SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.yellow, width: 3),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 32),
                        const SizedBox(width: 12),
                        ValueListenableBuilder<int>(
                          valueListenable: game.scoreManager.scoreNotifier,
                          builder: (context, value, _) {
                            return Text(
                              '$value',
                              style: const TextStyle(
                                fontFamily: 'Bit32',
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 24),
                        ValueListenableBuilder<int>(
                          valueListenable: game.scoreManager.bestScoreNotifier,
                          builder: (context, best, _) {
                            return Text(
                              'Mejor: $best',
                              style: const TextStyle(
                                fontFamily: 'Bit32',
                                fontSize: 20,
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 16, right: 24),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: onRestart,
                      child: const Text('Reiniciar', style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ),
                ),
              ],
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
