import 'package:flutter/material.dart';
import 'login_page.dart';
import 'cv_page.dart';
import 'family_page.dart';
import 'contact_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;
  final _pages = const [CvPage(), FamilyPage(), ContactPage()];

  @override
  Widget build(BuildContext context) {
    const titles = ['Mon CV', 'Ma famille', 'Contact'];
    return Scaffold(
      appBar: AppBar(title: Text(titles[_index]), centerTitle: true, backgroundColor: Colors.white),
      drawer: Drawer(child: SafeArea(child: Column(children: [
        const UserAccountsDrawerHeader(
          accountName: Text('David'), accountEmail: Text('Développeur Mobile Flutter'),
          currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
        ),
        ...List.generate(3, (i) {
          const icons = [Icons.badge, Icons.family_restroom, Icons.contacts];
          return ListTile(
            leading: Icon(icons[i]), title: Text(titles[i]), selected: i == _index,
            onTap: () { setState(() => _index = i); Navigator.pop(context); },
          );
        }),
        const Spacer(),
        ListTile(leading: const Icon(Icons.logout), title: const Text('Se déconnecter'), onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
        }),
      ]))),
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.badge_outlined), selectedIcon: Icon(Icons.badge), label: 'CV'),
          NavigationDestination(icon: Icon(Icons.family_restroom_outlined), selectedIcon: Icon(Icons.family_restroom), label: 'Famille'),
          NavigationDestination(icon: Icon(Icons.contact_page_outlined), selectedIcon: Icon(Icons.contact_page), label: 'Contact'),
        ],
      ),
    );
  }
}
