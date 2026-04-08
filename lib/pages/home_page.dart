import 'package:flutter/material.dart';
// Importe seus arquivos reais aqui
import 'package:pet_save/models/pet_card.dart';
import 'package:pet_save/pages/login_page.dart';
import 'package:pet_save/pages/pet_details_page.dart';
import 'package:pet_save/services/postgres_service.dart';
import 'package:pet_save/widgets/feed_card.dart';

// ── Paleta global ─────────────────────────────────
const _bg = Color(0xFF141210);
const _surface = Color(0xFF1F1C19);
const _card = Color(0xFF272320);
const _orange = Color(0xFFF97316);
const _orangeSoft = Color(0x26F97316);
const _textPrimary = Color(0xFFF5F0EA);
const _textSecondary = Color(0xFF9E9589);
const _divider = Color(0xFF3E3933); // Clareado levemente para melhor contraste

class PetSaveHomePage extends StatelessWidget {
  final String userName;
  const PetSaveHomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // Scroll mais dinâmico
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopBar(userName: userName),
              const _HeroBanner(),
              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: _SectionHeader(
                  label: 'URGENTE',
                  title: 'Perdidos Agora',
                  icon: Icons.access_time_filled,
                  iconColor: Color(0xFFEF4444),
                ),
              ),
              const SizedBox(height: 16),
              const _UrgentPetsList(),
              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: _SectionHeader(
                  label: 'COMUNIDADE',
                  title: 'Feed Recente',
                  icon: Icons.dynamic_feed_rounded,
                  iconColor: _orange,
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: _RecentFeedList(),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Top Bar ───────────────────────────────────────
class _TopBar extends StatelessWidget {
  final String userName;
  const _TopBar({required this.userName});

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sair da conta',
            style: TextStyle(color: _textPrimary, fontWeight: FontWeight.bold)),
        content: const Text('Tem certeza que deseja sair?',
            style: TextStyle(color: _textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (r) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo com tipografia aprimorada
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_orange, Color(0xFFFF984A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: _orange.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.pets, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              RichText(
                text: const TextSpan(children: [
                  TextSpan(
                    text: 'Pet',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800, color: _textPrimary, letterSpacing: -0.5),
                  ),
                  TextSpan(
                    text: 'Save',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800, color: _orange, letterSpacing: -0.5),
                  ),
                ]),
              ),
            ],
          ),
          // Ações
          Row(
            children: [
              // Avatar + nome
              Container(
                padding: const EdgeInsets.only(left: 4, right: 12, top: 4, bottom: 4),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: _divider),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: _orangeSoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: _orange, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(userName,
                        style: const TextStyle(
                            color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Logout
              Tooltip(
                message: 'Sair',
                child: InkWell(
                  onTap: () => _logout(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _divider),
                    ),
                    child: const Icon(Icons.logout_rounded, color: _textSecondary, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Hero Banner ───────────────────────────────────
class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Foto de fundo
              Image.network(
                'https://cdn.pixabay.com/photo/2018/03/31/06/31/dog-3277416_1280.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: const Color(0xFF2A2520)),
              ),
              // Gradiente mais forte para legibilidade
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [Colors.transparent, Color(0xFF141210)],
                    stops: [0.1, 0.9],
                  ),
                ),
              ),
              // Conteúdo
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: _orangeSoft,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _orange.withOpacity(0.5)),
                      ),
                      child: const Text(
                        '🐾  Juntos fazemos a diferença',
                        style: TextStyle(
                            color: _orange, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Ajude a reunir\npets com suas\nfamílias',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        shadows: [
                          Shadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 2))
                        ],
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_circle_outline, size: 18),
                      label: const Text('Novo Registro',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        shadowColor: _orange.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section Header ────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  final String title;
  final IconData icon;
  final Color iconColor;

  const _SectionHeader({
    required this.label,
    required this.title,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: iconColor.withOpacity(0.2)),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: iconColor, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
            const SizedBox(height: 2),
            Text(title,
                style: const TextStyle(
                    color: _textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
          ],
        ),
      ],
    );
  }
}

// ── Urgent Pets List ──────────────────────────────
class _UrgentPetsList extends StatefulWidget {
  const _UrgentPetsList();

  @override
  State<_UrgentPetsList> createState() => _UrgentPetsListState();
}

