import 'package:flutter/material.dart';

/// CustomPainter que desenha o circuito de Nürburgring (Nordschleife + GP-Strecke)
class NurburgringPainter extends CustomPainter {
  final Color trackColor;
  final Color trackBorderColor;
  final double strokeWidth;
  final bool showStartFinish;
  final Color startFinishColor;

  NurburgringPainter({
    this.trackColor = Colors.grey,
    this.trackBorderColor = Colors.white,
    this.strokeWidth = 4.0,
    this.showStartFinish = true,
    this.startFinishColor = Colors.red,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / 100;
    final double scaleY = size.height / 100;

    // Path do circuito Nordschleife + GP-Strecke
    final Path trackPath = _createNurburgringPath(scaleX, scaleY);

    // Desenha a borda externa (sombra/borda)
    final Paint borderPaint = Paint()
      ..color = trackBorderColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(trackPath, borderPaint);

    // Desenha a pista principal
    final Paint trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(trackPath, trackPaint);

    // Linha de chegada/partida
    if (showStartFinish) {
      final Paint startFinishPaint = Paint()
        ..color = startFinishColor
        ..style = PaintingStyle.fill;

      // Posição aproximada da linha de chegada (no GP-Strecke)
      canvas.drawCircle(
        Offset(75 * scaleX, 85 * scaleY),
        strokeWidth * 1.5,
        startFinishPaint,
      );
    }
  }

  Path _createNurburgringPath(double scaleX, double scaleY) {
    final Path path = Path();

    // Nürburgring - Forma característica do circuito
    // Iniciando do GP-Strecke (parte sul) e indo para Nordschleife

    // Start/Finish area (GP-Strecke sul)
    path.moveTo(75 * scaleX, 85 * scaleY);

    // GP-Strecke - primeira curva (Mercedes Arena)
    path.cubicTo(
      85 * scaleX,
      85 * scaleY,
      92 * scaleX,
      80 * scaleY,
      90 * scaleX,
      72 * scaleY,
    );

    // Subindo para Nordschleife
    path.cubicTo(
      88 * scaleX,
      65 * scaleY,
      85 * scaleX,
      58 * scaleY,
      80 * scaleX,
      52 * scaleY,
    );

    // Hocheichen
    path.cubicTo(
      75 * scaleX,
      46 * scaleY,
      78 * scaleX,
      40 * scaleY,
      82 * scaleX,
      35 * scaleY,
    );

    // Hatzenbach area
    path.cubicTo(
      86 * scaleX,
      30 * scaleY,
      90 * scaleX,
      25 * scaleY,
      88 * scaleX,
      18 * scaleY,
    );

    // Flugplatz
    path.cubicTo(
      86 * scaleX,
      12 * scaleY,
      80 * scaleX,
      8 * scaleY,
      72 * scaleX,
      6 * scaleY,
    );

    // Schwedenkreuz
    path.cubicTo(
      64 * scaleX,
      4 * scaleY,
      55 * scaleX,
      5 * scaleY,
      48 * scaleX,
      8 * scaleY,
    );

    // Fuchsröhre
    path.cubicTo(
      40 * scaleX,
      12 * scaleY,
      35 * scaleX,
      18 * scaleY,
      30 * scaleX,
      22 * scaleY,
    );

    // Adenauer Forst
    path.cubicTo(
      25 * scaleX,
      26 * scaleY,
      18 * scaleX,
      28 * scaleY,
      12 * scaleX,
      32 * scaleY,
    );

    // Metzgesfeld
    path.cubicTo(
      6 * scaleX,
      36 * scaleY,
      4 * scaleX,
      42 * scaleY,
      5 * scaleX,
      48 * scaleY,
    );

    // Kallenhard
    path.cubicTo(
      6 * scaleX,
      54 * scaleY,
      10 * scaleX,
      58 * scaleY,
      15 * scaleX,
      62 * scaleY,
    );

    // Wehrseifen
    path.cubicTo(
      20 * scaleX,
      66 * scaleY,
      18 * scaleX,
      72 * scaleY,
      15 * scaleX,
      76 * scaleY,
    );

    // Ex-Mühle
    path.cubicTo(
      12 * scaleX,
      80 * scaleY,
      14 * scaleX,
      85 * scaleY,
      20 * scaleX,
      88 * scaleY,
    );

    // Bergwerk
    path.cubicTo(
      26 * scaleX,
      91 * scaleY,
      32 * scaleX,
      90 * scaleY,
      38 * scaleX,
      86 * scaleY,
    );

    // Kesselchen
    path.cubicTo(
      44 * scaleX,
      82 * scaleY,
      48 * scaleX,
      78 * scaleY,
      52 * scaleX,
      80 * scaleY,
    );

    // Klostertal
    path.cubicTo(
      56 * scaleX,
      82 * scaleY,
      58 * scaleX,
      86 * scaleY,
      62 * scaleX,
      88 * scaleY,
    );

    // Voltando para GP-Strecke (fechando o circuito)
    path.cubicTo(
      66 * scaleX,
      90 * scaleY,
      70 * scaleX,
      88 * scaleY,
      75 * scaleX,
      85 * scaleY,
    );

    return path;
  }

  @override
  bool shouldRepaint(covariant NurburgringPainter oldDelegate) {
    return oldDelegate.trackColor != trackColor ||
        oldDelegate.trackBorderColor != trackBorderColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.showStartFinish != showStartFinish ||
        oldDelegate.startFinishColor != startFinishColor;
  }
}

/// Widget que exibe o circuito de Nürburgring
class NurburgringTrack extends StatelessWidget {
  final double? width;
  final double? height;
  final Color trackColor;
  final Color trackBorderColor;
  final double strokeWidth;
  final bool showStartFinish;
  final Color startFinishColor;

