import 'dart:convert'; 


class MessageModel {
  // Identifiant unique du message
  final int id;
  // Titre du message
  final String title;
  // Contenu du message
  final String content;
  // Date et heure de publication du message
  final DateTime postedAt;
  // Nom de l’auteur du message
  final String userLastName;
  // Prénom de l’auteur du message
  final String userFirstName;
  // Identifiant du message parent s’il s’agit d’une réponse (peut être null)
  final int? parentId;
  // Constructeur principal : permet de créer un objet MessageModel
  MessageModel({
    required this.id,
    required this.title,
    required this.content,
    required this.postedAt,
    required this.userLastName,
    required this.userFirstName,
    this.parentId,
  });
  // Méthode usine (factory) permettant de créer un MessageModel
  // à partir d’une structure JSON reçue depuis l’API
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    // Récupère l’objet "user" dans le JSON, ou un objet vide si absent
    final user = json['user'] ?? {};
    return MessageModel(
      // Récupère l'id du message, ou 0 si non fourni
      id: json['id'] ?? 0,
      // Récupère le titre dans la clé API 'titre'
      title: json['titre'] ?? '',
      // Récupère le contenu dans la clé API 'contenu'
      content: json['contenu'] ?? '',
      // Convertit la chaîne 'datePoste' en objet DateTime
      postedAt: DateTime.parse(json['datePoste']),
      // Récupère le nom de l'auteur
      userLastName: user['nom'] ?? '',
      // Récupère le prénom de l'auteur
      userFirstName: user['prenom'] ?? '',
      // Si "parent" existe :
      // - on extrait son @id (ex : "/forum/api/messages/8")
      // - on récupère la dernière valeur : "8"
      // - et on le convertit en entier
      // Sinon, parentId = null
      parentId: json['parent'] != null
          ? int.parse(json['parent']['@id'].split('/').last)
          : null,
    );
  }
}
