import 'dart:math';
import '../food/normal_food.dart';
import '../food/bonus_food.dart';

enum Direction { up, down, left, right }

class SnakeLogic {
  List<Point<int>> snake;
  Direction direction;
  int applesEaten;
  Point<int>? orangeApple;
  int rows;
  int columns;
  Point<int> food;

  SnakeLogic({
    required this.snake,
    required this.direction,
    required this.applesEaten,
    required this.orangeApple,
    required this.rows,
    required this.columns,
    required this.food,
  });

  void setDirection(Direction newDirection) {
    if ((direction == Direction.up && newDirection == Direction.down) ||
        (direction == Direction.down && newDirection == Direction.up) ||
        (direction == Direction.left && newDirection == Direction.right) ||
        (direction == Direction.right && newDirection == Direction.left)) {
      return;
    }
    direction = newDirection;
  }

  Point<int> getNextHead() {
    final head = snake.first;
    switch (direction) {
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

  bool isCollision(Point<int> newHead) {
    return newHead.x < 0 || newHead.x >= columns || newHead.y < 0 || newHead.y >= rows || snake.contains(newHead);
  }

  void grow() {
    snake.insert(0, getNextHead());
  }

  void shrink() {
    snake.removeLast();
  }

  void generateFood() {
    food = NormalFood.generate(columns, rows, snake, orangeApple: orangeApple);
  }

  void generateOrangeApple() {
    orangeApple = BonusFood.generate(columns, rows, snake, food);
  }
}
