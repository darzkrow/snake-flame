import 'dart:math';

/// Cada patrón es una lista de puntos relativos (x, y) que forman una letra.
class StagePatterns {
  static final Map<String, List<Point<int>>> patterns = {
    'L': [
      Point(0, 0), Point(0, 1), Point(0, 2), Point(0, 3), Point(1, 3), Point(2, 3)
    ],
    'T': [
      Point(0, 0), Point(1, 0), Point(2, 0), Point(1, 1), Point(1, 2), Point(1, 3)
    ],
    'C': [
      Point(1, 0), Point(0, 1), Point(0, 2), Point(1, 3), Point(2, 1), Point(2, 2)
    ],
    'Z': [
      Point(0, 0), Point(1, 0), Point(1, 1), Point(2, 1), Point(2, 2), Point(3, 2)
    ],
    // Agrega más letras aquí
  };
}
