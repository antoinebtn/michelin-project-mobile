import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'michelin_drop_page.dart';

class MichelinLoginPage extends StatefulWidget {
  const MichelinLoginPage({Key? key}) : super(key: key);

  @override
  State<MichelinLoginPage> createState() => _MichelinLoginPageState();
}

class _MichelinLoginPageState extends State<MichelinLoginPage> {
  static const Color blueMichelin = Color(0xFF1C4494);
  static const Color yellowMichelin = Color(0xFFFFF000);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@schoolhub.io');
  final _passwordController = TextEditingController(text: 'demo-admin');

  bool _isLoading = false;
  String? _errorMessage;

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Appel à ton API AdonisJS (POST /api/auth/login)
    final success = await ApiService().login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        // Navigation vers la page principale du Drop
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MichelinDropPage()),
        );
      } else {
        setState(() {
          _errorMessage = "Identifiants incorrects ou problème de connexion.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueMichelin,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- LOGO / ICON ---
                const Icon(Icons.directions_bike, color: yellowMichelin, size: 64),
                const SizedBox(height: 16),
                const Text(
                  "MICHELIN UNLOCK & RIDE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 32),

                // --- CARD FORMULAIRE ---
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        if (_errorMessage != null) ...[
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Champ Email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: "Adresse email",
                            prefixIcon: Icon(Icons.email_outlined, color: blueMichelin),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => (value == null || !value.contains('@')) ? 'Email invalide' : null,
                        ),
                        const SizedBox(height: 16),

                        // Champ Mot de passe
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "Mot de passe",
                            prefixIcon: Icon(Icons.lock_outline, color: blueMichelin),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => (value == null || value.isEmpty) ? 'Mot de passe requis' : null,
                        ),
                        const SizedBox(height: 24),

                        // Bouton Connexion / Loader
                        _isLoading
                            ? const CircularProgressIndicator(color: blueMichelin)
                            : ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: yellowMichelin,
                            foregroundColor: blueMichelin,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            elevation: 0,
                          ),
                          child: const Text("SE CONNECTER", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}