import 'package:flutter/material.dart';
import '../game/snake_game.dart';
import '../game/logic/snake_logic.dart';
import '../widgets/arrow_button.dart';
// import '../widgets/wasd_button.dart';
import 'package:flame/game.dart';
import 'dart:ui';


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
          // Juego y overlays (debe estar debajo del puntaje)
          GameWidget(
            game: game,
            overlayBuilderMap: {
              'GameOver': (context, gameInstance) {
                final snakeGame = gameInstance as SnakeGame;
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(36),
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
                            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 22),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 8,
                          ),
                          onPressed: onRestart,
                          icon: const Icon(Icons.refresh, color: Colors.white, size: 32),
                          label: const Text('Jugar de nuevo', style: TextStyle(fontSize: 28, color: Colors.white, fontFamily: 'Bit32', fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            },
            initialActiveOverlays: const [],
          ),
          // Contador de puntaje grande y botón de reinicio (siempre encima)
          SafeArea(
            child: Stack(
              children: [
                // Puntaje grande centrado arriba
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.8), // Color llamativo para depuración
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
                // Botón de reinicio arriba derecha
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
          // Controles en pantalla: solo flechas, pero permite teclado WASD y flechas
          Positioned(
            left: 30,
            bottom: 60,
            child: Column(
              children: [
                ArrowButton(
                  icon: Icons.keyboard_arrow_up,
                  onTap: () => game.setDirection(Direction.up),
                ),
                Row(
                  children: [
                    ArrowButton(
                      icon: Icons.keyboard_arrow_left,
                      onTap: () => game.setDirection(Direction.left),
                    ),
                    const SizedBox(width: 48),
                    ArrowButton(
                      icon: Icons.keyboard_arrow_right,
                      onTap: () => game.setDirection(Direction.right),
                    ),
                  ],
                ),
                ArrowButton(
                  icon: Icons.keyboard_arrow_down,
                  onTap: () => game.setDirection(Direction.down),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
