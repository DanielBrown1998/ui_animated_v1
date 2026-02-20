import 'package:flutter/material.dart';

/// Indicadores de carousel modernos com barras animadas
class ModernCarouselIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Color? activeColor;
  final Color? inactiveColor;
  final double activeWidth;
  final double inactiveWidth;
  final double height;
  final double spacing;
  final Duration animationDuration;
  final Curve animationCurve;
  final MainAxisAlignment alignment;

  const ModernCarouselIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.activeColor,
    this.inactiveColor,
    this.activeWidth = 32,
    this.inactiveWidth = 8,
    this.height = 4,
    this.spacing = 6,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutCubic,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = activeColor ?? theme.colorScheme.primary;
    final inactive = inactiveColor ?? Colors.white.withOpacity(0.3);

    return Row(
      mainAxisAlignment: alignment,
      children: List.generate(itemCount, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: animationDuration,
          curve: animationCurve,
          width: isActive ? activeWidth : inactiveWidth,
          height: height,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          decoration: BoxDecoration(
            color: isActive ? active : inactive,
            borderRadius: BorderRadius.circular(height / 2),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: active.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}

/// Indicadores com dots e números
class NumberedCarouselIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Color? activeColor;
  final TextStyle? textStyle;

  const NumberedCarouselIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.activeColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = activeColor ?? theme.colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: active.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Text(
                '${currentIndex + 1}',
                style:
                    textStyle?.copyWith(
                      color: active,
                      fontWeight: FontWeight.bold,
                    ) ??
                    TextStyle(
                      color: active,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
              ),
              Text(
                ' / $itemCount',
                style:
                    textStyle?.copyWith(color: Colors.white.withOpacity(0.5)) ??
                    TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Indicador com progress bar
class ProgressCarouselIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Color? activeColor;
  final Color? backgroundColor;
  final double width;
  final double height;
  final Duration animationDuration;

  const ProgressCarouselIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.activeColor,
    this.backgroundColor,
    this.width = 200,
    this.height = 3,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = activeColor ?? theme.colorScheme.primary;
    final bg = backgroundColor ?? Colors.white.withOpacity(0.2);
    final progress = (currentIndex + 1) / itemCount;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedContainer(
          duration: animationDuration,
          curve: Curves.easeOutCubic,
          width: width * progress,
          height: height,
          decoration: BoxDecoration(
            color: active,
            borderRadius: BorderRadius.circular(height / 2),
            boxShadow: [
              BoxShadow(color: active.withOpacity(0.5), blurRadius: 6),
            ],
          ),
        ),
      ),
    );
  }
}

/// Indicador com dots pulsantes
class PulsingDotsIndicator extends StatefulWidget {
  final int itemCount;
  final int currentIndex;
  final Color? activeColor;
  final Color? inactiveColor;
  final double size;
  final double spacing;

  const PulsingDotsIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.activeColor,
    this.inactiveColor,
    this.size = 10,
    this.spacing = 8,
  });

  @override
  State<PulsingDotsIndicator> createState() => _PulsingDotsIndicatorState();
}

class _PulsingDotsIndicatorState extends State<PulsingDotsIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = widget.activeColor ?? theme.colorScheme.primary;
    final inactive = widget.inactiveColor ?? Colors.white.withOpacity(0.3);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.itemCount, (index) {
        final isActive = index == widget.currentIndex;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: isActive ? _pulseAnimation.value : 1.0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: isActive ? active : inactive,
                    shape: BoxShape.circle,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: active.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
