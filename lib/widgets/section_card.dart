import 'package:flutter/material.dart';

/// Carte réutilisable pour présenter une section du CV.
class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.title, required this.child, this.icon});

  final String title;
  final Widget child;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            if (icon != null) Icon(icon, color: Theme.of(context).colorScheme.primary),
            if (icon != null) const SizedBox(width: 8),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ]),
          const Divider(height: 20),
          child,
        ]),
      ),
    );
  }
}
