import 'package:flutter/material.dart';
import 'package:forum/api/forum_api.dart';
import 'package:forum/model/forum_model.dart';
import 'package:forum/sujet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<ForumModel>> futureForums;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    futureForums = ForumApi().fetchForums();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    setState(() {
      // Logique à adapter plus tard avec ton système de token
      isConnected = false;
    });
  }

  void btAbout() => Navigator.pushNamed(context, '/register');
  void btLogin() async{
    final result = await Navigator.pushNamed(context, '/login');
    if (result == true){
      setState(() {
        isConnected = true;
      });
    }
  } 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 10.0,
        actions: <Widget>[
          //"..." permet d'insérer une liste de widgets si la condition est vraie
          if (!isConnected) ...[
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
          ] else
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => setState(() => isConnected = false),
            ),
        ],
      ),
      body: FutureBuilder<List<ForumModel>>(
        future: futureForums,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun forum trouvé.'));
          }

          final forums = snapshot.data!;

          return ListView.builder(
            itemCount: forums.length,
            itemBuilder: (context, index) {
              final f = forums[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.forum, color: Colors.blue),
                  title: Text(
                    f.libelle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(f.description),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SujetScreen(forumId: f.id, forumLibelle: f.libelle),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
