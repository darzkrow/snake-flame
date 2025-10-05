import 'package:flutter/material.dart';
import '../../game/snake_game.dart';

class GameControls extends StatelessWidget {
  final SnakeGame game;
  const GameControls({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 24, bottom: 18),
          child: GestureDetector(
            onTapDown: (_) => game.setAccelerating(true),
            onTapUp: (_) => game.setAccelerating(false),
            onTapCancel: () => game.setAccelerating(false),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(158, 158, 158, 0.7), // Colors.grey.withOpacity(0.7)
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.flash_on, color: Colors.white, size: 34)
                
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
