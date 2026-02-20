import 'package:flutter/material.dart';
import 'package:show_car/services/asset_preloader.dart';

/// Widget de imagem otimizada que usa o cache do AssetPreloader
class CachedCarImage extends StatelessWidget {
  final String assetName;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;
  final Widget? placeholder;

  const CachedCarImage({
    super.key,
    required this.assetName,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.errorBuilder,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    // Tenta usar imagem do cache
    final cachedImage = AssetPreloader.instance.getCachedImage(assetName);

    if (cachedImage != null) {
      return Image(
        image: cachedImage,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: errorBuilder,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return child;
          }
          return placeholder ??
              Container(width: width, height: height, color: Colors.grey[900]);
        },
      );
    }

    // Fallback para carregamento normal
    return Image.asset(
      'assets/thumbnails/$assetName.webp',
      fit: fit,
      width: width,
      height: height,
      errorBuilder: errorBuilder,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        return placeholder ??
            Container(width: width, height: height, color: Colors.grey[900]);
      },
    );
  }
}

/// Widget de imagem com fade-in animado
class AnimatedCachedCarImage extends StatefulWidget {
  final String assetName;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Duration fadeDuration;

  const AnimatedCachedCarImage({
    super.key,
    required this.assetName,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.fadeDuration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedCachedCarImage> createState() => _AnimatedCachedCarImageState();
}

class _AnimatedCachedCarImageState extends State<AnimatedCachedCarImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.fadeDuration,
    );

    // Se já está no cache, considera carregado
    if (AssetPreloader.instance.getCachedImage(widget.assetName) != null) {
      _isLoaded = true;
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onImageLoaded() {
    if (!_isLoaded && mounted) {
      _isLoaded = true;
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cachedImage = AssetPreloader.instance.getCachedImage(
      widget.assetName,
    );

    return Hero(
      tag: widget.assetName,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(opacity: _controller.value, child: child);
        },
        child: Image(
          filterQuality: FilterQuality.medium,
          image:
              cachedImage ??
              AssetImage('assets/thumbnails/${widget.assetName}.webp'),
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (frame != null || wasSynchronouslyLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _onImageLoaded();
              });
            }
            return child;
          },
          errorBuilder: (context, error, stackTrace) => Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey[900],
            child: const Icon(Icons.error, color: Colors.white54),
          ),
        ),
      ),
    );
  }
}
