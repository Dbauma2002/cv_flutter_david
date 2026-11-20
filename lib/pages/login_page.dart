import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/main_shell.dart';

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

    if (_identifierController.text.trim() == 'admin' &&
        _passwordController.text == '1234') {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => const MainShell(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 550),
        ),
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
      backgroundColor: const Color(0xFF0A0D14),
      body: Stack(
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF090C12),
                  Color(0xFF111827),
                  Color(0xFF1B1231),
                ],
              ),
            ),
            child: SizedBox.expand(),
          ),
          Positioned(
            top: -100,
            right: -70,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.violet.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -140,
            left: -100,
            child: Container(
              width: 330,
              height: 330,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.violet.withValues(alpha: 0.10),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Card(
                  color: const Color(0xFF171B26),
                  elevation: 24,
                  shadowColor: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: const BorderSide(color: Color(0xFF292F3D)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 34, 28, 28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [AppTheme.violet, AppTheme.blue],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.violet.withValues(
                                    alpha: 0.35,
                                  ),
                                  blurRadius: 24,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/moi.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const ColoredBox(
                                  color: Color(0xFF2A3040),
                                  child: Icon(
                                    Icons.person,
                                    size: 58,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          const Text(
                            'Bienvenue',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            'Connectez-vous pour découvrir mon CV',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFFADB4C4)),
                          ),
                          const SizedBox(height: 28),
                          TextFormField(
                            controller: _identifierController,
                            style: const TextStyle(color: Colors.white),
                            textInputAction: TextInputAction.next,
                            decoration: _darkInputDecoration(
                              'Identifiant',
                              Icons.person_outline,
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Veuillez saisir l’identifiant'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: const TextStyle(color: Colors.white),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _connect(),
                            decoration:
                                _darkInputDecoration(
                                  'Mot de passe',
                                  Icons.lock_outline,
                                ).copyWith(
                                  suffixIcon: IconButton(
                                    tooltip: _obscurePassword
                                        ? 'Afficher le mot de passe'
                                        : 'Masquer le mot de passe',
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: const Color(0xFFADB4C4),
                                    ),
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Veuillez saisir le mot de passe'
                                : null,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton.icon(
                              onPressed: _connect,
                              icon: const Icon(Icons.arrow_forward_rounded),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.violet,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 4,
                              ),
                              label: const Text(
                                'Se connecter',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Identifiant : admin\nMot de passe : 1234',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _darkInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFFADB4C4)),
      prefixIcon: Icon(icon, color: const Color(0xFFADB4C4)),
      filled: true,
      fillColor: const Color(0xFF222736),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF343B4D)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.violet, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}
