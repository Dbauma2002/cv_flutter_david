import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/contact_data.dart';
import '../widgets/section_card.dart';

/// Page des coordonnées avec liens externes sécurisés.
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  IconData _icon(String name) {
    switch (name) {
      case 'phone': return Icons.phone;
      case 'email': return Icons.email;
      case 'location': return Icons.location_on;
      case 'linkedin': return Icons.work;
      default: return Icons.code;
    }
  }

  Future<void> _launch(BuildContext context, String uri) async {
    final target = Uri.parse(uri);
    try {
      final opened = await launchUrl(target, mode: LaunchMode.externalApplication);
      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d’ouvrir ce lien')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Une erreur est survenue lors de l’ouverture')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      SectionCard(title: 'Mes coordonnées', icon: Icons.perm_contact_calendar,
        child: Column(children: contactItems.take(3).map((item) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(child: Icon(_icon(item.icon))),
          title: Text(item.label, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(item.value),
          trailing: const Icon(Icons.open_in_new, size: 18),
          onTap: () => _launch(context, item.uri),
        )).toList()),
      ),
      SectionCard(title: 'Réseaux sociaux', icon: Icons.share,
        child: Column(children: contactItems.skip(3).map((item) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(child: Icon(_icon(item.icon))),
          title: Text(item.label, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(item.value),
          trailing: const Icon(Icons.open_in_new, size: 18),
          onTap: () => _launch(context, item.uri),
        )).toList()),
      ),
    ]);
  }
}
