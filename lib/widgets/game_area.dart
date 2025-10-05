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
    return LayoutBuilder(
      builder: (context, constraints) {
        final borderRadius = BorderRadius.circular(AppTheme.cardRadius);
        final size = constraints.biggest;
        // Imagen de fondo siempre ocupa todo el área
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
        if (size.width > size.height) {
          // Horizontal: usar todo el ancho y alto disponible
          return Stack(
            children: [
              backgroundImage,
              Container(
                width: size.width,
                height: size.height,
              
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: Container(
                    color: AppTheme.boardColor.withOpacity(0.7),
                    child: GameWidget(
                      game: game,
                      overlayBuilderMap: overlayBuilderMap,
                      initialActiveOverlays: initialActiveOverlays,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          // Vertical: cuadrado centrado
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
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: Container(
                      color: AppTheme.boardColor.withOpacity(0.7),
                      child: GameWidget(
                        game: game,
                        overlayBuilderMap: overlayBuilderMap,
                        initialActiveOverlays: initialActiveOverlays,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
