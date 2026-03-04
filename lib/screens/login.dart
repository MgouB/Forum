import 'package:flutter/material.dart';
import 'package:forum/api/user.dart'; 
import 'package:forum/utils/secure_storage.dart'; // Pour le stockage des identifiants

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Déclaration de la clé et des contrôleurs
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    _loadCredentials(); // Chargement automatique des identifiants au démarrage
  }

  // Libération de la mémoire pour les contrôleurs
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Chargement des identifiants depuis le stockage sécurisé
  Future<void> _loadCredentials() async {
    final credentials = await secureStorage.readCredentials();
    setState(() {
      _emailController.text = credentials['email'] ?? '';
      _passwordController.text = credentials['password'] ?? '';
    });
  }

  // Méthode de connexion avec gestion du Loader
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Appel de la méthode API login
        final response = await login(
          _emailController.text,
          _passwordController.text,
        );

        // Sauvegarde des identifiants après succès
        await secureStorage.saveCredentials(
          _emailController.text,
          _passwordController.text,
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentification réussie')),
        );

        // Redirection après un court délai
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/');
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Echec de l\'authentification : $e')),
        );
      } finally {
        if (mounted)
          setState(() {
            _isLoading = false;
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion', style: TextStyle(color: Colors.white)),
        elevation: 10.0,
        centerTitle: true,
      ),
      // Structure du formulaire selon le Chapitre 07
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Champ Email avec décoration personnalisée
              _buildTextField(_emailController, 'Email', false, (value) {
                if (value == null || value.isEmpty)
                  return 'Veuillez entrer votre email';
                return null;
              }),
              const SizedBox(height: 15),

              // Champ Mot de passe (obscureText: true)
              _buildTextField(_passwordController, 'Mot de passe', true, (
                value,
              ) {
                if (value == null || value.isEmpty)
                  return 'Veuillez entrer votre mot de passe';
                return null;
              }),

              const SizedBox(height: 25),

              // Affichage conditionnel du bouton ou du loader
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Se connecter'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode helper pour respecter le style visuel du cours
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    bool obscure,
    String? Function(String?) validator,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        // Style d'erreur spécifique au cours
        errorStyle: const TextStyle(color: Color.fromARGB(255, 196, 43, 160)),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 196, 43, 160)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 196, 43, 160)),
        ),
      ),
      validator: validator,
    );
  }
}
