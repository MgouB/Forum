import 'package:flutter/material.dart';
import 'package:forum/api/message_api.dart';
import 'package:forum/model/message_model.dart';

class SujetScreen extends StatefulWidget {
  final int forumId;
  final String forumLibelle;

  const SujetScreen({
    super.key,
    required this.forumId,
    required this.forumLibelle,
  });

  @override
  State<SujetScreen> createState() => _SujetScreenState();
}

class _SujetScreenState extends State<SujetScreen> {
  late Future<List<MessageModel>> futureMessages;

  @override
  void initState() {
    super.initState();
    // On appelle ton API en lui passant l'ID du forum
    futureMessages = MessageApi().fetchMessages(widget.forumId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.forumLibelle)),
      body: FutureBuilder<List<MessageModel>>(
        future: futureMessages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Aucun message trouvé dans ce sujet.'),
            );
          }

          final messages = snapshot.data!;

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final m = messages[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ton code pour la date que tu voulais garder
                      Text(
                        "${m.postedAt.day.toString().padLeft(2, '0')}/"
                        "${m.postedAt.month.toString().padLeft(2, '0')}/"
                        "${m.postedAt.year} à "
                        "${m.postedAt.hour.toString().padLeft(2, '0')}:"
                        "${m.postedAt.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        m.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        m.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 10),
                      // Ton code pour l'auteur
                      Text(
                        "${m.userFirstName} ${m.userLastName}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
