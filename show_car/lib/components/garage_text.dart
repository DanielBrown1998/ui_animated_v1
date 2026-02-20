import 'package:flutter/material.dart';

/// Widget de texto responsivo que se adapta ao textScaleFactor do sistema
/// e ao tamanho da tela, garantindo legibilidade em diferentes dispositivos.
class GarageText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool? softWrap;
  final TextDirection? textDirection;
  final StrutStyle? strutStyle;
  final Locale? locale;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  /// Fator de escala mínimo (limita redução em telas grandes)
  final double minScaleFactor;

  /// Fator de escala máximo (limita aumento em acessibilidade)
  final double maxScaleFactor;

  /// Se true, desativa completamente o scaling do sistema
  final bool ignoreSystemScale;

  /// Tamanho base de referência (largura em dp)
  /// usado para calcular escala responsiva
  static const double _baseScreenWidth = 375.0; // iPhone SE width

  const GarageText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.textDirection,
    this.strutStyle,
    this.locale,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.minScaleFactor = 0.8,
    this.maxScaleFactor = 1.3,
    this.ignoreSystemScale = false,
  });

  /// Construtor para títulos grandes (headlines)
  const GarageText.headline(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.textDirection,
    this.strutStyle,
    this.locale,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.minScaleFactor = 0.75,
    this.maxScaleFactor = 1.2,
    this.ignoreSystemScale = false,
  });

  /// Construtor para texto de corpo (body)
  const GarageText.body(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.textDirection,
    this.strutStyle,
    this.locale,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.minScaleFactor = 0.85,
    this.maxScaleFactor = 1.4,
    this.ignoreSystemScale = false,
  });

  /// Construtor para labels pequenas
  const GarageText.label(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.textDirection,
    this.strutStyle,
    this.locale,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.minScaleFactor = 0.9,
    this.maxScaleFactor = 1.2,
    this.ignoreSystemScale = false,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    // Calcula fator de escala baseado na largura da tela
    final screenScaleFactor = (screenWidth / _baseScreenWidth).clamp(0.8, 1.5);

    // Obtém o textScaleFactor do sistema (acessibilidade)
    final systemScaleFactor = ignoreSystemScale
        ? 1.0
        : mediaQuery.textScaler.scale(1.0);

    // Combina os fatores com limites
    final combinedScale = (screenScaleFactor * systemScaleFactor).clamp(
      minScaleFactor,
      maxScaleFactor,
    );

    // Aplica o estilo com tamanho ajustado
    final baseStyle = style ?? const TextStyle();
    final baseFontSize = baseStyle.fontSize ?? 14.0;
    final adjustedStyle = baseStyle.copyWith(
      fontSize: baseFontSize * combinedScale,
    );

    return Text(
      data,
      style: adjustedStyle,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      textDirection: textDirection,
      strutStyle: strutStyle,
      locale: locale,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      // Desabilita o textScaler padrão pois já aplicamos manualmente
      textScaler: TextScaler.noScaling,
    );
  }

  /// Calcula o tamanho de fonte responsivo baseado no contexto
  /// Útil para usar em TextStyle fora do GarageText
  static double responsiveFontSize(
    BuildContext context,
    double baseFontSize, {
    double minScale = 0.8,
    double maxScale = 1.3,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenScaleFactor = (screenWidth / _baseScreenWidth).clamp(0.8, 1.5);
    final systemScaleFactor = mediaQuery.textScaler.scale(1.0);
    final combinedScale = (screenScaleFactor * systemScaleFactor).clamp(
      minScale,
      maxScale,
    );
    return baseFontSize * combinedScale;
  }
}

/// Extension para facilitar conversão de Text para GarageText
extension TextToGarageText on String {
  GarageText toGarageText({
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return GarageText(
      this,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  GarageText toGarageHeadline({TextStyle? style, TextAlign? textAlign}) {
    return GarageText.headline(this, style: style, textAlign: textAlign);
  }

  GarageText toGarageBody({TextStyle? style, TextAlign? textAlign}) {
    return GarageText.body(this, style: style, textAlign: textAlign);
  }

  GarageText toGarageLabel({TextStyle? style, TextAlign? textAlign}) {
    return GarageText.label(this, style: style, textAlign: textAlign);
  }
}
