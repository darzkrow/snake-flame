import 'dart:math';
import 'fruit.dart';

enum SpecialEffectType {
  antiCollision,
  turbo,
  doublePoints,
  reverseControls,
  magnet,
  fruitRain,
}

class SpecialFruit extends Fruit {
  final SpecialEffectType effectType;
  final DateTime spawnTime;
  SpecialFruit({
    required Point<int> position,
    required this.effectType,
    required this.spawnTime,
  }) : super(position);

  bool isExpired(DateTime now) => now.difference(spawnTime).inSeconds > 10;
}
