// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:show_car/models/car.dart';

class Car3dViewer extends StatefulWidget {
  final Car car;
  final Flutter3DController? controller;
  final void Function(String)? onLoad;
  const Car3dViewer({
    super.key,
    required this.car,
    this.controller,
    this.onLoad,
  });

  @override
  State<Car3dViewer> createState() => _Car3dViewerState();
}

class _Car3dViewerState extends State<Car3dViewer> {
  late final Flutter3DController _controller;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? Flutter3DController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Flutter3DViewer(
      key: ValueKey(widget.car.asset),
      controller: _controller,
      src: "assets/glb/${widget.car.asset}.glb",
      enableTouch: true,
      progressBarColor: theme.colorScheme.primary,
      onLoad: widget.onLoad,
    );
  }
}
