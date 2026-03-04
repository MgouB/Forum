class ForumModel {
  final int id;
  final String libelle;
  final String description;

  ForumModel({
    required this.id,
    required this.libelle,
    required this.description,
  });

  factory ForumModel.fromJson(Map<String, dynamic> json) {
    return ForumModel(
      // On prend l'id, s'il est nul on essaie d'extraire de @id
      id:
          json['id'] ??
          (json['@id'] != null ? int.parse(json['@id'].split('/').last) : 0),
      libelle: json['libelle'] ?? '',
      // Attention : ton JSON brut utilise "descriptions" avec un S
      description: json['descriptions'] ?? '',
    );
  }
}
