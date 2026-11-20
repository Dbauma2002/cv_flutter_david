import 'package:flutter/material.dart';
import 'data/cv_data.dart';
import 'theme/app_theme.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
  });
  final String title;
  final Widget child;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null)
                Icon(icon, color: Theme.of(context).colorScheme.primary),
              if (icon != null) const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          child,
        ],
      ),
    ),
  );
}

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: AppTheme.navy,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 520;
                    final photo = Container(
                      width: 112,
                      height: 112,
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/moi.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const ColoredBox(
                            color: Color(0xFFE8EEF3),
                            child: Icon(
                              Icons.person,
                              size: 58,
                              color: AppTheme.blue,
                            ),
                          ),
                        ),
                      ),
                    );
                    final text = Column(
                      crossAxisAlignment: compact
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          cvName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cvTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    );
                    return compact
                        ? Column(
                            children: [photo, const SizedBox(height: 14), text],
                          )
                        : Row(
                            children: [
                              photo,
                              const SizedBox(width: 22),
                              Expanded(child: text),
                            ],
                          );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const SectionCard(
              title: 'Profil professionnel',
              icon: Icons.person_outline,
              child: Text(cvProfile),
            ),
            SectionCard(
              title: 'Formation',
              icon: Icons.school_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < formations.length; i++) ...[
                    if (i > 0) const SizedBox(height: 14),
                    Text(
                      formations.keys.elementAt(i),
                      style: const TextStyle(
                        color: AppTheme.violet,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formations.values.elementAt(i),
                      style: const TextStyle(height: 1.4),
                    ),
                  ],
                ],
              ),
            ),
            SectionCard(
              title: 'Expériences',
              icon: Icons.work_outline,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < experiences.length; i++) ...[
                    if (i > 0) const SizedBox(height: 16),
                    Text(
                      experiences.keys.elementAt(i),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...experiences.values
                        .elementAt(i)
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 7),
                                  child: CircleAvatar(
                                    radius: 3,
                                    backgroundColor: AppTheme.violet,
                                  ),
                                ),
                                const SizedBox(width: 9),
                                Expanded(child: Text(item)),
                              ],
                            ),
                          ),
                        ),
                  ],
                ],
              ),
            ),
            SectionCard(
              title: 'Compétences techniques',
              icon: Icons.code,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < skills.length; i++) ...[
                    if (i > 0) const SizedBox(height: 12),
                    Text(
                      skills.keys.elementAt(i),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: skills.values
                          .elementAt(i)
                          .map((skill) => Chip(label: Text(skill)))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            SectionCard(
              title: 'Langues',
              icon: Icons.language,
              child: Column(
                children: languages.entries
                    .map(
                      (entry) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.check_circle_outline),
                        title: Text(entry.key),
                        trailing: Text(entry.value, textAlign: TextAlign.right),
                      ),
                    )
                    .toList(),
              ),
            ),
            SectionCard(
              title: 'Centres d’intérêt',
              icon: Icons.favorite_outline,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: interests
                    .map(
                      (interest) => Chip(
                        avatar: const Icon(
                          Icons.check_circle_outline,
                          size: 18,
                        ),
                        label: Text(interest),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
