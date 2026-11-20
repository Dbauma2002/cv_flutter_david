import 'package:flutter/material.dart';
import '../data/family_data.dart';
import '../theme/app_theme.dart';

/// Page présentant les membres de la famille sous forme de cartes.
class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final grid = constraints.maxWidth >= 720;
      final children = familyMembers.map((member) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE8ECF3)),
          boxShadow: [BoxShadow(color: AppTheme.navy.withValues(alpha: 0.035), blurRadius: 16, offset: const Offset(0, 7))]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 92, height: 92, padding: const EdgeInsets.all(3), decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [AppTheme.violet, AppTheme.blue])),
            child: ClipOval(child: Image.asset(member.photo, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0xFFF0F2F7), child: Icon(Icons.person, size: 45, color: AppTheme.blue))))),
          const SizedBox(height: 14),
          Text(member.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.navy, fontSize: 16)),
          const SizedBox(height: 7),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: AppTheme.violet.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(20)),
            child: Text(member.link, style: const TextStyle(color: AppTheme.violet, fontWeight: FontWeight.w700, fontSize: 12))),
          const SizedBox(height: 8), Text(member.profession, style: const TextStyle(color: Colors.grey)),
        ]),
      )).toList();

      return Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 980), child: grid
        ? GridView.count(padding: const EdgeInsets.all(24), crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.55, children: children)
        : ListView.separated(padding: const EdgeInsets.all(16), itemCount: children.length, separatorBuilder: (_, __) => const SizedBox(height: 12), itemBuilder: (_, i) => SizedBox(height: 210, child: children[i]))));
    });
  }
}
