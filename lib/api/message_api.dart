import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/message_model.dart';

class MessageApi {
  final String baseUrl = dotenv.env['API_BASE_URL']!;

  
  Future<List<MessageModel>> fetchMessages(int forumId) async {
    final url = "$baseUrl/messages?forum=$forumId";

    final response = await http.get(
      Uri.parse(url),
      headers: {'accept': 'application/ld+json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> members =
          data['member'] ?? data['hydra:member'] ?? [];
      return members.map((item) => MessageModel.fromJson(item)).toList();
    } else {
      throw Exception('Erreur HTTP ${response.statusCode}');
    }
  }
}
