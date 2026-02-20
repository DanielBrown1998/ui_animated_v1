import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Serviço singleton para pré-carregar e cachear assets
class AssetPreloader {
  AssetPreloader._();
  static final AssetPreloader instance = AssetPreloader._();

  // Cache de bytes dos arquivos GLB
  final Map<String, Uint8List> _glbCache = {};

  // Cache de ImageProvider para imagens
  final Map<String, ImageProvider> _imageCache = {};

  // Status de carregamento
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  // Progresso de carregamento (0.0 a 1.0)
  double _progress = 0.0;
  double get progress => _progress;

  // Stream controller para notificar progresso
  final _progressController = StreamController<double>.broadcast();
  Stream<double> get progressStream => _progressController.stream;

  // Lista de assets para pré-carregar
  static const List<String> carAssets = [
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

  /// Pré-carrega todos os assets necessários
  /// [preloadGlb] - se true, carrega os arquivos GLB em memória (usa mais RAM)
  /// [preloadImages] - se true, faz precache das imagens
  Future<void> preloadAssets({
    required BuildContext context,
    bool preloadGlb = false, // GLB são grandes, cuidado com memória
    bool preloadImages = true,
    int glbConcurrency = 2, // Quantos GLB carregar em paralelo
  }) async {
    if (_isLoaded) return;

    final totalAssets = carAssets.length * (preloadGlb ? 2 : 1);
    int loadedAssets = 0;

    void updateProgress() {
      loadedAssets++;
      _progress = loadedAssets / totalAssets;
      _progressController.add(_progress);
    }

    // 1. Pré-carregar imagens (thumbnails) - mais importante para UX
    if (preloadImages) {
      final imageFutures = carAssets.map((asset) async {
        try {
          final imageProvider = AssetImage('assets/thumbnails/$asset.webp');
          _imageCache[asset] = imageProvider;

          // Precache no Flutter para decodificação prévia
          if (context.mounted) {
            await precacheImage(imageProvider, context);
          }
          updateProgress();
        } catch (e) {
          debugPrint('Erro ao carregar imagem: $asset - $e');
          updateProgress();
        }
      });

      await Future.wait(imageFutures);
    }

    // 2. Pré-carregar GLBs em paralelo controlado (opcional)
    if (preloadGlb) {
      // Divide em batches para não sobrecarregar
      for (var i = 0; i < carAssets.length; i += glbConcurrency) {
        final batch = carAssets.skip(i).take(glbConcurrency);
        await Future.wait(
          batch.map((asset) => _loadGlb(asset, updateProgress)),
        );
      }
    }

    // 3. Pré-carregar imagem de background
    if (preloadImages && context.mounted) {
      try {
        await precacheImage(
          const AssetImage('assets/images/background.jpg'),
          context,
        );
      } catch (e) {
        debugPrint('Erro ao carregar background: $e');
      }
    }

    _isLoaded = true;
    _progressController.add(1.0);
  }

  /// Carrega um arquivo GLB em memória
  Future<void> _loadGlb(String asset, VoidCallback onComplete) async {
    try {
      final data = await rootBundle.load('assets/glb/$asset.glb');
      _glbCache[asset] = data.buffer.asUint8List();
      onComplete();
    } catch (e) {
      debugPrint('Erro ao carregar GLB: $asset - $e');
      onComplete();
    }
  }

  /// Retorna os bytes do GLB cacheado (se disponível)
  Uint8List? getCachedGlb(String asset) => _glbCache[asset];

  /// Retorna o ImageProvider cacheado (se disponível)
  ImageProvider? getCachedImage(String asset) => _imageCache[asset];

  /// Limpa o cache de GLBs para liberar memória
  void clearGlbCache() {
    _glbCache.clear();
  }

  /// Limpa todo o cache
  void clearAll() {
    _glbCache.clear();
    _imageCache.clear();
    _isLoaded = false;
    _progress = 0.0;
  }

  /// Fecha o stream controller
  void dispose() {
    _progressController.close();
  }
}

/// Extensão para facilitar o uso do preloader
extension AssetPreloaderExtension on BuildContext {
  AssetPreloader get assetPreloader => AssetPreloader.instance;
}
