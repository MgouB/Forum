import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inscriptions',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 10.0,
        centerTitle: true,
      ),
      body: const Center(child: Text("S'inscrire")),
    );
  }
}
