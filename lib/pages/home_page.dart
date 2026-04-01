import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:petSave/pages/pet_details_page.dart';
import 'package:petSave/widgets/feed_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetSaveHomePage extends StatelessWidget {
  const PetSaveHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Fundo em cinza bem claro
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeaderMenu(),
                const SizedBox(height: 32),
                const _HeroBanner(),
                const SizedBox(height: 32),
                const _SectionTitle(
                  title: 'Urgente: Perdidos',
                  icon: Icons.access_time,
                ),
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
            child: const Text(
              'Ver Animais Perdidos',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _UrgentPetsList extends StatefulWidget {
  const _UrgentPetsList({super.key});

  @override
  State<_UrgentPetsList> createState() => _UrgentPetsListState();
}

class _UrgentPetsListState extends State<_UrgentPetsList> {
  // Lista vazia que vai receber os dados do celular
  List<Map<String, dynamic>> urgentPets = [];

  @override
  void initState() {
    super.initState();
    _loadPetsLocally(); // Quando a tela abrir, ele busca os dados salvos
  }

  // ==========================================
  // FUNÇÃO 1: Carrega os dados do celular
  // ==========================================
  Future<void> _loadPetsLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final String? petsString = prefs.getString('saved_pets');
    if (petsString != null) {
      final List<dynamic> decodedList = jsonDecode(petsString);
      setState(() {
        urgentPets = List<Map<String, dynamic>>.from(decodedList);
      });
    } else {
      setState(() {
        urgentPets = [
          {
            'name': 'Rex (Exemplo)',
            'local': 'Sua Cidade',
            'imageUrl':
                'https://cdn.pixabay.com/photo/2016/02/19/15/46/dog-1210559_1280.jpg',
            'isResgatado': false,
          },
        ];
      });
    }
  }

  Future<void> addNewPet(Map<String, dynamic> newPet) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      urgentPets.insert(0, newPet); // Adiciona o novo pet no começo da lista
    });

    // Transforma a lista atualizada em texto (JSON) e salva no celular
    final String encodedList = jsonEncode(urgentPets);
    await prefs.setString('saved_pets', encodedList);
  }

  @override
  Widget build(BuildContext context) {
    // Se a lista estiver vazia, mostra um aviso
    if (urgentPets.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text('Nenhum pet registrado ainda.')),
      );
    }

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: urgentPets.length,
        itemBuilder: (context, index) {
          final pet = urgentPets[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: _PetCard(
              name: pet['name'],
              local: pet['local'],
              imageUrl: pet['imageUrl'],
              isResgatado: pet['isResgatado'],
            ),
          );
        },
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final String name;
  final String local;
  final String imageUrl;
  final bool isResgatado;

  const _PetCard({
    required this.name,
    required this.local,
    required this.imageUrl,
    this.isResgatado = false,
  });

  @override
  Widget build(BuildContext context) {
    // GestureDetector envolve o card para detectar o clique
    return GestureDetector(
      onTap: () {
        // Ao clicar, navega para a PetDetailsPage passando os dados do card
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetDetailsPage(
              name: name,
              isResgatado: isResgatado,
              local: local,
              imageUrl: imageUrl,
              description: isResgatado
                  ? 'Resgatei este pet próximo a $local. Ele está bem cuidado e aguardando o dono entrar em contato.'
                  : 'Meu pet $name fugiu próximo a $local. Ele é muito dócil, por favor, me ajude a encontrá-lo!',
            ),
          ),
        );
      },
      child: Container(
        width: 160,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.pets, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isResgatado ? Colors.purple : Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isResgatado ? 'RESGATADO' : 'PERDIDO',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        // Expanded aqui evita erro se o texto for muito grande
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentFeedList extends StatelessWidget {
  const _RecentFeedList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Padding(
          padding: EdgeInsets.only(bottom: 12.0),
          child: FeedCard(
            name: 'Bolinha',
            isResgatado: true,
            local: 'Parque Ibirapuera',
            timeAgo: '2 horas',
            imageUrl:
                'https://cdn.pixabay.com/photo/2016/12/13/05/15/puppy-1903313_1280.jpg',
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 12.0),
          child: FeedCard(
            name: 'Mia',
            isResgatado: false,
            local: 'Rua das Flores',
            timeAgo: '5 horas',
            imageUrl:
                'https://cdn.pixabay.com/photo/2014/11/30/14/11/cat-551554_1280.jpg',
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
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
