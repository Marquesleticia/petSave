// Importações para UI e utilitários de imagem
import 'package:flutter/material.dart';
import 'package:pet_save/utils/image_helpers.dart';

// Widget para exibir um pet individual no feed com imagem, nome e status
class FeedCard extends StatelessWidget {
  // Dados do pet
  final String name; // Nome do pet
  final bool isResgatado; // Status (resgatado ou perdido)
  final String local; // Localização onde foi avistado
  final String timeAgo; // Tempo decorrido desde o registro
  final String imageUrl; // URL ou data URL da imagem do pet

  const FeedCard({
    super.key,
    required this.name,
    required this.isResgatado,
    required this.local,
    required this.timeAgo,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Define o texto e cor da badge baseado no status
    final tagText = isResgatado ? 'RESGATADO' : 'PERDIDO';
    final tagBackgroundColor = isResgatado ? Colors.purple : Colors.red;

    return Container(
      padding: const EdgeInsets.all(12),
      // Card com borda e sombra
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Seção de imagem do pet
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: Colors.grey[200],
              // Imagem com loading e error handling
              child: Image(
                image: petImageProvider(imageUrl),
                fit: BoxFit.cover,
                // Indicador de carregamento
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black54,
                      strokeWidth: 2,
                    ),
                  );
                },
                // Ícone padrão se a imagem não carregar
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.pets, color: Colors.grey, size: 40);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Seção de informações do pet
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Linha com nome e badge de status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Nome do pet
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Badge com status (Resgatado ou Perdido)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: tagBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tagText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Localização com ícone
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 12,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        local,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Tempo decorrido
                Text(
                  timeAgo,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
