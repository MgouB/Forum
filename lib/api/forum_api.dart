// lib/api/forum_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/forum_model.dart';

class ForumApi {
  final String baseUrl = "http://5728.s5.nuage-peda.fr/forum/api/forums";

  Future<List<ForumModel>> fetchForums() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      // On garde le header pour avoir le format JSON-LD
      headers: {'accept': 'application/ld+json'},
    );

    if (response.statusCode == 200) {
      // 1. On décode le JSON complet
      final Map<String, dynamic> data = jsonDecode(response.body);

      // 2. On extrait la liste qui se trouve dans la clé 'member' (ou 'hydra:member')
      // D'après ton JSON brut, c'est 'member'
      final List<dynamic> memberList =
          data['member'] ?? data['hydra:member'] ?? [];

      return memberList.map((item) => ForumModel.fromJson(item)).toList();
    } else {
      throw Exception(
        "Impossible de charger les forums (Code: ${response.statusCode})",
      );
    }
  }
}
