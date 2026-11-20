import 'package:flutter/material.dart';
import 'main_navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  void _login() {
    if (_formKey.currentState!.validate()) {
      if (_identifier.text.trim() != 'admin' || _password.text != '1234') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Identifiant ou mot de passe incorrect')),
        );
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    }
  }

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF163E53), Color(0xFF5E9BB2)],
        )),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const CircleAvatar(radius: 42, backgroundColor: Color(0xFFE8F0F4), child: Icon(Icons.person, size: 48, color: Color(0xFF205B78))),
                      const SizedBox(height: 18),
                      const Text('Bienvenue', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      const Text('Connectez-vous à votre espace CV', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _identifier,
                        decoration: const InputDecoration(labelText: 'Identifiant', prefixIcon: Icon(Icons.person_outline), border: OutlineInputBorder()),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Saisissez votre identifiant' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _password,
                        obscureText: _obscure,
                        onFieldSubmitted: (_) => _login(),
                        decoration: InputDecoration(
                          labelText: 'Mot de passe', prefixIcon: const Icon(Icons.lock_outline), border: const OutlineInputBorder(),
                          suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure = !_obscure)),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Saisissez votre mot de passe' : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(width: double.infinity, height: 52, child: FilledButton.icon(onPressed: _login, icon: const Icon(Icons.login), label: const Text('Se connecter'))),
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
