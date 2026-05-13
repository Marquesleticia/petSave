import 'package:flutter/material.dart';
import 'package:pet_save/models/pet_card.dart';
import 'package:pet_save/pages/login_page.dart';
import 'package:pet_save/pages/pet_details_page.dart';
import 'package:pet_save/pages/pet_registration_page.dart';
import 'package:pet_save/utils/image_helpers.dart';
import 'package:pet_save/controllers/home_controller.dart';

// ── Paleta global ─────────────────────────────────
const _bg = Color(0xFF141210);
const _surface = Color(0xFF1F1C19);
const _orange = Color(0xFFF97316);
const _orangeSoft = Color(0x26F97316);
const _textPrimary = Color(0xFFF5F0EA);
const _textSecondary = Color(0xFF9E9589);
const _divider = Color(0xFF3E3933);

class PetSaveHomePage extends StatefulWidget {
  final String userName;
  const PetSaveHomePage({super.key, required this.userName});

  @override
  State<PetSaveHomePage> createState() => _PetSaveHomePageState();
}

class _PetSaveHomePageState extends State<PetSaveHomePage> {
  int _refreshToken = 0;

  void _refreshLists() {
    setState(() => _refreshToken++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopBar(userName: widget.userName),
              _HeroBanner(onPetSaved: _refreshLists),
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
              _UrgentPetsList(key: ValueKey('urgent_$_refreshToken')),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _RecentFeedList(key: ValueKey('recent_$_refreshToken')),
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
            child:
                const Text('Cancelar', style: TextStyle(color: _textSecondary)),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
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
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: _textPrimary,
                        letterSpacing: -0.5),
                  ),
                  TextSpan(
                    text: 'Save',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: _orange,
                        letterSpacing: -0.5),
                  ),
                ]),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 4, right: 12, top: 4, bottom: 4),
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
                            color: _textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
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
                    child: const Icon(Icons.logout_rounded,
                        color: _textSecondary, size: 20),
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
  final VoidCallback onPetSaved;
  const _HeroBanner({required this.onPetSaved});

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
              Image.network(
                'https://cdn.pixabay.com/photo/2018/03/31/06/31/dog-3277416_1280.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: const Color(0xFF2A2520)),
              ),
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
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: _orangeSoft,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _orange.withOpacity(0.5)),
                      ),
                      child: const Text(
                        '🐾  Juntos fazemos a diferença',
                        style: TextStyle(
                            color: _orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2),
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
                          Shadow(
                              color: Colors.black54,
                              blurRadius: 10,
                              offset: Offset(0, 2))
                        ],
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final saved = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PetRegistrationPage(),
                          ),
                        );
                        if (saved == true) {
                          onPetSaved();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pet cadastrado com sucesso!'),
                              backgroundColor: _orange,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.add_circle_outline, size: 18),
                      label: const Text('Novo Registro',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
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
                    color: iconColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2)),
            const SizedBox(height: 2),
            Text(title,
                style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800)),
          ],
        ),
      ],
    );
  }
}

// ── Urgent Pets List ──────────────────────────────
class _UrgentPetsList extends StatefulWidget {
  const _UrgentPetsList({super.key});

  @override
  State<_UrgentPetsList> createState() => _UrgentPetsListState();
}

class _UrgentPetsListState extends State<_UrgentPetsList> {
  late Future<List<PetCard>> _urgentPetsFuture;
  final HomeController _controller = HomeController();

