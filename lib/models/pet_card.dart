/// Modelo de dados que representa um pet no feed.
///
/// Mapeia a tabela [pet_cards] do Supabase.
/// O campo [isResgatado] determina o badge de exibição:
///   false → "PERDIDO" (vermelho) | true → "RESGATADO" (roxo)
class PetCard {
  final int? id;
  final String name;
  final bool isResgatado;
  final String local;
  final String timeAgo;
  final String imageUrl;

  const PetCard({
    this.id,
    required this.name,
    required this.isResgatado,
    required this.local,
    required this.timeAgo,
    required this.imageUrl,
  });

  /// Deserializa a resposta JSON do Supabase.
  ///
  /// Aceita tanto BOOLEAN nativo (Supabase padrão) quanto INTEGER legado (0/1).
  factory PetCard.fromMap(Map<String, dynamic> map) {
    final raw = map['isResgatado'] ?? false;
    return PetCard(
      id:          map['id'] as int?,
      name:        map['name'] as String,
      isResgatado: raw is bool ? raw : (raw as int) == 1,
      local:       map['local'] as String,
      timeAgo:     map['timeAgo'] as String? ?? '',
      imageUrl:    map['imageUrl'] as String? ?? '',
    );
  }

  /// Serializa para inserção via SDK Supabase.
  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name':        name,
        'isResgatado': isResgatado,
        'local':       local,
        'timeAgo':     timeAgo,
        'imageUrl':    imageUrl,
      };

  PetCard copyWith({
    int? id,
    String? name,
    bool? isResgatado,
    String? local,
    String? timeAgo,
    String? imageUrl,
  }) =>
      PetCard(
        id:          id          ?? this.id,
        name:        name        ?? this.name,
        isResgatado: isResgatado ?? this.isResgatado,
        local:       local       ?? this.local,
        timeAgo:     timeAgo     ?? this.timeAgo,
        imageUrl:    imageUrl    ?? this.imageUrl,
      );
}
