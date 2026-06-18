import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'michelin_drop_page.dart';

class MichelinLoginPage extends StatefulWidget {
  const MichelinLoginPage({Key? key}) : super(key: key);

  @override
  State<MichelinLoginPage> createState() => _MichelinLoginPageState();
}

class _MichelinLoginPageState extends State<MichelinLoginPage> {
  final _emailController = TextEditingController(text: 'user@schoolhub.io'); // Pré-rempli pour tes tests
  final _passwordController = TextEditingController(text: 'demo-user');
  bool _isLoading = false;
  String? _errorMessage;

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await ApiService().login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Navigation vers la Drop Page en remplaçant la pile pour éviter un retour en arrière
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

  @override
  Widget build(BuildContext context) {
    const blueMichelin = Color(0xFF1C4494);
    const yellowMichelin = Color(0xFFFFF000);

    return Scaffold(
      backgroundColor: blueMichelin,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo ou Icône de marque
              const Icon(Icons.directions_bike, color: yellowMichelin, size: 64),
              const SizedBox(height: 16),
              const Text(
                "MICHELIN DROP",
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 40),

              // Formulaire Card
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Adresse Email",
                          prefixIcon: Icon(Icons.email_outlined, color: blueMichelin),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: "Mot de passe",
                          prefixIcon: Icon(Icons.lock_outline, color: blueMichelin),
                        ),
                        obscureText: true,
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                      const SizedBox(height: 24),

                      // Bouton de validation
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: yellowMichelin,
                          foregroundColor: blueMichelin,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: blueMichelin, strokeWidth: 2))
                            : const Text("SE CONNECTER", style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}