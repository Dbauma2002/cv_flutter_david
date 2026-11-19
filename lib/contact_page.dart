import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'cv_page.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: const [
    SectionCard(title: 'Mes coordonnées', icon: Icons.perm_contact_calendar, child: Column(children: [
      ContactTile(icon: Icons.phone, title: 'Téléphone', value: '+243 99 5 39 41 69', uri: 'tel:+243995394169'),
      ContactTile(icon: Icons.email, title: 'E-mail', value: 'Davidbauma2000@email.com', uri: 'mailto:Davidbauma2000@email.com'),
      ContactTile(icon: Icons.location_on, title: 'Adresse', value: 'Avenue du Lac, quartier Himbi, Goma, Nord-Kivu, RDC', uri: 'https://www.google.com/maps/search/?api=1&query=Himbi%20Goma%20RDC'),
    ])),
    SectionCard(title: 'Réseaux sociaux', icon: Icons.share, child: Column(children: [
      ContactTile(icon: Icons.work, title: 'LinkedIn', value: 'linkedin.com/in/david-bauma', uri: 'https://linkedin.com/in/david-bauma'),
      ContactTile(icon: Icons.code, title: 'GitHub', value: 'github.com/davidr-bauma/cv_flutter_david', uri: 'https://github.com/davidr-bauma/cv_flutter_david'),
    ])),
  ]);
}

class ContactTile extends StatelessWidget {
  const ContactTile({super.key, required this.icon, required this.title, required this.value, required this.uri});
  final IconData icon;
  final String title;
  final String value;
  final String uri;

  Future<void> _open() async {
    final target = Uri.parse(uri);
    await launchUrl(target, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: CircleAvatar(child: Icon(icon, size: 20)),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(value),
    trailing: const Icon(Icons.open_in_new, size: 18),
    onTap: _open,
  );
}
