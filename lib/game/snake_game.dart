import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';



import 'score/score_manager.dart';
import 'logic/snake_logic.dart';
import 'food/normal_fruit.dart';
import 'food/special_fruit.dart';
import 'logic/auto_snake_bot.dart';
import 'stage/stage_manager.dart';

class SnakeGame extends FlameGame with HasKeyboardHandlerComponents {
  bool autoPlay = false;
  AutoSnakeBot? bot;
  late StageManager stageManager;
  int stage = 1;

  void nextStage() {
    stage++;
    _applyStage();
  }

  void _applyStage() {
    moveDelay = stageManager.getSpeedForStage(stage);
    logic.setObstacles(stageManager.generatePatternForStage(stage));
  }

  // Eliminado: _generateObstacles, ahora usamos StageManager

  @override
  Color backgroundColor() => Colors.transparent;
  int rows = 20;
  int columns = 20;
  final ScoreManager scoreManager = ScoreManager();
  int get score => scoreManager.score;
  int get bestScore => scoreManager.bestScore;
  double? cellSize;
  double moveTimer = 0.0;
  double moveDelay = 0.15;
  double normalDelay = 0.15;
  double fastDelay = 0.07;
  bool isGameOver = false;
  bool isAccelerating = false;
  Function()? onGameOverCallback;
  late SnakeLogic logic;

  SnakeGame() {
    reset();
  }

  void setDirection(Direction newDirection) {
    logic.setDirection(newDirection);
  }

  void setAccelerating(bool value) {
    isAccelerating = value;
    moveDelay = isAccelerating ? fastDelay : normalDelay;
  }

  void reset() {
    final startX = (columns / 2).floor();
    final startY = (rows / 2).floor();
    stage = 1;
    logic = SnakeLogic(
      snake: [Point<int>(startX, startY)],
      direction: Direction.right,
      applesEaten: 0,
      orangeApple: null,
      rows: rows,
      columns: columns,
      food: NormalFruit(Point<int>(5, 5)),
      obstacles: [],
    );
    bot = AutoSnakeBot(logic: logic, columns: columns, rows: rows);
    moveTimer = 0.0;
    isGameOver = false;
    scoreManager.reset();
    isAccelerating = false;
    stageManager = StageManager(columns: columns, rows: rows);
    moveDelay = stageManager.getSpeedForStage(stage);
    logic.setObstacles(stageManager.generatePatternForStage(stage));
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    const int minCells = 20;
    final double cellWidth = size.x / minCells;
    final double cellHeight = size.y / minCells;
    cellSize = cellWidth < cellHeight ? cellWidth : cellHeight;
    columns = (size.x / cellSize!).floor();
    rows = (size.y / cellSize!).floor();
    logic.rows = rows;
    logic.columns = columns;
  }

