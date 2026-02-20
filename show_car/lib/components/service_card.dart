import 'package:flutter/material.dart';
import 'package:show_car/components/garage_text.dart';
import 'package:show_car/models/car.dart';

/// Modelo que representa um serviço com seu asset
class ServiceAsset {
  final CarInteraction interaction;
  final String assetPath;
  final String displayName;

  const ServiceAsset({
    required this.interaction,
    required this.assetPath,
    required this.displayName,
  });
}

// =============================================================================
// SIMPLE FACTORY - Cria instâncias apropriadas baseado no tipo de asset
// =============================================================================

/// Factory para criar ServiceAsset a partir de CarInteraction
class ServiceAssetFactory {
  /// Mapeamento de CarInteraction para arquivos de assets (apenas webp)
  static const Map<CarInteraction, String> _assetMapping = {
    CarInteraction.power: 'assets/services/power.webp',
    CarInteraction.ecu: 'assets/services/ecu.webp',
    CarInteraction.tiresStatus: 'assets/services/tires.webp',
    CarInteraction.engineStatus: 'assets/services/engine.webp',
    CarInteraction.brakeStatus: 'assets/services/brake.webp',
    CarInteraction.remap: 'assets/services/remap.webp',
  };

  /// Cria um ServiceAsset a partir de um CarInteraction
  static ServiceAsset create(CarInteraction interaction) {
    final assetPath = _assetMapping[interaction]!;

    return ServiceAsset(
      interaction: interaction,
      assetPath: assetPath,
      displayName: interaction.name,
    );
  }

  /// Retorna todos os ServiceAssets disponíveis
  static List<ServiceAsset> getAllAvailable() {
    return _assetMapping.keys
        .map((interaction) => create(interaction))
        .toList();
  }
}

// =============================================================================
// SERVICE CARD WIDGET - Stateless para evitar problemas de renderização
// =============================================================================

/// Widget de card para exibir um serviço do carro
class ServiceCard extends StatelessWidget {
  final ServiceAsset service;
  final VoidCallback? onTap;
  final EdgeInsets margin;

  const ServiceCard({
    super.key,
    required this.service,
    this.onTap,
    this.margin = const EdgeInsets.all(8),
  });

  /// Factory constructor para criar a partir de CarInteraction
  factory ServiceCard.fromInteraction({
    Key? key,
    required CarInteraction interaction,
    VoidCallback? onTap,
    EdgeInsets margin = const EdgeInsets.all(8),
  }) {
    return ServiceCard(
      key: key,
      service: ServiceAssetFactory.create(interaction),
      onTap: onTap,
      margin: margin,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.deepOrange, width: 1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Positioned.fill(child: _buildContent()),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    // color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black12,
                        Colors.black26,
                        Colors.black38,
                        Colors.black45,
                        Colors.black54,
                        Colors.black87,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: GarageText(
                    service.displayName,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Image.asset(
      service.assetPath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Icon(
            Icons.build_circle_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
        );
      },
    );
  }
}
