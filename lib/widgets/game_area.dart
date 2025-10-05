import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/snake_game.dart';
import '../game/logic/snake_logic.dart';
import '../ui/app_theme.dart';

class GameArea extends StatelessWidget {
  final SnakeGame game;
  final Map<String, Widget Function(BuildContext, Game)> overlayBuilderMap;
  final List<String> initialActiveOverlays;
  const GameArea({required this.game, required this.overlayBuilderMap, required this.initialActiveOverlays, super.key});

  @override
  Widget build(BuildContext context) {
    Offset? dragStart;
    bool gestureUsed = false;

    return LayoutBuilder(
      builder: (context, constraints) {
        final borderRadius = BorderRadius.circular(AppTheme.cardRadius);
        final size = constraints.biggest;
        final backgroundImage = Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/board_bg.png'),
              fit: BoxFit.cover,
              opacity: 0.7,
            ),
          ),
        );
        Widget gameContent = ClipRRect(
          borderRadius: borderRadius,
          child: Container(
            color: Color.fromRGBO(44, 44, 64, 0.7),
            child: GameWidget(
              game: game,
              overlayBuilderMap: overlayBuilderMap,
              initialActiveOverlays: initialActiveOverlays,
            ),
          ),
        );
        // Envolver con GestureDetector para detectar swipes
        gameContent = GestureDetector(
          onPanStart: (details) {
            dragStart = details.localPosition;
            gestureUsed = false;
          },
          onPanUpdate: (details) {
            if (dragStart != null && !gestureUsed) {
              final delta = details.localPosition - dragStart!;
              if (delta.distance < 20) return; // Ignorar movimientos pequeños
              final dx = delta.dx.abs();
              final dy = delta.dy.abs();
              if (dx > dy) {
                if (delta.dx > 0) {
                  game.setDirection(Direction.right);
                } else {
                  game.setDirection(Direction.left);
                }
              } else {
                if (delta.dy > 0) {
                  game.setDirection(Direction.down);
                } else {
                  game.setDirection(Direction.up);
                }
              }
              gestureUsed = true;
            }
          },
          onPanEnd: (details) {
            dragStart = null;
            gestureUsed = false;
          },
          child: gameContent,
        );
        if (size.width > size.height) {
          return Stack(
            children: [
              backgroundImage,
              SizedBox(
                width: size.width,
                height: size.height,
                child: gameContent,
              ),
            ],
          );
        } else {
          final minSide = size.width < size.height ? size.width : size.height;
          return Stack(
            children: [
              backgroundImage,
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: minSide,
                  height: minSide,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.gameOverPrimary, width: 4),
                    borderRadius: borderRadius,
                  ),
                  child: gameContent,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
