import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:show_car/components/brand_colors.dart';
import 'package:show_car/components/cached_car_image.dart';
import 'package:show_car/components/garage_text.dart';
import 'package:show_car/components/glass_card.dart';
import 'package:show_car/components/logo_marca.dart';
import 'package:show_car/components/nurburgring_painter.dart';
import 'package:show_car/components/service_card.dart';
import 'package:show_car/models/car.dart';

class CarDetailPage extends StatefulWidget {
  final Car car;
  const CarDetailPage({super.key, required this.car});

  @override
  State<CarDetailPage> createState() => _CarDetailPageState();
}

class _CarDetailPageState extends State<CarDetailPage> {
  bool _is3DModelLoaded = false;
  bool _show3DModel = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final brandColor = BrandColors.getPrimary(widget.car.marca);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0D0D0D),
              const Color(0xFF1A1A1A),
              brandColor.withOpacity(0.1),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background glow
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      brandColor.withOpacity(0.4),
                      brandColor.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Modern SliverAppBar
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  pinned: true,
                  expandedHeight: size.height * 0.5,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GlassCard(
                      borderRadius: 12,
                      blur: 10,
                      padding: EdgeInsets.zero,
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Car image (Hero built-in to AnimatedCachedCarImage)
                        AnimatedCachedCarImage(assetName: widget.car.asset),

                        // Animated track overlay
                        // Positioned.fill(
                        //   child: AnimatedTrack(
                        //     durationLap: const Duration(
                        //       minutes: 6,
                        //       seconds: 12,
                        //       milliseconds: 532,
                        //     ),
                        //     brandColor: brandColor,
                        //   ),
                        // ),

                        // Gradient overlay
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 200,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  const Color(0xFF0D0D0D).withOpacity(0.9),
                                  const Color(0xFF0D0D0D),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Car info header
                        Positioned(
                          bottom: 24,
                          left: 24,
                          right: 24,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: brandColor.withOpacity(0.3),
                                  ),
                                ),
                                child: LogoMarca(car: widget.car),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: GarageText.headline(
                                        widget.car.name.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          letterSpacing: 1.5,
                                          shadows: [
                                            Shadow(
                                              color: brandColor.withOpacity(
                                                0.5,
                                              ),
                                              blurRadius: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    GarageText.label(
                                      '${widget.car.marca.toUpperCase()} • ${widget.car.year}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Specs section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: _buildSpecsSection(brandColor),
                  ),
                ),

                // 3D Model Viewer Section Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child:
                        Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: brandColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GarageText.headline(
                                  'Visualização 3D',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const Spacer(),
                                GlassCard(
                                  borderRadius: 12,
                                  blur: 10,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _show3DModel = !_show3DModel;
                                    });
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _show3DModel
                                            ? Icons.view_in_ar_rounded
                                            : Icons.view_in_ar_outlined,
                                        color: brandColor,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      GarageText.label(
                                        _show3DModel ? 'Ocultar' : 'Exibir',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                            .animate()
                            .fadeIn(delay: 300.ms)
                            .slideX(
                              begin: -0.1,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),
                  ),
                ),

                // 3D Model Viewer
                SliverToBoxAdapter(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    child: _show3DModel
                        ? Padding(
                            padding: const EdgeInsets.all(24),
                            child: _build3DViewerSection(brandColor, size),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),

                // Services header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child:
                        Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: brandColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GarageText.headline(
                                  'Serviços Disponíveis',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .slideX(
                              begin: -0.1,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),
                  ),
                ),

                const SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),

                // Services carousel
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: size.height * 0.28,
                    child: CarouselServices(brandColor: brandColor),
                  ),
                ),

                const SliverPadding(padding: EdgeInsets.only(bottom: 48)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecsSection(Color brandColor) {
    final specs = [
      _SpecData(Icons.bolt_rounded, 'Potência', widget.car.horsePower),
      _SpecData(Icons.timer_rounded, '0-100 km/h', widget.car.zeroToHundred),
      _SpecData(Icons.speed_rounded, 'Velocidade Máx', widget.car.topSpeed),
      _SpecData(
        Icons.local_fire_department_rounded,
        'Torque',
        widget.car.torque,
      ),
      _SpecData(Icons.settings_rounded, 'Motor', widget.car.engineType.name),
      _SpecData(Icons.directions_car_rounded, 'Tipo', widget.car.carType.name),
    ];

    return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    brandColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: brandColor.withOpacity(0.2)),
              ),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: specs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final spec = entry.value;
                  return SizedBox(
                        width: 150,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: brandColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                spec.icon,
                                size: 20,
                                color: brandColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GarageText.label(
                                    spec.label,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white.withOpacity(0.5),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  GarageText.body(
                                    spec.value,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate(delay: Duration(milliseconds: 100 * index))
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic);
                }).toList(),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 100.ms)
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          curve: Curves.easeOutCubic,
        );
  }

  Widget _build3DViewerSection(Color brandColor, Size size) {
    return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: size.height * 0.45,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    brandColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: brandColor.withOpacity(0.2)),
              ),
              child: Stack(
                children: [
                  // 3D Model Viewer
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: ModelViewer(
                      src: 'assets/glb/${widget.car.asset}.glb',
                      alt: '${widget.car.marca} ${widget.car.name} 3D Model',
                      ar: true,
                      arModes: const ['scene-viewer', 'webxr', 'quick-look'],
                      autoRotate: true,
                      autoRotateDelay: 1000,
                      rotationPerSecond: '30deg',
                      cameraControls: true,
                      disableZoom: false,
                      backgroundColor: Colors.transparent,
                      loading: Loading.eager,
                      reveal: Reveal.auto,
                      onWebViewCreated: (controller) {
                        // Model viewer is ready
                        Future.delayed(const Duration(milliseconds: 1500), () {
                          if (mounted && !_is3DModelLoaded) {
                            setState(() {
                              _is3DModelLoaded = true;
                            });
                          }
                        });
                      },
                    ),
                  ),

                  // Loading overlay
                  if (!_is3DModelLoaded)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                color: brandColor,
                                strokeWidth: 3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            GarageText.label(
                              'Carregando modelo 3D...',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // AR Button overlay
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: GlassCard(
                      borderRadius: 16,
                      blur: 10,
                      padding: const EdgeInsets.all(12),
                      gradientColors: [
                        brandColor.withOpacity(0.3),
                        brandColor.withOpacity(0.1),
                      ],
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.view_in_ar_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          GarageText.label(
                            'Ver em AR',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Gesture hint
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.touch_app_rounded,
                            color: Colors.white.withOpacity(0.7),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          GarageText.label(
                            'Arraste para girar',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
  }
}

class _SpecData {
  final IconData icon;
  final String label;
  final String value;

  _SpecData(this.icon, this.label, this.value);
}

class AnimatedTrack extends StatefulWidget {
  final Duration durationLap;
  final Color? brandColor;
  const AnimatedTrack({super.key, required this.durationLap, this.brandColor});

  @override
  State<AnimatedTrack> createState() => _AnimatedTrackState();
}

class _AnimatedTrackState extends State<AnimatedTrack> {
  @override
  Widget build(BuildContext context) {
    final color = widget.brandColor ?? Theme.of(context).colorScheme.primary;
    return AnimatedNurburgringTrack(
      carColor: color,
      height: 500,
      width: double.infinity,
      trackColor: color.withOpacity(0.15),
      lapDuration: widget.durationLap,
    ).animate().fadeIn(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }
}

class CarouselServices extends StatefulWidget {
  final Color brandColor;
  const CarouselServices({super.key, required this.brandColor});

  @override
  State<CarouselServices> createState() => _CarouselServicesState();
}

class _CarouselServicesState extends State<CarouselServices> {
  @override
  Widget build(BuildContext context) {
    final availableServices = ServiceAssetFactory.getAllAvailable();
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
        autoPlayCurve: Curves.easeOutCubic,
        enlargeCenterPage: true,
        enlargeFactor: 0.2,
        viewportFraction: 0.7,
      ),
      items: List.generate(availableServices.length, (index) {
        return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        widget.brandColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: widget.brandColor.withOpacity(0.2),
                    ),
                  ),
                  child: ServiceCard(
                    service: availableServices[index],
                    margin: EdgeInsets.zero,
                  ),
                ),
              ),
            )
            .animate(delay: Duration(milliseconds: 100 * index))
            .fadeIn(duration: 400.ms)
            .scale(
              begin: const Offset(0.9, 0.9),
              end: const Offset(1, 1),
              curve: Curves.easeOutCubic,
            );
      }),
    );
  }
}
