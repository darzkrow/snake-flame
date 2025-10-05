import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'score/score_manager.dart';
import 'logic/snake_logic.dart';
import 'logic/special_fruit.dart';
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
      food: Point<int>(5, 5),
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
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    const int minCells = 20;
    final double cellWidth = canvasSize.x / minCells;
    final double cellHeight = canvasSize.y / minCells;
    cellSize = cellWidth < cellHeight ? cellWidth : cellHeight;
    columns = (canvasSize.x / cellSize!).floor();
    rows = (canvasSize.y / cellSize!).floor();
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
      for (final p in logic.extraFruits) {
        canvas.drawRect(
          Rect.fromLTWH(p.x * cellSize!, p.y * cellSize!, cellSize!, cellSize!),
          paintExtra,
        );
      }
    }
    // Dibujar frutas doradas (lluvia)
    if (logic.goldenFruits.isNotEmpty) {
      final paintGold = Paint()..color = Colors.amberAccent;
      for (final p in logic.goldenFruits) {
        canvas.drawOval(
          Rect.fromLTWH(p.x * cellSize!, p.y * cellSize!, cellSize!, cellSize!),
          paintGold,
        );
      }
    }
    // Mostrar icono de efecto especial activo
    if (logic.activeEffect != null && logic.specialEffectEnd != null && DateTime.now().isBefore(logic.specialEffectEnd!)) {
      Color color = Colors.white;
      String label = '';
      switch (logic.activeEffect!) {
        case SpecialEffectType.antiCollision:
          color = Colors.blueAccent;
          label = 'A';
          break;
        case SpecialEffectType.turbo:
          color = Colors.purpleAccent;
          label = 'T';
          break;
        case SpecialEffectType.doublePoints:
          color = Colors.yellowAccent;
          label = '2x';
          break;
        case SpecialEffectType.reverseControls:
          color = Colors.redAccent;
          label = 'R';
          break;
        case SpecialEffectType.magnet:
          color = Colors.cyan;
          label = 'M';
          break;
        case SpecialEffectType.fruitRain:
          color = Colors.deepOrangeAccent;
          label = 'F';
          break;
      }
      final double iconSize = 32;
      final Offset iconPos = Offset((columns * cellSize!) - iconSize - 8, 8);
      canvas.drawCircle(iconPos + Offset(iconSize/2, iconSize/2), iconSize/2, Paint()..color = color.withOpacity(0.85));
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, iconPos + Offset((iconSize - textPainter.width)/2, (iconSize - textPainter.height)/2));
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
      Rect.fromLTWH(logic.food.x * cellSize!, logic.food.y * cellSize!, cellSize!, cellSize!),
      Paint()..color = Colors.red,
    );
    // Manzana naranja
    if (logic.orangeApple != null) {
      canvas.drawRect(
        Rect.fromLTWH(logic.orangeApple!.x * cellSize!, logic.orangeApple!.y * cellSize!, cellSize!, cellSize!),
        Paint()..color = Colors.orange,
      );
    }
    // Dibujar fruta especial
    if (logic.specialFruit != null) {
      final paintSpecial = Paint()
        ..color = Colors.blueAccent.withOpacity(0.8)
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
    // Comer manzana normal
    if (newHead == logic.food) {
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
    } else if (logic.orangeApple != null && newHead == logic.orangeApple) {
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
