import 'package:flutter/material.dart';
import 'package:pet_save/utils/image_helpers.dart';
import 'package:pet_save/models/pet_details_model.dart';
import 'package:pet_save/controllers/pet_details_controller.dart';

// Definição das cores usadas na página de detalhes
const _bg = Color(0xFF141210); // Cor de fundo escuro
const _surface = Color(0xFF1F1C19); // Cor da superfície
const _orange = Color(0xFFF97316); // Cor laranja para destaques
const _textPrimary = Color(0xFFF5F0EA); // Cor do texto principal
const _textSecondary = Color(0xFF9E9589); // Cor do texto secundário
const _whatsappGreen = Color(0xFF25D366); // Verde para botão de contato

// Página de detalhes do pet - exibe informações completas com layout responsivo
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

  @override
  Widget build(BuildContext context) {
    final details = _controller.petDetails;
    final loading = _controller.loading;
    final error = _controller.error;

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
                  child: Text(error, style: const TextStyle(color: Colors.red)),
                )
              : details == null
                  ? const SizedBox()
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 800;
                        final horizontalPadding = isWide ? 40.0 : 24.0;
                        final imageHeight = isWide ? 520.0 : 360.0;
                        final titleSize = isWide ? 40.0 : 32.0;
                        final sectionTitleSize = isWide ? 22.0 : 20.0;
                        final descriptionSize = isWide ? 17.0 : 15.0;
                        final buttonFontSize = isWide ? 16.0 : 15.0;

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
                            const SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Funcionalidade para contato via WhatsApp (implementar depois)
                                },
                                icon: const Icon(Icons.chat_bubble_rounded,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(flex: 5, child: image),
                                    const SizedBox(width: 40),
                                    Expanded(flex: 6, child: detailsContent),
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
