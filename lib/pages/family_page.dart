import 'package:flutter/material.dart';
import '../data/family_data.dart';

/// Page présentant les membres de la famille sous forme de cartes.
class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: familyMembers.length,
      itemBuilder: (context, index) {
        final member = familyMembers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(14),
            leading: ClipOval(
              child: Image.asset(member.photo, width: 64, height: 64, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const CircleAvatar(
                  radius: 32,
                  child: Icon(Icons.person, size: 36),
                ),
              ),
            ),
            title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Text('${member.link} • ${member.profession}'),
          ),
        );
      },
    );
  }
}
