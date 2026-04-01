import 'package:flutter/material.dart';

class PetDetailsPage extends StatelessWidget {
  final String name;
  final bool isResgatado;
  final String local;
  final String imageUrl;
  final String description;

  const PetDetailsPage({
    Key? key,
    required this.name,
    required this.isResgatado,
    required this.local,
    required this.imageUrl,
    required this.description,
  }) : super(key: key);

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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.6, 
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 400,
                      color: Colors.grey[300],
                      child: const Icon(Icons.pets, size: 100, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(width: 32),
            Expanded(
              flex: 1, 
              child: SingleChildScrollView( 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: tagColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tagText,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Text(
                      name,
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.black54, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          local,
                          style: const TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    const Text(
                      'Sobre',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                    ),
                    const SizedBox(height: 40),
                    
                    SizedBox(
                      width: double.infinity, 
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          
                          print('Botão de contato clicado!');
                        },
                        icon: const Icon(Icons.message),
                        label: const Text('Entrar em contato', style: TextStyle(fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}