import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/contact_data.dart';
import '../theme/app_theme.dart';

/// Page des coordonnées avec liens externes sécurisés.
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  IconData _icon(String name) {
    switch (name) {
      case 'phone':
        return Icons.phone_rounded;
      case 'email':
        return Icons.email_rounded;
      case 'location':
        return Icons.location_on_rounded;
      case 'linkedin':
        return Icons.work_outline_rounded;
      default:
        return Icons.code_rounded;
    }
  }

  Future<void> _launch(BuildContext context, String uri) async {
    try {
      final opened = await launchUrl(Uri.parse(uri), mode: LaunchMode.externalApplication);
      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Impossible d’ouvrir ce lien')));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Une erreur est survenue lors de l’ouverture')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppTheme.navy, AppTheme.violet]),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Restons en contact',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Disponible pour un échange, une collaboration ou une opportunité.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                final twoColumns = constraints.maxWidth >= 720;
                final cards = contactItems.map(
                  (item) => InkWell(
                    onTap: () => _launch(context, item.uri),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE8ECF3)),
                        boxShadow: [BoxShadow(color: AppTheme.navy.withValues(alpha: 0.035), blurRadius: 16, offset: const Offset(0, 6))],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.violet.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(_icon(item.icon), color: AppTheme.violet),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.label, style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.navy)),
                                const SizedBox(height: 4),
                                Text(item.value, style: const TextStyle(color: Colors.grey, height: 1.3)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_outward_rounded, size: 19, color: AppTheme.violet),
                        ],
                      ),
                    ),
                  ),
                ).toList();

                return twoColumns
                    ? GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.55,
                        children: cards,
                      )
                    : Column(
                        children: [for (var i = 0; i < cards.length; i++) Padding(padding: const EdgeInsets.only(bottom: 12), child: cards[i])],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
