import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/snake_game.dart';
import '../ui/app_theme.dart';

class GameArea extends StatelessWidget {
  final SnakeGame game;
  final Map<String, Widget Function(BuildContext, Game)> overlayBuilderMap;
  final List<String> initialActiveOverlays;
  const GameArea({required this.game, required this.overlayBuilderMap, required this.initialActiveOverlays, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppTheme.screenPadding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final borderRadius = BorderRadius.circular(AppTheme.cardRadius);
          final size = constraints.biggest;
          if (size.width > size.height) {
            // Horizontal: usar todo el ancho y alto disponible
            return Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.gameOverPrimary, width: 4),
                borderRadius: borderRadius,
              ),
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Container(
                  color: AppTheme.boardColor,
                  child: GameWidget(
                    game: game,
                    overlayBuilderMap: overlayBuilderMap,
                    initialActiveOverlays: initialActiveOverlays,
                  ),
                ),
              ),
            );
          } else {
            // Vertical: cuadrado centrado
            final minSide = size.width < size.height ? size.width : size.height;
            return Align(
              alignment: Alignment.center,
              child: Container(
                width: minSide,
                height: minSide,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.gameOverPrimary, width: 4),
                  borderRadius: borderRadius,
                ),
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: Container(
                    color: AppTheme.boardColor,
                    child: GameWidget(
                      game: game,
                      overlayBuilderMap: overlayBuilderMap,
                      initialActiveOverlays: initialActiveOverlays,
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