  const NurburgringTrack({
    super.key,
    this.width,
    this.height,
    this.trackColor = const Color(0xFF424242),
    this.trackBorderColor = Colors.white,
    this.strokeWidth = 4.0,
    this.showStartFinish = true,
    this.startFinishColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 300,
      height: height ?? 200,
      child: CustomPaint(
        painter: NurburgringPainter(
          trackColor: trackColor,
          trackBorderColor: trackBorderColor,
          strokeWidth: strokeWidth,
          showStartFinish: showStartFinish,
          startFinishColor: startFinishColor,
        ),
        size: Size(width ?? 300, height ?? 200),
      ),
    );
  }
}

/// Widget animado que mostra um carro percorrendo o circuito
class AnimatedNurburgringTrack extends StatefulWidget {
  final double? width;
  final double? height;
  final Color trackColor;
  final Color trackBorderColor;
  final double strokeWidth;
  final Duration lapDuration;
  final Color carColor;
  final double carSize;

  const AnimatedNurburgringTrack({
    super.key,
    this.width,
    this.height,
    this.trackColor = const Color(0xFF424242),
    this.trackBorderColor = Colors.white,
    this.strokeWidth = 4.0,
    this.lapDuration = const Duration(seconds: 8),
    this.carColor = Colors.red,
    this.carSize = 8.0,
  });

  @override
  State<AnimatedNurburgringTrack> createState() =>
      _AnimatedNurburgringTrackState();
}

class _AnimatedNurburgringTrackState extends State<AnimatedNurburgringTrack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.lapDuration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 300,
      height: widget.height ?? 200,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: AnimatedNurburgringPainter(
              trackColor: widget.trackColor,
              trackBorderColor: widget.trackBorderColor,
              strokeWidth: widget.strokeWidth,
              progress: _controller.value,
              carColor: widget.carColor,
              carSize: widget.carSize,
            ),
            size: Size(widget.width ?? 300, widget.height ?? 200),
          );
        },
      ),
    );
  }
}

/// Painter animado com carro percorrendo o circuito
class AnimatedNurburgringPainter extends NurburgringPainter {
  final double progress;
  final Color carColor;
  final double carSize;

  AnimatedNurburgringPainter({
    super.trackColor,
    super.trackBorderColor,
    super.strokeWidth,
    required this.progress,
    this.carColor = Colors.red,
    this.carSize = 8.0,
  }) : super(showStartFinish: false);

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    final double scaleX = size.width / 100;
    final double scaleY = size.height / 100;

    // Obtém o path do circuito
    final Path trackPath = _createNurburgringPath(scaleX, scaleY);

    // Calcula a posição do carro no caminho
    final pathMetrics = trackPath.computeMetrics().first;
    final pathLength = pathMetrics.length;
    final distance = pathLength * progress;

    final tangent = pathMetrics.getTangentForOffset(distance);
    if (tangent != null) {
      // Desenha o carro
      final Paint carPaint = Paint()
        ..color = carColor
        ..style = PaintingStyle.fill;

      // Sombra do carro
      final Paint shadowPaint = Paint()
        ..color = Colors.black.withAlpha((0.3 * 255).toInt())
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(
        tangent.position + const Offset(2, 2),
        carSize,
        shadowPaint,
      );

      canvas.drawCircle(tangent.position, carSize, carPaint);

      // Borda do carro
      final Paint carBorderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(tangent.position, carSize, carBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant AnimatedNurburgringPainter oldDelegate) {
    return super.shouldRepaint(oldDelegate) ||
        oldDelegate.progress != progress ||
        oldDelegate.carColor != carColor ||
        oldDelegate.carSize != carSize;
  }
}
