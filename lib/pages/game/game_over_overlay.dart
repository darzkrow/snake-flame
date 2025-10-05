import 'package:flutter/material.dart';
import '../../game/snake_game.dart';

class GameOverOverlay extends StatelessWidget {
  final SnakeGame snakeGame;
  final VoidCallback onRestart;
  const GameOverOverlay({required this.snakeGame, required this.onRestart, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth < 400 ? constraints.maxWidth * 0.98 : 400.0;
        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              minWidth: 220,
            ),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade900, Colors.black, Colors.deepPurple.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.amber, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.7),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.sentiment_very_dissatisfied, color: Colors.redAccent, size: 60),
                  const SizedBox(height: 12),
                  const Text(
                    '¡Game Over!',
                    style: TextStyle(
                      fontFamily: 'Bit32',
                      fontSize: 48,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ValueListenableBuilder<int>(
                    valueListenable: snakeGame.scoreManager.scoreNotifier,
                    builder: (context, score, _) => Column(
                      children: [
                        Text(
                          'Puntaje',
                          style: TextStyle(
                            fontFamily: 'Bit32',
                            fontSize: 22,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$score',
                          style: const TextStyle(
                            fontFamily: 'Bit32',
                            fontSize: 40,
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<int>(
                    valueListenable: snakeGame.scoreManager.bestScoreNotifier,
                    builder: (context, best, _) => Column(
                      children: [
                        Text(
                          'Mejor Puntaje',
                          style: TextStyle(
                            fontFamily: 'Bit32',
                            fontSize: 18,
                            color: Colors.amber.shade200,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$best',
                          style: const TextStyle(
                            fontFamily: 'Bit32',
                            fontSize: 28,
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    '¡Intenta superar tu mejor puntaje!',
                    style: TextStyle(
                      fontFamily: 'Bit32',
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 36),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 8,
                    ),
                    onPressed: onRestart,
                    icon: const Icon(Icons.refresh, color: Colors.white, size: 32),
                    label: const Text('Jugar de nuevo', style: TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'Bit32', fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
