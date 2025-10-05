import 'dart:math';

class BonusFood {
  Point<int>? position;

  BonusFood([this.position]);

  static Point<int> generate(int columns, int rows, List<Point<int>> snake, Point<int> food) {
    final random = Random();
    Point<int> pos;
    do {
      pos = Point(random.nextInt(columns), random.nextInt(rows));
    } while (snake.contains(pos) || pos == food);
    return pos;
  }
}