  @override
  void initState() {
    super.initState();
    _urgentPetsFuture = _controller.getUrgentPets();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PetCard>>(
      future: _urgentPetsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator(color: _orange)));
        } else if (snapshot.hasError) {
          return SizedBox(
              height: 220,
              child: Center(
                  child: Text('Erro: ${snapshot.error}',
                      style: const TextStyle(color: Color(0xFFEF4444)))));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
              height: 220,
              child: Center(
                  child: Text('Nenhum pet perdido registrado.',
                      style: TextStyle(color: _textSecondary))));
        }
        final urgentPets = snapshot.data!;
        return SizedBox(
          height: 230,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: urgentPets.length,
            itemBuilder: (context, index) {
              final pet = urgentPets[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 20),
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
      },
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
    final badgeColor =
        isResgatado ? const Color(0xFF8B5CF6) : const Color(0xFFEF4444);
    final badgeLabel = isResgatado ? 'RESGATADO' : 'PERDIDO';

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PetDetailsPage(
            model: PetDetailsModel(
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
      ),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: _surface,
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(19)),
                  child: Image(
                    image: petImageProvider(imageUrl),
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 130,
                      color: const Color(0xFF2A2520),
                      child: const Icon(Icons.pets,
                          color: _textSecondary, size: 32),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(19)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent
                        ],
                        stops: const [0.0, 0.4],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.9),
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
                      const Icon(Icons.location_on_rounded,
                          size: 14, color: _textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(local,
                            style: const TextStyle(
                                fontSize: 12,
                                color: _textSecondary,
                                fontWeight: FontWeight.w500),
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

// ── Recent Feed List (Com Tabs integradas) ────────
class _RecentFeedList extends StatefulWidget {
  const _RecentFeedList({super.key});

  @override
  State<_RecentFeedList> createState() => _RecentFeedListState();
}

class _RecentFeedListState extends State<_RecentFeedList> {
  late Future<List<PetCard>> _recentPetsFuture;
  final HomeController _controller = HomeController();
  int _selectedIndex = 0; // 0 = Perdidos, 1 = Resgatados

  @override
  void initState() {
    super.initState();
    _recentPetsFuture = _controller.getAllPets();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PetCard>>(
      future: _recentPetsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator(color: _orange)),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
                child: Text('Erro: ${snapshot.error}',
                    style: const TextStyle(color: Color(0xFFEF4444)))),
          );
        } else if (!snapshot.hasData) {
          return const SizedBox();
        }
        final recentPets = snapshot.data!;
        final perdidos = recentPets.where((pet) => !pet.isResgatado).toList();
        final resgatados = recentPets.where((pet) => pet.isResgatado).toList();
        final listToDisplay = _selectedIndex == 0 ? perdidos : resgatados;

        return Column(
          children: [
            // ── Custom Tab Bar ──
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _divider),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedIndex = 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedIndex == 0
                              ? const Color(0xFFEF4444).withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border: _selectedIndex == 0
                              ? Border.all(
                                  color:
                                      const Color(0xFFEF4444).withOpacity(0.3))
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'Perdidos (${perdidos.length})',
                            style: TextStyle(
                              color: _selectedIndex == 0
                                  ? const Color(0xFFEF4444)
                                  : _textSecondary,
                              fontWeight: _selectedIndex == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedIndex = 1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedIndex == 1
                              ? const Color(0xFF8B5CF6).withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border: _selectedIndex == 1
                              ? Border.all(
                                  color:
                                      const Color(0xFF8B5CF6).withOpacity(0.3))
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'Resgatados (${resgatados.length})',
                            style: TextStyle(
                              color: _selectedIndex == 1
                                  ? const Color(0xFF8B5CF6)
                                  : _textSecondary,
                              fontWeight: _selectedIndex == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Lista Filtrada ──
            if (listToDisplay.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  _selectedIndex == 0
                      ? 'Nenhum pet perdido registrado no momento.'
                      : 'Nenhum pet resgatado registrado no momento.',
                  style: const TextStyle(color: _textSecondary),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Column(
                children: listToDisplay
                    .take(10)
                    .map((pet) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _FeedRow(pet: pet),
                        ))
                    .toList(),
              ),
          ],
        );
      },
    );
  }
}

// ── Feed Row ──────────────────────────────────────
class _FeedRow extends StatelessWidget {
  final PetCard pet;
  const _FeedRow({required this.pet});

  @override
  Widget build(BuildContext context) {
    final badgeColor =
        pet.isResgatado ? const Color(0xFF8B5CF6) : const Color(0xFFEF4444);

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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _divider.withOpacity(0.5)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image(
                image: petImageProvider(pet.imageUrl),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            size: 12, color: _textSecondary),
                        const SizedBox(width: 4),
                        Text(pet.timeAgo,
                            style: const TextStyle(
                                color: _textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w500)),
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
                    const Icon(Icons.location_on_rounded,
                        size: 14, color: _textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(pet.local,
                          style: const TextStyle(
                              fontSize: 13,
                              color: _textSecondary,
                              fontWeight: FontWeight.w500),
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
