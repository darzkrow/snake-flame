import 'dart:math';

class NormalFood {
  Point<int> position;

  NormalFood(this.position);

  static Point<int> generate(int columns, int rows, List<Point<int>> snake, {Point<int>? orangeApple}) {
    final random = Random();
    Point<int> food;
    do {
      food = Point(random.nextInt(columns), random.nextInt(rows));
    } while (snake.contains(food) || (orangeApple != null && food == orangeApple));
    return food;
  }
}
