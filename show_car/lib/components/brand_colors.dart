import 'package:flutter/material.dart';

/// Cores das marcas de carros para gradientes dinâmicos
class BrandColors {
  static const Map<String, List<Color>> brandGradients = {
    'bmw': [Color(0xFF0066B1), Color(0xFF1D4F91)],
    'ferrari': [Color(0xFFFF2800), Color(0xFF8B0000)],
    'lamborghini': [Color(0xFFFFD700), Color(0xFFFF8C00)],
    'porsche': [Color(0xFFB12B28), Color(0xFF8B0000)],
    'mclaren': [Color(0xFFFF8700), Color(0xFFCC6D00)],
    'nissan': [Color(0xFFC3002F), Color(0xFF8B0020)],
    'chevrolet': [Color(0xFFD4AF37), Color(0xFFB8860B)],
    'dodge': [Color(0xFFB22222), Color(0xFF8B0000)],
    'mercedes': [Color(0xFF00ADEF), Color(0xFF00758F)],
    'audi': [Color(0xFFBB0A30), Color(0xFF8B0020)],
    'volkswagen': [Color(0xFF001E50), Color(0xFF001030)],
    'toyota': [Color(0xFFEB0A1E), Color(0xFFB00818)],
    'honda': [Color(0xFFCC0000), Color(0xFF8B0000)],
    'ford': [Color(0xFF003478), Color(0xFF001E50)],
    'tesla': [Color(0xFFCC0000), Color(0xFF8B0000)],
    'bugatti': [Color(0xFF003399), Color(0xFF001E60)],
    'koenigsegg': [Color(0xFFFFD700), Color(0xFFCC8800)],
    'pagani': [Color(0xFF1C1C1C), Color(0xFF0A0A0A)],
    'aston martin': [Color(0xFF006847), Color(0xFF004030)],
    'bentley': [Color(0xFF003300), Color(0xFF001A00)],
    'rolls royce': [Color(0xFF1C1C1C), Color(0xFF0A0A0A)],
    'jaguar': [Color(0xFF006633), Color(0xFF004422)],
    'land rover': [Color(0xFF005A2B), Color(0xFF003820)],
    'alfa romeo': [Color(0xFF8B0000), Color(0xFF5C0000)],
    'maserati': [Color(0xFF003366), Color(0xFF002244)],
  };

  /// Obtém as cores do gradiente para uma marca
  static List<Color> getGradient(String brand) {
    final normalizedBrand = brand.toLowerCase().trim();
    return brandGradients[normalizedBrand] ??
        [const Color(0xFF2D2D2D), const Color(0xFF1A1A1A)];
  }

  /// Obtém a cor primária da marca
  static Color getPrimary(String brand) {
    return getGradient(brand).first;
  }

  /// Obtém a cor secundária da marca
  static Color getSecondary(String brand) {
    return getGradient(brand).last;
  }

  /// Obtém um gradiente para usar em decorações
  static LinearGradient getLinearGradient(
    String brand, {
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    double opacity = 1.0,
  }) {
    final colors = getGradient(brand);
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors.map((c) => c.withOpacity(opacity)).toList(),
    );
  }

  /// Obtém um gradiente radial para efeitos de glow
  static RadialGradient getRadialGlow(
    String brand, {
    double opacity = 0.5,
    double radius = 1.0,
  }) {
    final primary = getPrimary(brand);
    return RadialGradient(
      radius: radius,
      colors: [primary.withOpacity(opacity), primary.withOpacity(0)],
    );
  }

  /// Obtém uma sombra com a cor da marca
  static List<BoxShadow> getBrandShadow(
    String brand, {
    double blurRadius = 30,
    double spreadRadius = -5,
    Offset offset = const Offset(0, 15),
    double opacity = 0.3,
  }) {
    final primary = getPrimary(brand);
    return [
      BoxShadow(
        color: primary.withOpacity(opacity),
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
        offset: offset,
      ),
    ];
  }
}

/// Extensão para facilitar o uso no context
extension BrandColorsExtension on String {
  List<Color> get brandGradient => BrandColors.getGradient(this);
  Color get brandPrimary => BrandColors.getPrimary(this);
  Color get brandSecondary => BrandColors.getSecondary(this);
}
