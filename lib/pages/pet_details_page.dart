import 'package:flutter/material.dart';

// ── Paleta global (Consistência com a Home Page) ──
const _bg = Color(0xFF141210);
const _surface = Color(0xFF1F1C19);
const _orange = Color(0xFFF97316);
const _textPrimary = Color(0xFFF5F0EA);
const _textSecondary = Color(0xFF9E9589);
const _whatsappGreen = Color(0xFF25D366); // Verde moderno para contato

class PetDetailsPage extends StatelessWidget {
  final String name;
  final bool isResgatado;
  final String local;
  final String imageUrl;
  final String description;

  const PetDetailsPage({
    super.key,
    required this.name,
    required this.isResgatado,
    required this.local,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    // Mantendo a regra de cores das tags
    final badgeColor = isResgatado ? const Color(0xFF8B5CF6) : const Color(0xFFEF4444);
    final tagText = isResgatado ? 'RESGATADO' : 'PERDIDO';

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: Text(
          'Detalhes',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: _bg,
        foregroundColor: _textPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: _orange), // Seta de voltar laranja
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 800;
          final horizontalPadding = isWide ? 40.0 : 24.0;
          final imageHeight = isWide ? 520.0 : 360.0;
          final titleSize = isWide ? 40.0 : 32.0;
          final sectionTitleSize = isWide ? 22.0 : 20.0;
          final descriptionSize = isWide ? 17.0 : 15.0;
          final buttonFontSize = isWide ? 16.0 : 15.0;

          // Extraímos a imagem para aplicar o Hero Animation e sombras
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
            // O Hero faz a imagem transicionar suavemente da tela anterior
            child: Hero(
              tag: imageUrl, // Esta tag precisa ser igual à da tela anterior
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: imageHeight,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: imageHeight,
                      color: _surface,
                      child: const Icon(Icons.pets, size: 80, color: _textSecondary),
                    );
                  },
                ),
              ),
            ),
          );

          final detailsContent = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tag Roxo/Vermelho com estilo moderno
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: badgeColor.withOpacity(0.4)),
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
                name,
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
                  const Icon(Icons.location_on_rounded, color: _orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      local,
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

              // Separador sutil
              const Divider(color: Color(0xFF2E2B27), thickness: 1, height: 1),
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
                description,
                style: TextStyle(
                  fontSize: descriptionSize,
                  color: const Color(0xFFD6D1CA), // Um tom um pouco mais claro que o secondary
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 40),

              // Botão de Contato
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Lógica de contato futuramente aqui
                  },
                  icon: const Icon(Icons.chat_bubble_rounded, size: 20),
                  label: Text(
                    'Entrar em contato',
                    style: TextStyle(fontSize: buttonFontSize, fontWeight: FontWeight.bold),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      image,
                      const SizedBox(height: 28),
                      detailsContent,
                      const SizedBox(height: 40), // Espaço extra no final para não colar na borda
                    ],
                  ),
          );
        },
      ),
    );
  }
}