class _UrgentPetsListState extends State<_UrgentPetsList> {
  List<PetCard> urgentPets = [];
  bool isLoading = true;
  String? errorMessage;
  final _petService = PostgresService();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final pets = await _petService.getPetCardsByType(false);
      if (!mounted) return;
      setState(() { urgentPets = pets; isLoading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { errorMessage = 'Erro: $e'; isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
          height: 220,
          child: Center(child: CircularProgressIndicator(color: _orange)));
    }
    if (errorMessage != null) {
      return SizedBox(
          height: 220,
          child: Center(
              child: Text(errorMessage!,
                  style: const TextStyle(color: Color(0xFFEF4444)))));
    }
    if (urgentPets.isEmpty) {
      return const SizedBox(
          height: 220,
          child: Center(
              child: Text('Nenhum pet perdido registrado.',
                  style: TextStyle(color: _textSecondary))));
    }
    return SizedBox(
      height: 230, // Altura ajustada para acomodar sombras maiores
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: urgentPets.length,
        itemBuilder: (context, index) {
          final pet = urgentPets[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 20), // Margem inferior para a sombra
            child: _PetCard(
              name: pet.name,
              local: pet.local,
              imageUrl: pet.imageUrl,
              isResgatado: pet.isResgatado,
            ),
          );
        },
      ),
    );
  }
}

// ── Pet Card ──────────────────────────────────────
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
    // Cores específicas solicitadas na sua paleta de preferências para as tags
    final badgeColor = isResgatado ? const Color(0xFF8B5CF6) : const Color(0xFFEF4444);
    final badgeLabel = isResgatado ? 'RESGATADO' : 'PERDIDO';

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PetDetailsPage(
            name: name,
            isResgatado: isResgatado,
            local: local,
            imageUrl: imageUrl,
            description: isResgatado
                ? 'Resgatei este pet próximo a $local. Ele está bem cuidado e aguardando o dono entrar em contato.'
                : 'Meu pet $name fugiu próximo a $local. Ele é muito dócil, por favor, me ajude a encontrá-lo!',
          ),
        ),
      ),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: _surface, // Fundo mais integrado
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem com Gradiente interno
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                  child: Image.network(
                    imageUrl,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 130,
                      color: const Color(0xFF2A2520),
                      child: const Icon(Icons.pets, color: _textSecondary, size: 32),
                    ),
                  ),
                ),
                // Degradê sobre a imagem para destacar a tag
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                        stops: const [0.0, 0.4],
                      ),
                    ),
                  ),
                ),
                // Badge Moderna
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.9), // Fundo vibrante
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: badgeColor.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(badgeLabel,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8)),
                  ),
                ),
              ],
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          color: _textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 14, color: _textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(local,
                            style: const TextStyle(fontSize: 12, color: _textSecondary, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
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

// ── Recent Feed List ──────────────────────────────
class _RecentFeedList extends StatefulWidget {
  const _RecentFeedList();

  @override
  State<_RecentFeedList> createState() => _RecentFeedListState();
}

class _RecentFeedListState extends State<_RecentFeedList> {
  List<PetCard> recentPets = [];
  bool isLoading = true;
  String? errorMessage;
  final _petService = PostgresService();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final pets = await _petService.getAllPetCards();
      if (!mounted) return;
      setState(() {
        recentPets = pets.length > 10 ? pets.sublist(0, 10) : pets;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { errorMessage = 'Erro: $e'; isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator(color: _orange)),
      );
    }
    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(child: Text(errorMessage!,
            style: const TextStyle(color: Color(0xFFEF4444)))),
      );
    }
    if (recentPets.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('Nenhum pet no feed ainda.',
            style: TextStyle(color: _textSecondary))),
      );
    }
    return Column(
      children: recentPets.map((pet) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _FeedRow(pet: pet),
      )).toList(),
    );
  }
}

// ── Feed Row ──────────────────────────────────────
class _FeedRow extends StatelessWidget {
  final PetCard pet;
  const _FeedRow({required this.pet});

  @override
  Widget build(BuildContext context) {
    final badgeColor = pet.isResgatado ? const Color(0xFF8B5CF6) : const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Foto com leve arredondamento e borda sutil
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _divider.withOpacity(0.5)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                pet.imageUrl,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 72,
                  height: 72,
                  color: const Color(0xFF2A2520),
                  child: const Icon(Icons.pets, color: _textSecondary),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: badgeColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        pet.isResgatado ? 'RESGATADO' : 'PERDIDO',
                        style: TextStyle(
                            color: badgeColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5),
                      ),
                    ),
                    // O tempo foi movido para cima para melhor alinhamento visual
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 12, color: _textSecondary),
                        const SizedBox(width: 4),
                        Text(pet.timeAgo,
                            style: const TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(pet.name,
                    style: const TextStyle(
                        color: _textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 14, color: _textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(pet.local,
                          style: const TextStyle(fontSize: 13, color: _textSecondary, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
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