import 'package:flutter/material.dart';
import 'package:show_car/components/garage_text.dart';
import 'package:show_car/services/asset_preloader.dart';
import 'package:show_car/ui/home.dart';

/// Splash Screen com carregamento de assets
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  double _loadingProgress = 0.0;
  String _loadingMessage = 'Iniciando...';
  bool _isLoadingComplete = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();

    // Inicia o preload após o primeiro frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPreloading();
    });
  }

  Future<void> _startPreloading() async {
    final preloader = AssetPreloader.instance;

    // Escuta o progresso
    preloader.progressStream.listen((progress) {
      if (mounted) {
        setState(() {
          _loadingProgress = progress;
          _updateLoadingMessage(progress);
        });
      }
    });

    setState(() {
      _loadingMessage = 'Carregando imagens...';
    });

    // Faz o preload
    await preloader.preloadAssets(
      context: context,
      preloadImages: true,
      preloadGlb: false, // GLBs são grandes demais para pré-carregar todos
    );

    if (mounted) {
      setState(() {
        _isLoadingComplete = true;
        _loadingMessage = 'Pronto!';
      });

      // Pequeno delay para mostrar que completou
      await Future.delayed(const Duration(milliseconds: 500));

      // Navega para Home
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Home(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    }
  }

  void _updateLoadingMessage(double progress) {
    if (progress < 0.3) {
      _loadingMessage = 'Carregando imagens...';
    } else if (progress < 0.6) {
      _loadingMessage = 'Preparando galeria...';
    } else if (progress < 0.9) {
      _loadingMessage = 'Quase lá...';
    } else {
      _loadingMessage = 'Finalizando...';
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(scale: _scaleAnimation, child: child),
          );
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Ícone
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.deepOrange.shade400,
                        Colors.deepOrange.shade700,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrange.withAlpha((0.3 * 255).toInt()),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.directions_car,
                    size: 60,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 48),

                // Título
                const GarageText.headline(
                  'GARAGE',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 8,
                  ),
                ),

                const SizedBox(height: 8),

                GarageText.body(
                  'Premium Car Collection',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withAlpha((0.6 * 255).toInt()),
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 64),

                // Barra de progresso personalizada
                SizedBox(
                  width: 250,
                  child: Column(
                    children: [
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _loadingProgress,
                          minHeight: 6,
                          backgroundColor: Colors.white.withAlpha(
                            (0.1 * 255).toInt(),
                          ),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _isLoadingComplete
                                ? Colors.green
                                : Colors.deepOrange,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Porcentagem e mensagem
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GarageText.label(
                            _loadingMessage,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withAlpha(
                                (0.5 * 255).toInt(),
                              ),
                            ),
                          ),
                          GarageText.label(
                            '${(_loadingProgress * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withAlpha(
                                (0.7 * 255).toInt(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Indicador de loading animado
                if (!_isLoadingComplete)
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.deepOrange.withAlpha((0.6 * 255).toInt()),
                      ),
                    ),
                  )
                else
                  const Icon(Icons.check_circle, color: Colors.green, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
