import 'package:flutter/material.dart';

class FeedCard extends StatelessWidget {
  final String name;
  final bool isResgatado; // Nossa nova variável para a regra de negócio
  final String local;
  final String timeAgo;
  final String imageUrl; // A URL da imagem que vem da internet

  const FeedCard({
    Key? key,
    required this.name,
    required this.isResgatado,
    required this.local,
    required this.timeAgo,
    required this.imageUrl, // Tornamos o envio da imagem obrigatório
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tagText = isResgatado ? 'RESGATADO' : 'PERDIDO';
    
    // 2. A cor de fundo muda conforme o status (Roxo para resgatado, Vermelho para perdido)
    final tagBackgroundColor = isResgatado ? Colors.purple : Colors.red; 
    
    // 3. A cor do texto precisa ser branca para dar leitura (contraste) em cima de cores fortes
    final tagTextColor = Colors.white; 

    // A descrição muda dinamicamente de acordo com o booleano
    final description = isResgatado
        ? 'Resgatei este pet em $local. Ele está seguro comigo, procuro o tutor!'
        : 'Meu pet fugiu próximo a $local. Por favor, me ajude a encontrá-lo!';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), 
            blurRadius: 10, 
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          
          // ==========================================
          // ESPAÇO DA IMAGEM
          // ==========================================
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: Colors.grey[200], // Fundo neutro enquanto a imagem não aparece
              child: Image.network(
                imageUrl, // Aqui o Flutter vai buscar a imagem na internet
                fit: BoxFit.cover, // Garante que a foto preencha o quadrado sem amassar
                
                // Exibe uma rodinha de carregamento cinza enquanto baixa a imagem
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black54, 
                      strokeWidth: 2,
                    ),
                  );
                },
                
                // Se o link da imagem estiver quebrado, mostra um ícone de patinha
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.pets, color: Colors.grey, size: 40);
                },
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // ==========================================
          // TEXTOS DO CARD
          // ==========================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name, 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                    ),
                    // Tag Visual (Perdido ou Resgatado)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: tagBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tagText,
                        style: TextStyle(
                          color: tagTextColor, 
                          fontSize: 10, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Descrição do caso
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Tempo
                Text(
                  'Há $timeAgo', 
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}