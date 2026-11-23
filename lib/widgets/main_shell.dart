import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/home_page.dart';
import '../pages/family_page.dart';
import '../pages/contact_page.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final List<int> _tabHistory = [];

  static const List<Widget> _pages = [HomePage(), FamilyPage(), ContactPage()];
  static const titles = ['Mon CV', 'Famille', 'Contact'];
  static const icons = [
    Icons.badge_outlined,
    Icons.family_restroom_outlined,
    Icons.contact_mail_outlined,
  ];

  void _selectTab(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _tabHistory.add(_currentIndex);
      _currentIndex = index;
    });
  }

  void _goBack() {
    if (_tabHistory.isEmpty) return;
    setState(() => _currentIndex = _tabHistory.removeLast());
  }

  Future<void> _logout() async {
    await ApiService.clearToken();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const LoginPage(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 900;

        if (!desktop) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                tooltip: 'Retour à l’onglet précédent',
                onPressed: _tabHistory.isEmpty ? null : _goBack,
                icon: const Icon(Icons.arrow_back),
              ),
              title: Text(
                titles[_currentIndex],
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            body: IndexedStack(index: _currentIndex, children: _pages),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: _selectTab,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.badge_outlined),
                  selectedIcon: Icon(Icons.badge),
                  label: 'CV',
                ),
                NavigationDestination(
                  icon: Icon(Icons.family_restroom_outlined),
                  selectedIcon: Icon(Icons.family_restroom),
                  label: 'Famille',
                ),
                NavigationDestination(
                  icon: Icon(Icons.contact_mail_outlined),
                  selectedIcon: Icon(Icons.contact_mail),
                  label: 'Contact',
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: Row(
            children: [
              Container(
                width: 248,
                color: AppTheme.navy,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Container(
                          width: 68,
                          height: 68,
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/moi.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.person,
                                color: AppTheme.navy,
                                size: 38,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'CURRICULUM VITAE',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            letterSpacing: 1.6,
                          ),
                        ),
                        const SizedBox(height: 36),
                        for (var i = 0; i < 3; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 4,
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () => _selectTab(i),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: i == _currentIndex
                                      ? AppTheme.violet
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      icons[i],
                                      color: Colors.white,
                                      size: 21,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      titles[i],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: _logout,
                          icon: const Icon(
                            Icons.logout_rounded,
                            color: Colors.white70,
                          ),
                          label: const Text(
                            'Déconnexion',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      titles[_currentIndex],
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    actions: [
                      IconButton(
                        onPressed: _logout,
                        tooltip: 'Déconnexion',
                        icon: const Icon(Icons.logout_rounded),
                      ),
                    ],
                  ),
                  body: IndexedStack(index: _currentIndex, children: _pages),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
