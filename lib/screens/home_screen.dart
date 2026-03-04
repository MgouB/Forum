import 'package:flutter/material.dart';
import 'package:forum/api/message_api.dart';
import 'package:forum/model/message_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Future contenant la liste des messages chargés depuis l’API
  late Future<List<MessageModel>> futureMessages;

  @override
  void initState() {
    super.initState();
    futureMessages = MessageApi().fetchMessages();
  }

  void btAbout() {
    Navigator.pushNamed(context, '/register');
  }
  void btLogin() {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forum',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: btAbout,
            child: const Text(
              "S'inscrire",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: btLogin,
            child: const Text(
              "Se Connecter",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        elevation: 10.0,
        centerTitle: true,
      ),

      // Le corps de la page affiche maintenant la liste des messages
      body: FutureBuilder<List<MessageModel>>(
        future: futureMessages,
        builder: (context, snapshot) {
          // 1. Chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. Erreur
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          // 3. Pas de données
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun message trouvé.'));
          }
          // 4. On affiche la liste si tout est OK
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
                      // Date formatée
                      Text(
                        "${m.postedAt.day.toString().padLeft(2, '0')}/"
                        "${m.postedAt.month.toString().padLeft(2, '0')}/"
                        "${m.postedAt.year} à "
                        "${m.postedAt.hour.toString().padLeft(2, '0')}:"
                        "${m.postedAt.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 6),
                      // Titre du message (le sujet)
                      Text(
                        m.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Aperçu du contenu
                      Text(
                        m.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 10),
                      // Auteur
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
