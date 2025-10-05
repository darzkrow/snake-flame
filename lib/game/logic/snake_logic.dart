

import 'dart:math';

import '../food/normal_fruit.dart';
import '../food/orange_apple.dart';
import '../food/special_fruit.dart';
import '../food/extra_fruit.dart';
import '../food/golden_fruit.dart';
import '../food/bonus_food.dart';

/// Puntajes centralizados para cada tipo de fruta
class FruitScores {
  static const int normal = 1;
  static const int orange = 10;
  static const int extra = 3;
  static const int golden = 7;
}

enum Direction { up, down, left, right }


class SnakeLogic {
  List<Point<int>> snake;
  Direction direction;
  int applesEaten;
  OrangeApple? orangeApple;
  int rows;
  int columns;
  NormalFruit food;
  List<Point<int>> obstacles;
  SpecialFruit? specialFruit;
  DateTime? specialEffectEnd;
  SpecialEffectType? activeEffect;
  List<ExtraFruit> extraFruits = [];
  List<GoldenFruit> goldenFruits = [];

  SnakeLogic({
    required this.snake,
    required this.direction,
    required this.applesEaten,
    required this.orangeApple,
    required this.rows,
    required this.columns,
    required this.food,
    this.obstacles = const [],
    this.specialFruit,
    this.specialEffectEnd,
    this.activeEffect,
  });

  bool get hasMagnet =>
    activeEffect == SpecialEffectType.magnet && specialEffectEnd != null && DateTime.now().isBefore(specialEffectEnd!);

  bool get hasFruitRain =>
    activeEffect == SpecialEffectType.fruitRain && specialEffectEnd != null && DateTime.now().isBefore(specialEffectEnd!);

  // Efecto imán: mueve la fruta hacia la cabeza y la come automáticamente si está al lado o encima
  void updateMagnet() {
    if (!hasMagnet || snake.isEmpty) return;
    final head = snake.first;
    int dx = food.position.x - head.x;
    int dy = food.position.y - head.y;
    int manhattan = dx.abs() + dy.abs();
    if (manhattan > 5) return; // Solo atraer si está a 5 cuadros o menos
    if (manhattan == 1) {
      // Si la fruta está justo al lado, comer automáticamente
      food = NormalFruit(head);
      applesEaten += 1;
      generateFood();
    } else if (food.position == head) {
      applesEaten += 1;
      generateFood();
    } else if (manhattan > 1) {
      // Mover la fruta un paso hacia la cabeza
      int stepX = dx == 0 ? 0 : (dx > 0 ? -1 : 1);
      int stepY = dy == 0 ? 0 : (dy > 0 ? -1 : 1);
      Point<int> newPos = Point(food.position.x + stepX, food.position.y + stepY);
      if (!snake.contains(newPos) && !obstacles.contains(newPos)) {
        food = NormalFruit(newPos);
      }
    }
  }
  // Devuelve la siguiente posición de la cabeza según la dirección actual o una dirección dada
  Point<int> getNextHead([Direction? dirOverride]) {
    final head = snake.first;
    final dir = dirOverride ?? direction;
    switch (dir) {
      case Direction.up:
        return Point(head.x, head.y - 1);
      case Direction.down:
        return Point(head.x, head.y + 1);
      case Direction.left:
        return Point(head.x - 1, head.y);
      case Direction.right:
        return Point(head.x + 1, head.y);
    }
  }

  bool get hasAntiCollision =>
    activeEffect == SpecialEffectType.antiCollision && specialEffectEnd != null && DateTime.now().isBefore(specialEffectEnd!);

  bool get hasTurbo =>
    activeEffect == SpecialEffectType.turbo && specialEffectEnd != null && DateTime.now().isBefore(specialEffectEnd!);

  bool get hasDoublePoints =>
    activeEffect == SpecialEffectType.doublePoints && specialEffectEnd != null && DateTime.now().isBefore(specialEffectEnd!);