  @override
  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final result = super.onKeyEvent(event, keysPressed);
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.keyB) {
        autoPlay = !autoPlay;
        return KeyEventResult.handled;
      }
      if ((key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyW)) {
        setDirection(Direction.up);
      } else if ((key == LogicalKeyboardKey.arrowDown || key == LogicalKeyboardKey.keyS)) {
        setDirection(Direction.down);
      } else if ((key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.keyA)) {
        setDirection(Direction.left);
      } else if ((key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.keyD)) {
        setDirection(Direction.right);
      } else if (key == LogicalKeyboardKey.space) {
        setAccelerating(true);
      }
      return KeyEventResult.handled;
    } else if (event is KeyUpEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.space) {
        setAccelerating(false);
      }
    }
    return result;
  }

  @override
  void render(Canvas canvas) {
  super.render(canvas);
  // Dibujar frutas extra (lluvia)
    if (logic.extraFruits.isNotEmpty) {
      final paintExtra = Paint()..color = Colors.lightGreenAccent;
      for (final fruit in logic.extraFruits) {
        canvas.drawRect(
          Rect.fromLTWH(fruit.position.x * cellSize!, fruit.position.y * cellSize!, cellSize!, cellSize!),
          paintExtra,
        );
      }
    }
    // Dibujar frutas doradas (lluvia)
    if (logic.goldenFruits.isNotEmpty) {
      final paintGold = Paint()..color = Colors.amberAccent;
      for (final fruit in logic.goldenFruits) {
        canvas.drawOval(
          Rect.fromLTWH(fruit.position.x * cellSize!, fruit.position.y * cellSize!, cellSize!, cellSize!),
          paintGold,
        );
      }
    }
    // Mostrar icono de efecto especial activo
    if (logic.activeEffect != null && logic.specialEffectEnd != null && DateTime.now().isBefore(logic.specialEffectEnd!)) {
      Color color = Colors.white;
      switch (logic.activeEffect!) {
        case SpecialEffectType.antiCollision:
          color = Colors.blueAccent;
          break;
        case SpecialEffectType.turbo:
          color = Colors.purpleAccent;
          break;
        case SpecialEffectType.doublePoints:
          color = Colors.yellowAccent;
          break;
        case SpecialEffectType.reverseControls:
          color = Colors.redAccent;
          break;
        case SpecialEffectType.magnet:
          color = Colors.cyan;
          break;
        case SpecialEffectType.fruitRain:
          color = Colors.deepOrangeAccent;
          break;
      }
      final double iconSize = 38;
      final Offset iconPos = Offset((columns * cellSize!) - iconSize - 16, 16);
      var r = (color.r * 255.0);
      var d = (color.g * 255.0);
      var e = (color.b * 255.0);
      // Animación de aparición (fade/scale simple)
      double t = 1.0;
      if (logic.specialEffectEnd != null) {
        final total = 10.0;
        final restante = logic.specialEffectEnd!.difference(DateTime.now()).inMilliseconds / 1000.0;
        t = restante > total - 0.3 ? (1 - ((total - restante) / 0.3)).clamp(0.0, 1.0) : 1.0;
      }
      final Offset center = iconPos + Offset(iconSize / 2, iconSize / 2);
      final double scale = 0.8 + 0.2 * t;
  // alpha eliminado, no se usa
      // Sombra
  canvas.drawCircle(center + Offset(2, 4), iconSize / 2 * scale, Paint()..color = Colors.black.withAlpha((0.25 * 255).toInt()));
      // Círculo principal con borde
      canvas.drawCircle(center, iconSize / 2 * scale, Paint()
        ..color = Color.fromRGBO(r.round() & 0xFF, d.round() & 0xFF, e.round() & 0xFF, 0.85)
        ..style = PaintingStyle.fill);
      canvas.drawCircle(center, iconSize / 2 * scale, Paint()
        ..color = Colors.white.withAlpha((0.85 * 255).toInt())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3);
      // Letra o símbolo
      final textPainter = TextPainter(
        text: TextSpan(
          text: logic.activeEffect == SpecialEffectType.antiCollision ? 'A' :
                logic.activeEffect == SpecialEffectType.turbo ? 'T' :
                logic.activeEffect == SpecialEffectType.doublePoints ? '2x' :
                logic.activeEffect == SpecialEffectType.reverseControls ? 'R' :
                logic.activeEffect == SpecialEffectType.magnet ? 'M' :
                logic.activeEffect == SpecialEffectType.fruitRain ? 'F' : '',
          style: TextStyle(color: Colors.black.withAlpha((t * 255).toInt()), fontSize: 22 * scale, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 4, color: Colors.white, offset: Offset(0,0))]),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, center - Offset(textPainter.width/2, textPainter.height/2));
    }
    if (cellSize == null) return;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, columns * cellSize!, rows * cellSize!), 
      Paint()..color = Colors.transparent,
    );
    // Dibujar obstáculos
    if (logic.obstacles.isNotEmpty) {
      final paintObs = Paint()..color = Colors.brown;
      for (final obs in logic.obstacles) {
        canvas.drawRect(
          Rect.fromLTWH(obs.x * cellSize!, obs.y * cellSize!, cellSize!, cellSize!),
          paintObs,
        );
      }
    }
    for (final p in logic.snake) {
      canvas.drawRect(
        Rect.fromLTWH(p.x * cellSize!, p.y * cellSize!, cellSize!, cellSize!),
        Paint()..color = Colors.green,
      );
    }
    // Manzana normal
    canvas.drawRect(
      Rect.fromLTWH(logic.food.position.x * cellSize!, logic.food.position.y * cellSize!, cellSize!, cellSize!),
      Paint()..color = Colors.red,
    );
    // Manzana naranja
    if (logic.orangeApple != null) {
      canvas.drawRect(
        Rect.fromLTWH(logic.orangeApple!.position.x * cellSize!, logic.orangeApple!.position.y * cellSize!, cellSize!, cellSize!),
        Paint()..color = Colors.orange,
      );
    }
    // Dibujar fruta especial
    if (logic.specialFruit != null) {
      final paintSpecial = Paint()
        ..color = Color.fromRGBO(124, 77, 255, 0.8) // Colors.blueAccent.withOpacity(0.8)
        ..style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromLTWH(
          logic.specialFruit!.position.x * cellSize!,
          logic.specialFruit!.position.y * cellSize!,
          cellSize!,
          cellSize!,
        ),
        paintSpecial,
      );
    }
    if (isGameOver) {
      final textPainter = TextPainter(
        text: const TextSpan(
          text: 'Game Over',
          style: TextStyle(color: Colors.white, fontSize: 32),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset((columns * cellSize! - textPainter.width) / 2, (rows * cellSize! - textPainter.height) / 2),
      );
    }
  }

  @override
  void update(double dt) {
    logic.updateMagnet();
    super.update(dt);
    if (isGameOver) return;
    logic.maybeSpawnSpecialFruit();
    logic.updateSpecialFruit();
    if (autoPlay && bot != null) {
      final dir = bot!.getNextDirection();
      if (dir != null) setDirection(dir);
    }
    moveTimer += dt;
    if (moveTimer >= moveDelay) {
      moveTimer = 0.0;
      _moveSnake();
    }
  }

  void _moveSnake() {
    final newHead = logic.getNextHead();
    logic.eatSpecialFruitIfNeeded(newHead);
    if (logic.isCollision(newHead)) {
      isGameOver = true;
      if (onGameOverCallback != null) {
        overlays.add('GameOver');
        onGameOverCallback!();
      }
      return;
    }
    logic.snake.insert(0, newHead);
    // Comer fruta especial (lluvia)
  if (logic.extraFruits.isNotEmpty && newHead == logic.extraFruits.first.position) {
      int scoreToAdd = 3;
      if (isAccelerating && scoreManager.score > 0) {
        scoreManager.scoreNotifier.value -= 1;
      }
      scoreManager.increment(scoreToAdd);
      logic.applesEaten += 1;
  logic.extraFruits.removeAt(0);
  } else if (logic.goldenFruits.isNotEmpty && newHead == logic.goldenFruits.first.position) {
      int scoreToAdd = 7;
      if (isAccelerating && scoreManager.score > 0) {
        scoreManager.scoreNotifier.value -= 1;
      }
      scoreManager.increment(scoreToAdd);
      logic.applesEaten += 5;
  logic.goldenFruits.removeAt(0);
  } else if (newHead == logic.food.position) {
      int scoreToAdd = 1;
      if (isAccelerating && scoreManager.score > 0) {
        // Penalización: quemar 1 punto por moverse rápido
        scoreManager.scoreNotifier.value -= 1;
      }
      scoreManager.increment(scoreToAdd);
      logic.applesEaten += 1;
      // Subir de nivel cada 10 manzanas
      if (logic.applesEaten % 10 == 0) {
        nextStage();
      }
      logic.generateFood();
      // Cada 5 manzanas, aparece una naranja
      if (logic.applesEaten % 5 == 0) {
        logic.generateOrangeApple();
      }
  } else if (logic.orangeApple != null && newHead == logic.orangeApple!.position) {
      int scoreToAdd = 10;
      if (isAccelerating && scoreManager.score > 0) {
        scoreManager.scoreNotifier.value -= 1;
      }
      scoreManager.increment(scoreToAdd);
      logic.orangeApple = null;
      logic.shrink(); // No crecer dos veces
    } else {
      logic.shrink();
      if (isAccelerating && scoreManager.score > 0) {
        // Penalización por moverse rápido aunque no coma
        scoreManager.scoreNotifier.value -= 1;
      }
    }
  }
}
