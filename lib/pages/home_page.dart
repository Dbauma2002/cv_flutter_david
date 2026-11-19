import 'package:flutter/material.dart';
import '../data/cv_data.dart';
import '../widgets/section_card.dart';

/// Page d'accueil présentant l'intégralité du CV.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _personPhoto() => ClipOval(
    child: Image.asset(
      'assets/images/moi.jpg',
      width: 104,
      height: 104,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const CircleAvatar(
        radius: 52,
        backgroundColor: Colors.white,
        child: Icon(Icons.person, size: 64, color: Color(0xFF205B78)),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      Card(
        color: const Color(0xFF205B78),
        child: Padding(padding: const EdgeInsets.all(22), child: Column(children: [
          _personPhoto(),
          const SizedBox(height: 12),
          const Text(cvName, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          const Text(cvTitle, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white70)),
        ])),
      ),
      const SizedBox(height: 16),
      const SectionCard(title: 'Profil', icon: Icons.person_outline, child: Text(cvProfile)),
      SectionCard(title: 'Formation', icon: Icons.school_outlined, child: Column(
        children: formations.entries.map((entry) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.calendar_month_outlined),
          title: Text(entry.key),
          subtitle: Text(entry.value),
        )).toList(),
      ),),
      SectionCard(title: 'Expériences', icon: Icons.work_outline, child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: experiences.entries.expand((entry) => <Widget>[
          Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          ...entry.value.map((item) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('•  '), Expanded(child: Text(item)),
          ]))),
          const SizedBox(height: 10),
        ]).toList(),
      )),
      SectionCard(title: 'Compétences techniques', icon: Icons.code, child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: skills.entries.map((entry) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: entry.value.map((item) => Chip(label: Text(item))).toList()),
        ]))).toList(),
      )),
      SectionCard(title: 'Compétences linguistiques', icon: Icons.language, child: Column(
        children: languages.entries.map((entry) => ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.check_circle_outline),
          title: Text(entry.key),
          trailing: Text(entry.value),
        )).toList(),
      )),
      const SectionCard(title: 'Centres d’intérêt', icon: Icons.interests, child: Wrap(spacing: 8, runSpacing: 8, children: [
        Chip(avatar: Icon(Icons.sports_soccer, size: 18), label: Text('Football')), 
        Chip(avatar: Icon(Icons.terrain, size: 18), label: Text('Nyiragongo')), 
        Chip(avatar: Icon(Icons.water, size: 18), label: Text('Lac Kivu')), 
        Chip(avatar: Icon(Icons.music_note, size: 18), label: Text('Musique')), 
        Chip(avatar: Icon(Icons.menu_book, size: 18), label: Text('Lecture')), 
        Chip(avatar: Icon(Icons.security, size: 18), label: Text('Cybersécurité')),
      ])),
    ]);
  }
}
