import 'package:flutter/material.dart';
import '../../game/snake_game.dart';
import '../../widgets/arrow_button.dart';
import '../../game/logic/snake_logic.dart';

class GameControls extends StatelessWidget {
  final SnakeGame game;
  const GameControls({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return SafeArea(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 220),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ArrowButton(
                icon: Icons.keyboard_arrow_up,
                onTap: () => game.setDirection(Direction.up),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ArrowButton(
                    icon: Icons.keyboard_arrow_left,
                    onTap: () => game.setDirection(Direction.left),
                  ),
                  SizedBox(width: isWide ? 48 : 20),
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
      ),
    );
  }
}
