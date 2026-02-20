import 'package:flutter/material.dart';
import 'package:show_car/models/car.dart';

class LogoMarca extends StatelessWidget {
  final Car car;

  const LogoMarca({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    debugPrint("Car: ${car.name}, Marca: ${car.marca}");
    return Hero(
      
      tag: car.name,
      child: Image.asset(
        "assets/icon/${car.marca}.png",
        fit: BoxFit.contain,
        cacheHeight: 50,
        cacheWidth: 50,
        width: 50,
        height: 50,
        filterQuality: FilterQuality.low,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }
}
