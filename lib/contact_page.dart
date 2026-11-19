import 'package:flutter/material.dart';
import 'cv_page.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: const [
    SectionCard(title: 'Mes coordonnées', icon: Icons.perm_contact_calendar, child: Column(children: [
      ContactTile(icon: Icons.phone, title: 'Téléphone', value: '+33 6 12 34 56 78'),
      ContactTile(icon: Icons.email, title: 'E-mail', value: 'david.cv@example.com'),
      ContactTile(icon: Icons.location_on, title: 'Adresse', value: 'Paris, France'),
    ])),
    SectionCard(title: 'Réseaux sociaux', icon: Icons.share, child: Column(children: [
      ContactTile(icon: Icons.work, title: 'LinkedIn', value: 'linkedin.com/in/david'),
      ContactTile(icon: Icons.code, title: 'GitHub', value: 'github.com/david'),
      ContactTile(icon: Icons.camera_alt, title: 'Portfolio', value: 'david.dev'),
    ])),
  ]);
}

class ContactTile extends StatelessWidget {
  const ContactTile({super.key, required this.icon, required this.title, required this.value});
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: CircleAvatar(child: Icon(icon, size: 20)),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(value),
    trailing: const Icon(Icons.open_in_new, size: 18),
  );
}
