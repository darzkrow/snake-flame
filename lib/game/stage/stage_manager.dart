import 'dart:math';

class StageManager {
  /// Devuelve la velocidad del juego según el nivel (stage).
  double getSpeedForStage(int stage) {
    // Progresión: baja rápido al principio, luego más suave
    if (stage == 1) return 0.15;
    if (stage == 2) return 0.12;
    if (stage == 3) return 0.10;
    if (stage == 4) return 0.09;
    if (stage == 5) return 0.08;
    if (stage == 6) return 0.07;
    if (stage == 7) return 0.065;
    if (stage == 8) return 0.06;
    if (stage == 9) return 0.055;
    if (stage >= 10) return 0.05;
    return 0.15;
  }

  /// Genera obstáculos aleatorios, aumentando la cantidad según el nivel.
  List<Point<int>> generatePatternForStage(int stage, {int min=5, int max=50}) {
    // Progresión: más obstáculos y más rápido a mayor nivel
    int count = min + ((stage - 1) * 4);
    if (stage > 10) count += (stage - 10) * 2; // penalización extra para niveles altos
    if (count > max) count = max;
    final Set<Point<int>> obs = {};
    while (obs.length < count) {
      final p = Point(_rand.nextInt(columns), _rand.nextInt(rows));
      obs.add(p);
    }
    return obs.toList();
  }
  final int columns;
  final int rows;
  final Random _rand = Random();

  StageManager({required this.columns, required this.rows});

}
