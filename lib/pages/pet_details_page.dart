import 'package:flutter/material.dart';

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
    final tagText = isResgatado ? 'RESGATADO' : 'PERDIDO';
    final tagColor = isResgatado ? Colors.purple : Colors.red;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Detalhes de $name'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 800;
          final horizontalPadding = isWide ? 32.0 : 16.0;
          final imageHeight = isWide ? 520.0 : 320.0;
          final titleSize = isWide ? 40.0 : 32.0;
          final sectionTitleSize = isWide ? 24.0 : 22.0;
          final descriptionSize = isWide ? 17.0 : 16.0;
          final buttonFontSize = isWide ? 18.0 : 16.0;

          final image = ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: imageHeight,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: imageHeight,
                  color: Colors.grey[300],
                  child: const Icon(Icons.pets, size: 100, color: Colors.grey),
                );
              },
            ),
          );

          final detailsContent = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tagText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                name,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.black54,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      local,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Text(
                'Sobre',
                style: TextStyle(
                  fontSize: sectionTitleSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: TextStyle(
                  fontSize: descriptionSize,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.message),
                  label: Text(
                    'Entrar em contato',
                    style: TextStyle(fontSize: buttonFontSize),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          );

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 24.0,
            ),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 1, child: image),
                      const SizedBox(width: 32),
                      Expanded(flex: 1, child: detailsContent),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      image,
                      const SizedBox(height: 24),
                      detailsContent,
                    ],
                  ),
          );
        },
      ),
    );
  }
}
