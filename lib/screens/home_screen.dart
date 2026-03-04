import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  void btAbout() {
    Navigator.pushNamed(
      context,
      '/register',
    );
  }
  void btLogin(){
    Navigator.pushNamed(context, '/login',);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter', style: TextStyle(color: Colors.white)),
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
    );
  }
}

