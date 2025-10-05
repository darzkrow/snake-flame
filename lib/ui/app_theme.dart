import 'package:flutter/material.dart';

// Constantes de estilo centralizadas para el juego
class AppTheme {
  // Colores de la aplicación
  static const Color backgroundGradientStart = Color(0xFF1A1A2E); // Azul oscuro futurista
  static const Color backgroundGradientEnd = Color(0xFF0F0F1B); // Casi negro
  static const Color boardColor = Color(0xFF2C2C40); // Tonalidad de tablero oscuro
  static const Color snakeColor = Color(0xFF6DE86D); // Verde neón brillante
  static const Color foodColor = Color(0xFFFF4081); // Rojo/Rosa neón para la comida normal
  static const Color bonusFoodColor = Color(0xFFFFC107); // Amarillo/Naranja brillante para la comida bonus
  static const Color gameOverPrimary = Color(0xFFFF5722); // Naranja neón para Game Over
  static const Color scoreBackground = Color(0x99000000); // Negro semi-transparente
  static const Color overlayGray = Color.fromRGBO(128, 128, 128, 0.7); // Gris con opacidad
  static const Color turboColor = Color(0xFF00E5FF); // Azul cian neón para turbo
  static const Color primaryText = Colors.white;
  static const Color accentText = Color(0xFFB0B0C4); // Gris azulado para acentos
  static const Color bestScoreColor = Color(0xFFCCFF90); // Verde pastel brillante

  // Radios y Bordes
  static const double cardRadius = 20.0;
  static const double buttonRadius = 12.0;
  static const double scoreRadius = 16.0;
  static const double scoreBorderWidth = 2.0;

  // Paddings y Márgenes
  static const EdgeInsets screenPadding = EdgeInsets.all(24.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(30.0);
  static const double menuMargin = 60.0;

  // Estilos de texto
  static const TextStyle titleStyle = TextStyle(
    fontFamily: 'Bit32', // Asumiendo que 'Bit32' es una fuente retro/pixel
    fontSize: 56,
    color: primaryText,
    fontWeight: FontWeight.w900,
    letterSpacing: 3,
  );

  static const TextStyle buttonStyle = TextStyle(
    fontFamily: 'Bit32',
    fontSize: 28,
    color: primaryText,
    letterSpacing: 1.5,
  );

  static const TextStyle scoreStyle = TextStyle(
    fontFamily: 'Bit32',
    fontSize: 32,
    color: primaryText,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bestScoreStyle = TextStyle(
    fontFamily: 'Bit32',
    fontSize: 18,
    color: bestScoreColor,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle turboLabelStyle = TextStyle(
    fontSize: 14, 
    color: primaryText, 
    fontFamily: 'Bit32'
  );

  static const TextStyle gameOverTitleStyle = TextStyle(
    fontFamily: 'Bit32',
    fontSize: 44,
    color: gameOverPrimary,
    fontWeight: FontWeight.bold,
    letterSpacing: 4,
    shadows: [
      Shadow(
        blurRadius: 10.0,
        color: Colors.black,
        offset: Offset(2.0, 2.0),
      ),
    ],
  );

  static TextStyle gameOverScoreTitleStyle = TextStyle(
    fontFamily: 'Bit32',
    fontSize: 24,
    color: primaryText.withOpacity(0.9),
    fontWeight: FontWeight.bold,
  );

  static const TextStyle gameOverScoreValueStyle = TextStyle(
    fontFamily: 'Bit32',
    fontSize: 48,
    color: bonusFoodColor,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        blurRadius: 10.0,
        color: Colors.black,
        offset: Offset(0, 0),
      ),
    ],
  );
  
  static const TextStyle restartButtonTextStyle = TextStyle(
    fontSize: 24, 
    color: primaryText, 
    fontFamily: 'Bit32', 
    fontWeight: FontWeight.bold
  );
}