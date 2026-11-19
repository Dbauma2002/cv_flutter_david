import 'package:flutter/material.dart';
import '../widgets/main_shell.dart';

/// Page d'ouverture avec authentification locale pour le TP.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _connect() {
    if (!_formKey.currentState!.validate()) return;

    if (_identifierController.text.trim() == 'admin' && _passwordController.text == '1234') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Identifiant ou mot de passe incorrect')),
      );
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF163E53), Color(0xFF5E9BB2)]),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Card(
                elevation: 12,
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const CircleAvatar(radius: 42, backgroundColor: Color(0xFFE8F0F4),
                        child: Icon(Icons.person, size: 48, color: Color(0xFF205B78))),
                      const SizedBox(height: 16),
                      const Text('Connexion', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _identifierController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Identifiant', prefixIcon: Icon(Icons.person_outline), border: OutlineInputBorder()),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Veuillez saisir l’identifiant' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _connect(),
                        decoration: InputDecoration(
                          labelText: 'Mot de passe', prefixIcon: const Icon(Icons.lock_outline), border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            tooltip: _obscurePassword ? 'Afficher le mot de passe' : 'Masquer le mot de passe',
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Veuillez saisir le mot de passe' : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(width: double.infinity, height: 52,
                        child: FilledButton.icon(onPressed: _connect, icon: const Icon(Icons.login), label: const Text('Se connecter'))),
                      const SizedBox(height: 12),
                      const Text('Identifiants : admin / 1234', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
