// Importações para UI e utilitários de imagem
import 'package:flutter/material.dart';
import 'package:pet_save/utils/image_helpers.dart';

// Definição das cores usadas na página de detalhes
const _bg = Color(0xFF141210); // Cor de fundo escuro
const _surface = Color(0xFF1F1C19); // Cor da superfície
const _orange = Color(0xFFF97316); // Cor laranja para destaques
const _textPrimary = Color(0xFFF5F0EA); // Cor do texto principal
const _textSecondary = Color(0xFF9E9589); // Cor do texto secundário
const _whatsappGreen = Color(0xFF25D366); // Verde para botão de contato

// Página de detalhes do pet - exibe informações completas com layout responsivo
class PetDetailsPage extends StatelessWidget {
  // Dados do pet passados por parâmetro
  final String name; // Nome do pet
  final bool isResgatado; // Status (resgatado ou perdido)
  final String local; // Localização do pet
  final String imageUrl; // URL ou data URL da imagem
  final String description; // Descrição detalhada do pet

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
    // Define a cor da badge e texto baseado no status
    final badgeColor =
        isResgatado ? const Color(0xFF8B5CF6) : const Color(0xFFEF4444);
    final tagText = isResgatado ? 'RESGATADO' : 'PERDIDO';

    return Scaffold(
      backgroundColor: _bg,
      // Barra superior com título
      appBar: AppBar(
        title: Text(
          'Detalhes',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: _bg,
        foregroundColor: _textPrimary,
        elevation: 0,
        centerTitle: true,
        // Seta de voltar em laranja
        iconTheme: const IconThemeData(color: _orange),
      ),
      // Layout responsivo que se adapta a diferentes tamanhos de tela
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Detecta se a tela é grande (tablet/desktop)
          final isWide = constraints.maxWidth >= 800;
          // Calcula dimensões responsivas
          final horizontalPadding = isWide ? 40.0 : 24.0;
          final imageHeight = isWide ? 520.0 : 360.0;
          final titleSize = isWide ? 40.0 : 32.0;
          final sectionTitleSize = isWide ? 22.0 : 20.0;
          final descriptionSize = isWide ? 17.0 : 15.0;
          final buttonFontSize = isWide ? 16.0 : 15.0;

          // Widget da imagem com animação Hero
          final image = Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              // Sombra para destaque
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            // Hero animation: transição suave ao voltar para a lista
            child: Hero(
              tag: imageUrl,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image(
                  image: petImageProvider(imageUrl),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: imageHeight,
                  // Ícone padrão se a imagem não carregar
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

          // Widget com o conteúdo dos detalhes
          final detailsContent = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge com status (Resgatado/Perdido)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

              // Nome do pet
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

              // Localização com ícone
              Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      color: _orange, size: 20),
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

              // Divisor entre seções
              const Divider(color: Color(0xFF2E2B27), thickness: 1, height: 1),
              const SizedBox(height: 32),

              // Seção "Sobre"
              Text(
                'Sobre',
                style: TextStyle(
                  fontSize: sectionTitleSize,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              // Descrição detalhada do pet
              Text(
                description,
                style: TextStyle(
                  fontSize: descriptionSize,
                  color: const Color(0xFFD6D1CA),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 40),

              // Botão para entrar em contato via WhatsApp
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Funcionalidade para contato via WhatsApp (implementar depois)
                  },
                  icon: const Icon(Icons.chat_bubble_rounded, size: 20),
                  label: Text(
                    'Entrar em contato',
                    style: TextStyle(
                        fontSize: buttonFontSize, fontWeight: FontWeight.bold),
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

          // Layout responsivo: lado a lado em telas largas, coluna em telas pequenas
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16.0,
            ),
            child: isWide
                // Layout para tablets/desktop: imagem à esquerda, detalhes à direita
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: image),
                      const SizedBox(width: 40),
                      Expanded(flex: 6, child: detailsContent),
                    ],
                  )
                // Layout para celulares: imagem acima, detalhes abaixo
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
