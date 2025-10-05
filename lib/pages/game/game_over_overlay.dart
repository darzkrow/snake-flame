import 'package:flutter/material.dart';
import '../../game/snake_game.dart';
import '../../ui/app_theme.dart';

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
              color: AppTheme.overlayGray,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.amber, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('GAME OVER', style: AppTheme.gameOverTitleStyle.copyWith(fontSize: 38)),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<int>(
                    valueListenable: snakeGame.scoreManager.scoreNotifier,
                    builder: (context, score, _) => Column(
                      children: [
                        Text('Puntaje', style: AppTheme.scoreStyle.copyWith(fontSize: 36)),
                        const SizedBox(height: 4),
                        Text('$score', style: AppTheme.gameOverScoreValueStyle),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                    ),
                    onPressed: onRestart,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.refresh, color: Colors.white, size: 20)
                       ],
                    ),
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
