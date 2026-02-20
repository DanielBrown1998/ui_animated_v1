import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:show_car/ui/car_page.dart';
import 'package:show_car/components/brand_colors.dart';
import 'package:show_car/components/garage_text.dart';
import 'package:show_car/components/logo_marca.dart';
import 'package:show_car/models/car.dart';
import 'package:show_car/services/asset_preloader.dart';

class CarCard extends StatefulWidget {
  final Car car;
  final bool isVisible;
  const CarCard({super.key, required this.car, this.isVisible = true});

  @override
  State<CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  Car get car => widget.car;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final brandColor = BrandColors.getPrimary(car.marca);
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
        child: Container(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
          height: 520,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.12),
                      brandColor.withOpacity(0.08),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: brandColor.withOpacity(_isHovered ? 0.5 : 0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: brandColor.withOpacity(_isHovered ? 0.4 : 0.2),
                      blurRadius: _isHovered ? 40 : 25,
                      spreadRadius: -5,
                      offset: const Offset(0, 15),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gradient overlay no topo
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 120,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              brandColor.withOpacity(0.15),
                              Colors.transparent,
                            ],
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(28),
                          ),
                        ),
                      ),
                    ),

                    // Header com marca e ano
                    Positioned(
                      top: 24,
                      left: 24,
                      right: 24,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: GarageText.headline(
                                    car.marca.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      shadows: [
                                        Shadow(
                                          color: brandColor.withOpacity(0.5),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: brandColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: brandColor.withOpacity(0.3),
                                    ),
                                  ),
                                  child: GarageText.label(
                                    "${car.year} • ${car.horsePower}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: LogoMarca(car: car),
                          ),
                        ],
                      ),
                    ),

                    // Especificações com ícones
                    Positioned(
                      bottom: 100,
                      left: 24,
                      right: 24,
                      child: _buildSpecsGrid(brandColor),
                    ),

                    // Botão de detalhes moderno
                    Positioned(
                      bottom: 24,
                      left: 24,
                      right: 24,
                      child: _buildDetailsButton(context, brandColor, theme),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecsGrid(Color brandColor) {
    final specs = [
      _SpecItem(Icons.speed_rounded, 'Top Speed', car.topSpeed),
      _SpecItem(Icons.timer_rounded, '0-100', car.zeroToHundred),
      _SpecItem(Icons.local_fire_department_rounded, 'Torque', car.torque),
      _SpecItem(Icons.settings_rounded, 'Engine', car.engineType.name),
    ];

    return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Wrap(
            spacing: 16,
            runSpacing: 12,
            children: specs.map((spec) {
              return SizedBox(
                width: 140,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: brandColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(spec.icon, size: 18, color: brandColor),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GarageText.label(
                            spec.label,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GarageText.body(
                            spec.value,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        )
        .animate(delay: 200.ms)
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildDetailsButton(
    BuildContext context,
    Color brandColor,
    ThemeData theme,
  ) {
    return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openDetails(context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [brandColor, brandColor.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: brandColor.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  GarageText(
                    'Ver Detalhes',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate(delay: 300.ms)
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic)
        .then()
        .shimmer(
          duration: 2.seconds,
          color: Colors.white.withOpacity(0.2),
          delay: 1.seconds,
        );
  }

  void _openDetails(BuildContext context) {
    debugPrint("Tapped on ${car.name}");
    context.assetPreloader.getCachedGlb(car.asset);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CarDetailPage(car: car),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.05),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}

class _SpecItem {
  final IconData icon;
  final String label;
  final String value;

  _SpecItem(this.icon, this.label, this.value);
}
