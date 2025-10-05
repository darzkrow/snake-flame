import 'dart:math';

enum SpecialEffectType {
  antiCollision,
  turbo,
  doublePoints,
  reverseControls,
  magnet,
  fruitRain,
}

class SpecialFruit {
  final Point<int> position;
  final SpecialEffectType effectType;
  final DateTime spawnTime;
  final Duration duration;

  SpecialFruit({
    required this.position,
    required this.effectType,
    required this.spawnTime,
    this.duration = const Duration(seconds: 10),
  });

  bool isExpired(DateTime now) => now.difference(spawnTime) > duration;
}
