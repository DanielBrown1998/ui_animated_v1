import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:show_car/components/brand_colors.dart';
import 'package:show_car/components/cached_car_image.dart';
import 'package:show_car/components/car_card.dart';
import 'package:show_car/components/carousel_indicators.dart';
import 'package:show_car/components/garage_text.dart';
import 'package:show_car/models/car.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentCarIndex = 0;

  final List<String> carsDetails = [
    'bmw-m3_gtr_e46-2001-444hp-3.8s-2-I6_Twin_Turbo-Coupe_Sport-550Nm-300kmh',
    'bmw-m5_f90-2018-600hp-3.4s-4-V8_Twin_Turbo-Sedan_Sport-750Nm-305kmh',
    'chevrolet-camaro_zl1_1le-2019-650hp-3.5s-2-V8_Supercharged-Coupe_Sport-881Nm-290kmh',
    'dodge-charger_hellacious-1968-1000hp-3.0s-2-V8_Supercharged-Coupe_Muscle-1180Nm-320kmh',
    'ferrari-fxxk_evo-2018-1050hp-2.4s-2-V12_Hybrid-Coupe_Track-900Nm-350kmh',
    'mclaren-senna-2018-800hp-2.8s-2-V8_Twin_Turbo-Coupe_Track-800Nm-340kmh',
    'nissan-gtr_r35_nismo-2020-600hp-2.5s-2-V6_Twin_Turbo-Coupe_Sport-652Nm-315kmh',
    'nissan-gtr_r35_nismo_r3-2018-600hp-2.7s-2-V6_Twin_Turbo-Coupe_Race-652Nm-315kmh',
    'nissan-silvia_s15_spec_r-2000-250hp-5.5s-2-I4_Turbo-Coupe_Sport-275Nm-235kmh',
    'nissan-skyline_r34_gtr-1999-280hp-4.9s-2-I6_Twin_Turbo-Coupe_Sport-392Nm-250kmh',
    'porsche-911_gt2_rs-2018-700hp-2.7s-2-H6_Twin_Turbo-Coupe_Sport-750Nm-340kmh',
    'lamborghini-centenario_lp_770-2016-770hp-2.8s-2-V12-Coupe_Sport-690Nm-350kmh',
  ];
  late final List<Car> carsLists;
  late ValueNotifier<Car> currentCar;
  @override
  void initState() {
    super.initState();
    carsLists = List<Car>.generate(carsDetails.length, (index) {
      final allAttrs = carsDetails[index].split("-");
      final name = allAttrs[1].replaceAll("_", " ");
      return Car(
        asset: carsDetails[index],
        marca: allAttrs[0],
        name: name,
        year: int.parse(allAttrs[2]),
        horsePower: allAttrs[3],
        zeroToHundred: allAttrs[4],
        doors: int.parse(allAttrs[5]),
        engineType: EngineType.values.firstWhere(
          (e) => e.name == allAttrs[6].replaceAll("_", " "),
        ),
        carType: CarType.values.firstWhere(
          (e) => e.name == allAttrs[7].replaceAll("_", " "),
        ),
        torque: allAttrs[8],
        topSpeed: allAttrs[9],
      );
    });

    currentCar = ValueNotifier<Car>(carsLists[0]);
    currentCar.addListener(() {
      debugPrint("Current car changed: ${currentCar.value.name}");
    });
  }

  @override
  Widget build(BuildContext context) {
    final brandColor = BrandColors.getPrimary(currentCar.value.marca);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
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
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background glow effect
            Positioned(
              top: -100,
              right: -100,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      brandColor.withOpacity(0.3),
                      brandColor.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Modern App Bar
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  pinned: true,
                  expandedHeight: size.height * 0.45,
                  collapsedHeight: 120,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Car image (Hero built-in to AnimatedCachedCarImage)
                        AnimatedCachedCarImage(
                              assetName: currentCar.value.asset,
                            )
                            .animate(key: ValueKey(currentCar.value.asset))
                            .fadeIn(duration: 600.ms)
                            .scale(
                              begin: const Offset(0.95, 0.95),
                              end: const Offset(1, 1),
                              duration: 600.ms,
                              curve: Curves.easeOutCubic,
                            ),

                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                const Color(0xFF0D0D0D).withOpacity(0.8),
                                const Color(0xFF0D0D0D),
                              ],
                              stops: const [0.3, 0.7, 1.0],
                            ),
                          ),
                        ),

                        // Car name header
                        Positioned(
                          bottom: 20,
                          left: 24,
                          right: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 0.3),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                                child: GarageText.headline(
                                  currentCar.value.name.toUpperCase(),
                                  key: ValueKey(currentCar.value.name),
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                    shadows: [
                                      Shadow(
                                        color: brandColor.withOpacity(0.5),
                                        blurRadius: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _buildInfoChip(
                                    currentCar.value.horsePower,
                                    Icons.bolt_rounded,
                                    brandColor,
                                  ),
                                  _buildInfoChip(
                                    currentCar.value.zeroToHundred,
                                    Icons.timer_rounded,
                                    brandColor,
                                  ),
                                  _buildInfoChip(
                                    currentCar.value.topSpeed,
                                    Icons.speed_rounded,
                                    brandColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Carousel indicators
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ModernCarouselIndicator(
                          itemCount: carsLists.length,
                          currentIndex: _currentCarIndex,
                          activeColor: brandColor,
                        ),
                        const SizedBox(width: 16),
                        NumberedCarouselIndicator(
                          itemCount: carsLists.length,
                          currentIndex: _currentCarIndex,
                          activeColor: brandColor,
                        ),
                      ],
                    ),
                  ),
                ),

                // Car carousel
                SliverToBoxAdapter(
                  child: CarouselSlider.builder(
                    itemCount: carsLists.length,
                    itemBuilder: (context, index, realIndex) {
                      return CarCard(
                        car: carsLists[index],
                        isVisible: index == _currentCarIndex,
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: false,
                      enableInfiniteScroll: false,
                      scrollDirection: Axis.horizontal,
                      viewportFraction: 0.92,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.15,
                      height: 540,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentCarIndex = index;
                          currentCar.value = carsLists[index];
                        });
                      },
                    ),
                  ),
                ),

                // Bottom spacing
                const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String value, IconData icon, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              GarageText.label(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
