import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:pet_save/controllers/pet_details_controller.dart';
import 'package:pet_save/models/pet_details_model.dart';
import 'package:pet_save/utils/image_helpers.dart';

// Definição das cores usadas na página de detalhes
const _bg             = Color(0xFF141210); // Cor de fundo escuro
const _surface        = Color(0xFF1F1C19); // Cor da superfície
const _orange         = Color(0xFFF97316); // Cor laranja para destaques
const _textPrimary    = Color(0xFFF5F0EA); // Cor do texto principal
const _textSecondary  = Color(0xFF9E9589); // Cor do texto secundário
const _whatsappGreen  = Color(0xFF25D366); // Verde para botão de contato

/// Página de detalhes do pet.
///
/// Exibe informações completas com layout responsivo e mapa OSM (RQ05)
/// quando coordenadas estão disponíveis.
class PetDetailsPage extends StatefulWidget {
  final PetDetailsModel model;
  const PetDetailsPage({super.key, required this.model});

  @override
  State<PetDetailsPage> createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  final PetDetailsController _controller = PetDetailsController();

  @override
  void initState() {
    super.initState();
    _controller.loadPetDetails(widget.model);
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  // ── RQ05 – Mapa OSM com marcador da localização do pet ───────────────────

  Widget _buildOsmMap(PetDetailsModel details) {
    final lat = details.latitude;
    final lng = details.longitude;

    // Sem coordenadas: exibe apenas o texto do endereço (fallback)
    if (lat == null || lng == null) return const SizedBox.shrink();

    final center = LatLng(lat, lng);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        const Divider(color: Color(0xFF2E2B27), thickness: 1, height: 1),
        const SizedBox(height: 24),
        Row(
          children: const [
            Icon(Icons.map_outlined, color: _orange, size: 20),
            SizedBox(width: 8),
            Text(
              'Local exato no mapa',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 260,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: center,
                initialZoom: 15,
                // Permite apenas pinch-to-zoom e pan – sem rotação
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom |
                      InteractiveFlag.drag |
                      InteractiveFlag.doubleTapZoom,
                ),
              ),
              children: [
                // Tiles OpenStreetMap (gratuito, sem chave de API – RQ05)
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.pet_save',
                ),
                // Marcador laranja da posição do pet
                MarkerLayer(
                  markers: [
                    Marker(
                      point: center,
                      width: 48,
                      height: 48,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _orange,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _orange.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.pets,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                // Atribuição obrigatória do OpenStreetMap
                const RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution('OpenStreetMap contributors'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Coordenadas: ${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}',
          style: const TextStyle(
            color: _textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final details = _controller.petDetails;
    final loading = _controller.loading;
    final error   = _controller.error;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text(
          'Detalhes',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: _bg,
        foregroundColor: _textPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: _orange),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: _orange))
          : error != null
              ? Center(
                  child: Text(error,
                      style: const TextStyle(color: Colors.red)),
                )
              : details == null
                  ? const SizedBox()
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 800;
                        final horizontalPadding = isWide ? 40.0 : 24.0;
                        final imageHeight     = isWide ? 520.0 : 360.0;
                        final titleSize       = isWide ? 40.0 : 32.0;
                        final sectionTitleSize = isWide ? 22.0 : 20.0;
                        final descriptionSize  = isWide ? 17.0 : 15.0;
                        final buttonFontSize   = isWide ? 16.0 : 15.0;

                        final badgeColor = details.isResgatado
                            ? const Color(0xFF8B5CF6)
                            : const Color(0xFFEF4444);
                        final tagText =
                            details.isResgatado ? 'RESGATADO' : 'PERDIDO';

                        final image = Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Hero(
                            tag: details.imageUrl,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image(
                                image: petImageProvider(details.imageUrl),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: imageHeight,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: double.infinity,
                                    height: imageHeight,
                                    color: _surface,
                                    child: const Icon(Icons.pets,
                                        size: 80, color: _textSecondary),
                                  );
                                },
                              ),
                            ),
                          ),
                        );

                        final detailsContent = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: badgeColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: badgeColor.withOpacity(0.4)),
                              ),
                              child: Text(
                                tagText,
                                style: TextStyle(
                                  color: badgeColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              details.name,
                              style: TextStyle(
                                fontSize: titleSize,
                                fontWeight: FontWeight.w900,
                                color: _textPrimary,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded,
                                    color: _orange, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    details.local,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: _textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            const Divider(
                                color: Color(0xFF2E2B27),
                                thickness: 1,
                                height: 1),
                            const SizedBox(height: 32),
                            Text(
                              'Sobre',
                              style: TextStyle(
                                fontSize: sectionTitleSize,
                                fontWeight: FontWeight.bold,
                                color: _textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              details.description,
                              style: TextStyle(
                                fontSize: descriptionSize,
                                color: const Color(0xFFD6D1CA),
                                height: 1.6,
                              ),
                            ),

                            // ── RQ05 – Mapa OSM (exibido quando há coordenadas)
                            _buildOsmMap(details),

                            const SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Funcionalidade para contato via WhatsApp
                                },
                                icon: const Icon(
                                    Icons.chat_bubble_rounded,
                                    size: 20),
                                label: Text(
                                  'Entrar em contato',
                                  style: TextStyle(
                                      fontSize: buttonFontSize,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _whatsappGreen,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );

                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: 16.0,
                          ),
                          child: isWide
                              ? Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Expanded(flex: 5, child: image),
                                    const SizedBox(width: 40),
                                    Expanded(
                                        flex: 6, child: detailsContent),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    image,
                                    const SizedBox(height: 28),
                                    detailsContent,
                                    const SizedBox(height: 40),
                                  ],
                                ),
                        );
                      },
                    ),
    );
  }
}
