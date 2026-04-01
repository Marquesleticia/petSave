import 'package:flutter/material.dart';
// Aqui importamos o widget que você separou em outro arquivo!
import 'package:petSave/widgets/feed_card.dart';

class PetSaveHomePage extends StatelessWidget {
  const PetSaveHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Fundo em cinza bem claro
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeaderMenu(),
                const SizedBox(height: 32),
                const _HeroBanner(),
                const SizedBox(height: 32),
                const _SectionTitle(title: 'Urgente: Perdidos', icon: Icons.access_time),
                const SizedBox(height: 16),
                const _UrgentPetsList(),
                const SizedBox(height: 32),
                const _SectionTitle(title: 'Feed Recente'),
                const SizedBox(height: 16),
                const _RecentFeedList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderMenu extends StatelessWidget {
  const _HeaderMenu();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.pets, color: Colors.orange, size: 28),
            const SizedBox(width: 8),
            const Text(
              'PetSave',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        // Menu e Botão (Adaptado para telas menores/mobile)
        Row(
          children: [
            const Text('Olá, Fulano', style: TextStyle(color: Colors.grey)),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Novo Registro'),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ajude a reunir pets com suas\nfamílias',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nossa comunidade trabalha junta para encontrar animais perdidos\ne dar um final feliz a cada história.',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Ver Animais Perdidos', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _UrgentPetsList extends StatelessWidget {
  const _UrgentPetsList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4, 
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: _PetCard(),
          );
        },
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  const _PetCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[300], 
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red, // Tag neutra
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: const Text('PERDIDO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nome do Pet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.location_on, size: 12, color: Colors.black54),
                    SizedBox(width: 4),
                    Text('Bairro, Cidade', style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentFeedList extends StatelessWidget {
  const _RecentFeedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Padding(
          padding: EdgeInsets.only(bottom: 12.0),
          child: FeedCard(
            name: 'Bolinha',
            isResgatado: true, // Usando a nomenclatura clara sugerida anteriormente
            local: 'Parque Ibirapuera',
            timeAgo: '2 horas',
            // NOVO: Passando uma URL real de exemplo
            imageUrl: 'https://cdn.pixabay.com/photo/2016/12/13/05/15/puppy-1903313_1280.jpg',
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 12.0),
          child: FeedCard(
            name: 'Mia',
            isResgatado: false,
            local: 'Rua das Flores',
            timeAgo: '5 horas',
            // NOVO: Outra URL de exemplo
            imageUrl: 'https://cdn.pixabay.com/photo/2014/11/30/14/11/cat-551554_1280.jpg',
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData? icon;

  const _SectionTitle({required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: Colors.black87, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }
}