  bool get hasReverseControls =>
    activeEffect == SpecialEffectType.reverseControls && specialEffectEnd != null && DateTime.now().isBefore(specialEffectEnd!);

  void maybeSpawnSpecialFruit() {
    if (specialFruit == null && Random().nextDouble() < 0.01) { // 1% chance per tick
      Point<int> pos;
      do {
        pos = Point(Random().nextInt(columns), Random().nextInt(rows));
  } while (snake.contains(pos) || obstacles.contains(pos) || pos == food.position || (orangeApple != null && pos == orangeApple!.position));
      // Elegir efecto aleatorio
      final effects = SpecialEffectType.values;
      final effect = effects[Random().nextInt(effects.length)];
      specialFruit = SpecialFruit(
        position: pos,
        effectType: effect,
        spawnTime: DateTime.now(),
      );
    }
  }

  void updateSpecialFruit() {
    if (specialFruit != null && specialFruit!.isExpired(DateTime.now())) {
      specialFruit = null;
    }
  }

  void eatSpecialFruitIfNeeded(Point<int> head) {
  if (specialFruit != null && head == specialFruit!.position) {
      // Activar efecto especial
      activeEffect = specialFruit!.effectType;
      specialEffectEnd = DateTime.now().add(const Duration(seconds: 10));
      // Efecto lluvia de frutas
      if (activeEffect == SpecialEffectType.fruitRain) {
        extraFruits.clear();
        goldenFruits.clear();
        final rand = Random();
        if (rand.nextBool()) {
          // 20 frutas normales
          while (extraFruits.length < 20) {
            final p = Point(rand.nextInt(columns), rand.nextInt(rows));
            if (!snake.contains(p) && !obstacles.contains(p) && p != food.position && (orangeApple == null || p != orangeApple!.position)) {
              extraFruits.add(ExtraFruit(p));
            }
          }
        } else {
          // 5 doradas
          while (goldenFruits.length < 5) {
            final p = Point(rand.nextInt(columns), rand.nextInt(rows));
            if (!snake.contains(p) && !obstacles.contains(p) && p != food.position && (orangeApple == null || p != orangeApple!.position)) {
              goldenFruits.add(GoldenFruit(p));
            }
          }
        }
      }
      specialFruit = null;
    }
    // Limpiar frutas extra/doradas cuando termina el efecto
    if (!hasFruitRain) {
      extraFruits.clear();
      goldenFruits.clear();
    }
  }

  void setDirection(Direction newDirection) {
    if ((direction == Direction.up && newDirection == Direction.down) ||
        (direction == Direction.down && newDirection == Direction.up) ||
        (direction == Direction.left && newDirection == Direction.right) ||
        (direction == Direction.right && newDirection == Direction.left)) {
      return;
    }
    direction = newDirection;
  }

  bool isCollision(Point<int> newHead) {
    if (hasAntiCollision) {
      return newHead.x < 0 || newHead.x >= columns || newHead.y < 0 || newHead.y >= rows;
    }
    return newHead.x < 0 || newHead.x >= columns || newHead.y < 0 || newHead.y >= rows || snake.contains(newHead) || obstacles.contains(newHead);
  }

  void setObstacles(List<Point<int>> newObstacles) {
    obstacles = newObstacles;
  }

  void grow() {
    snake.insert(0, getNextHead());
  }

  void shrink() {
    snake.removeLast();
  }

  void generateFood() {
  food = NormalFruit(_generateSafeFood());
  }

  Point<int> _generateSafeFood() {
    final random = Random();
    Point<int> pos;
    do {
      pos = Point(random.nextInt(columns), random.nextInt(rows));
    } while (snake.contains(pos) || obstacles.contains(pos) || (orangeApple != null && pos == orangeApple!.position));
    return pos;
  }

  void generateOrangeApple() {
  final pos = BonusFood.generate(columns, rows, snake, food.position);
  orangeApple = OrangeApple(pos);
  }
}
