import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.title, required this.child, this.icon});
  final String title;
  final Widget child;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [if (icon != null) Icon(icon, color: Theme.of(context).colorScheme.primary), if (icon != null) const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]),
      const Divider(height: 20), child,
    ])),
  );
}

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
    Card(color: const Color(0xFF205B78), child: const Padding(padding: EdgeInsets.all(22), child: Column(children: [
      CircleAvatar(radius: 52, backgroundColor: Colors.white, child: Icon(Icons.person, size: 64, color: Color(0xFF205B78))),
      SizedBox(height: 12), Text('DAVID', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
      Text('Développeur Mobile Flutter', style: TextStyle(fontSize: 17, color: Colors.white70)),
      SizedBox(height: 8), Text('Créatif • Rigoureux • Autonome', style: TextStyle(color: Colors.white)),
    ]))),
    const SizedBox(height: 16),
    const SectionCard(title: 'Profil', icon: Icons.person_outline, child: Text('Étudiant passionné par le développement mobile et les applications modernes. Je souhaite concevoir des produits utiles, performants et accessibles à tous.')),
    const SectionCard(title: 'Formation', icon: Icons.school_outlined, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('2024 – Aujourd’hui', style: TextStyle(color: Colors.grey)), Text('Formation en développement informatique', style: TextStyle(fontWeight: FontWeight.bold)), Text('Établissement supérieur • Informatique'),
      SizedBox(height: 12), Text('2021 – 2024', style: TextStyle(color: Colors.grey)), Text('Baccalauréat scientifique', style: TextStyle(fontWeight: FontWeight.bold)),
    ])),
    const SectionCard(title: 'Expériences & projets', icon: Icons.work_outline, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Projet CV Flutter', style: TextStyle(fontWeight: FontWeight.bold)), Text('Application mobile multi-pages avec authentification, navigation et interfaces responsive.'),
      SizedBox(height: 12), Text('Stage développeur', style: TextStyle(fontWeight: FontWeight.bold)), Text('Développement d’une application mobile et correction de bugs.'),
      SizedBox(height: 12), Text('Projet personnel', style: TextStyle(fontWeight: FontWeight.bold)), Text('Gestionnaire de tâches réalisé avec Flutter et Firebase.'),
    ])),
    const SectionCard(title: 'Compétences techniques', icon: Icons.code, child: Wrap(spacing: 8, runSpacing: 8, children: [
      Chip(label: Text('Flutter')), Chip(label: Text('Dart')), Chip(label: Text('Firebase')), Chip(label: Text('Git')), Chip(label: Text('REST API')), Chip(label: Text('UI/UX')),
    ])),
    const SectionCard(title: 'Langues', icon: Icons.language, child: Column(children: [
      ListTile(dense: true, contentPadding: EdgeInsets.zero, leading: Icon(Icons.check_circle_outline), title: Text('Français'), trailing: Text('Courant')),
      ListTile(dense: true, contentPadding: EdgeInsets.zero, leading: Icon(Icons.check_circle_outline), title: Text('Anglais'), trailing: Text('Intermédiaire')),
    ])),
    const SectionCard(title: 'Centres d’intérêt', icon: Icons.favorite_outline, child: Text('Programmation • Football • Musique • Photographie • Voyage')),
  ]);
}
