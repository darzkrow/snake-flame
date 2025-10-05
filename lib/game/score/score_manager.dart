import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreManager {
  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> bestScoreNotifier = ValueNotifier<int>(0);

  int get score => scoreNotifier.value;
  int get bestScore => bestScoreNotifier.value;

  ScoreManager() {
    _loadBestScore();
  }

  void increment(int value) {
    scoreNotifier.value += value;
    if (scoreNotifier.value > bestScoreNotifier.value) {
      bestScoreNotifier.value = scoreNotifier.value;
      _saveBestScore(scoreNotifier.value);
    }
  }

  void reset() {
    scoreNotifier.value = 0;
  }

  Future<void> _loadBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    bestScoreNotifier.value = prefs.getInt('best_score') ?? 0;
  }

  Future<void> _saveBestScore(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('best_score', value);
  }
}
