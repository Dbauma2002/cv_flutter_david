import 'package:flutter/material.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    const family = [
      ('Jean-Paul', 'Père', 'Chef d’entreprise', 'JP', Colors.blue),
      ('Marie', 'Mère', 'Infirmière', 'M', Colors.pink),
      ('Sophie', 'Sœur', 'Étudiante', 'S', Colors.orange),
      ('Lucas', 'Frère', 'Lycéen', 'L', Colors.green),
    ];

    Widget card((String, String, String, String, Color) member) => Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(radius: 32, backgroundColor: member.$5.withValues(alpha: .15), child: Text(member.$4, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: member.$5))),
        title: Text(member.$1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text('${member.$2} • ${member.$3}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth <= 700) {
        return ListView(padding: const EdgeInsets.all(16), children: family.map(card).toList());
      }
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.2, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: family.length, itemBuilder: (_, i) => card(family[i]),
      );
    });
  }
}
