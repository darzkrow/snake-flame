import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/snake_game.dart';

class GameArea extends StatelessWidget {
  final SnakeGame game;
  final Map<String, Widget Function(BuildContext, Game)> overlayBuilderMap;
  final List<String> initialActiveOverlays;
  const GameArea({required this.game, required this.overlayBuilderMap, required this.initialActiveOverlays, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        // Si es horizontal, usar todo el ancho y centrar verticalmente
        if (size.width > size.height) {
          return Center(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: GameWidget(
                game: game,
                overlayBuilderMap: overlayBuilderMap,
                initialActiveOverlays: initialActiveOverlays,
              ),
            ),
          );
        } else {
          // Si es vertical, mantener cuadrado
          final gameSize = size.width < size.height ? size.width : size.height;
          return Center(
            child: SizedBox(
              width: gameSize,
              height: gameSize,
              child: GameWidget(
                game: game,
                overlayBuilderMap: overlayBuilderMap,
                initialActiveOverlays: initialActiveOverlays,
              ),
            ),
          );
        }
      },
    );
  }
}
