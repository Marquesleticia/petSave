class PetCard {
  final int? id;
  final String name;
  final bool isResgatado;
  final String local;
  final String timeAgo;
  final String imageUrl;

  PetCard({
    this.id,
    required this.name,
    required this.isResgatado,
    required this.local,
    required this.timeAgo,
    required this.imageUrl,
  });

  // Converter para Map (para salvar no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isResgatado': isResgatado ? 1 : 0,
      'local': local,
      'timeAgo': timeAgo,
      'imageUrl': imageUrl,
    };
  }

  factory PetCard.fromMap(Map<String, dynamic> map) {
    return PetCard(
      id: map['id'],
      name: map['name'],
      isResgatado: map['isResgatado'] == 1,
      local: map['local'],
      timeAgo: map['timeAgo'],
      imageUrl: map['imageUrl'],
    );
  }

  // Copiar com algumas mudanças
  PetCard copyWith({
    int? id,
    String? name,
    bool? isResgatado,
    String? local,
    String? timeAgo,
    String? imageUrl,
  }) {
    return PetCard(
      id: id ?? this.id,
      name: name ?? this.name,
      isResgatado: isResgatado ?? this.isResgatado,
      local: local ?? this.local,
      timeAgo: timeAgo ?? this.timeAgo,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
