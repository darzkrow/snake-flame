import 'dart:math';
import 'snake_logic.dart';

class AutoSnakeBot {
  final SnakeLogic logic;
  final int columns;
  final int rows;

  AutoSnakeBot({required this.logic, required this.columns, required this.rows});

  Direction? getNextDirection() {
    final head = logic.snake.first;
    // Construir lista de objetivos prioritarios
    final List<Point<int>> targets = [];
    if (logic.specialFruit != null) targets.add(logic.specialFruit!.position);
    if (logic.goldenFruits.isNotEmpty) targets.addAll(logic.goldenFruits);
    if (logic.extraFruits.isNotEmpty) targets.addAll(logic.extraFruits);
    if (logic.orangeApple != null) targets.add(logic.orangeApple!);
    targets.add(logic.food);

    // Buscar el objetivo más cercano
    Point<int> closest = targets.first;
    int minDist = (head.x - closest.x).abs() + (head.y - closest.y).abs();
    for (final t in targets) {
      final d = (head.x - t.x).abs() + (head.y - t.y).abs();
      if (d < minDist) {
        minDist = d;
        closest = t;
      }
    }

    final directions = [
      Direction.up,
      Direction.down,
      Direction.left,
      Direction.right,
    ];
    final safeDirs = directions.where((dir) {
      if (_isReverse(dir)) return false;
      final next = _nextPoint(head, dir);
      return !_isCollision(next);
    }).toList();
    if (safeDirs.isEmpty) return null;

    // Flood fill para cada dirección segura
    int maxFree = -1;
    Direction? bestDir;
    for (final dir in safeDirs) {
      final next = _nextPoint(head, dir);
      final free = _floodFillFree(next, Set.from(logic.snake));
      if (free > maxFree) {
        maxFree = free;
        bestDir = dir;
      }
    }

    // Si hay varias con igual espacio, priorizar la que acerque al objetivo
    final bestDirs = safeDirs.where((dir) {
      final next = _nextPoint(head, dir);
      return _floodFillFree(next, Set.from(logic.snake)) == maxFree;
    }).toList();
    bestDirs.sort((a, b) {
      final nextA = _nextPoint(head, a);
      final nextB = _nextPoint(head, b);
      final distA = (nextA.x - closest.x).abs() + (nextA.y - closest.y).abs();
      final distB = (nextB.x - closest.x).abs() + (nextB.y - closest.y).abs();
      return distA.compareTo(distB);
    });
    return bestDirs.first;
  }

  // Flood fill para contar casillas libres desde un punto
  int _floodFillFree(Point<int> start, Set<Point<int>> snakeBody) {
    final queue = <Point<int>>[start];
    final visited = <Point<int>>{...snakeBody};
    int count = 0;
    while (queue.isNotEmpty && count < columns * rows) {
      final p = queue.removeLast();
      if (visited.contains(p) || _isCollision(p)) continue;
      visited.add(p);
      count++;
      for (final dir in [Direction.up, Direction.down, Direction.left, Direction.right]) {
        final next = _nextPoint(p, dir);
        if (!visited.contains(next) && !_isCollision(next)) {
          queue.add(next);
        }
      }
    }
    return count;
  }

  bool _isReverse(Direction dir) {
    if (logic.direction == Direction.up && dir == Direction.down) return true;
    if (logic.direction == Direction.down && dir == Direction.up) return true;
    if (logic.direction == Direction.left && dir == Direction.right) return true;
    if (logic.direction == Direction.right && dir == Direction.left) return true;
    return false;
  }

  Point<int> _nextPoint(Point<int> from, Direction dir) {
    switch (dir) {
      case Direction.up:
        return Point(from.x, from.y - 1);
      case Direction.down:
        return Point(from.x, from.y + 1);
      case Direction.left:
        return Point(from.x - 1, from.y);
      case Direction.right:
        return Point(from.x + 1, from.y);
    }
  }

  bool _isCollision(Point<int> p) {
    if (p.x < 0 || p.x >= columns || p.y < 0 || p.y >= rows) return true;
    if (logic.obstacles.contains(p)) return true;
    if (logic.snake.contains(p)) return true;
    return false;
  }
}
