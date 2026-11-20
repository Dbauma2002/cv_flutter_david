import 'package:flutter/material.dart';
import '../data/cv_data.dart';
import '../theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            _ProfileHeader(),
            const SizedBox(height: 18),
            _SectionTitle(
              title: 'Profil professionnel',
              icon: Icons.person_outline,
            ),
            _Card(child: Text(cvProfile, style: const TextStyle(height: 1.55))),
            _SectionTitle(title: 'Formation', icon: Icons.school_outlined),
            _Card(
              child: Column(
                children: [
                  for (var i = 0; i < formations.length; i++)
                    _timelineItem(
                      formations.entries.elementAt(i),
                      i == formations.length - 1,
                    ),
                ],
              ),
            ),
            _SectionTitle(title: 'Expériences', icon: Icons.work_outline),
            ...experiences.entries.map(
              (entry) => _ExperienceCard(title: entry.key, items: entry.value),
            ),
            _SectionTitle(
              title: 'Compétences techniques',
              icon: Icons.code_rounded,
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 720 ? 2 : 1;
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: columns == 2 ? 2.3 : 3.2,
                  children: skills.entries
                      .map(
                        (entry) =>
                            _SkillCard(category: entry.key, items: entry.value),
                      )
                      .toList(),
                );
              },
            ),
            _SectionTitle(
              title: 'Compétences linguistiques',
              icon: Icons.language_rounded,
            ),
            _Card(
              child: Column(
                children: languages.entries
                    .map(
                      (entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: entry.key == 'Swahili'
                                    ? 1
                                    : entry.key == 'Français'
                                    ? .9
                                    : entry.key == 'Lingala'
                                    ? .75
                                    : .55,
                                minHeight: 7,
                                borderRadius: BorderRadius.circular(10),
                                backgroundColor: const Color(0xFFE7EAF2),
                                color: AppTheme.violet,
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 98,
                              child: Text(
                                entry.value,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            _SectionTitle(
              title: 'Centres d’intérêt',
              icon: Icons.favorite_outline,
            ),
            const _Card(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InterestChip(
                    icon: Icons.sports_soccer,
                    label: 'Football (équipe universitaire)',
                  ),
                  _InterestChip(
                    icon: Icons.terrain,
                    label: 'Randonnée au Nyiragongo',
                  ),
                  _InterestChip(
                    icon: Icons.water,
                    label: 'Promenades au lac Kivu',
                  ),
                  _InterestChip(icon: Icons.music_note, label: 'Musique'),
                  _InterestChip(icon: Icons.menu_book, label: 'Lecture'),
                  _InterestChip(icon: Icons.security, label: 'Cybersécurité'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timelineItem(MapEntry<String, String> entry, bool last) =>
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 36,
              child: Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppTheme.violet,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!last)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: const Color(0xFFDDE2EE),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        color: AppTheme.violet,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(entry.value, style: const TextStyle(height: 1.4)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.navy, AppTheme.blue, AppTheme.violet],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navy.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
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
                  child: Icon(Icons.person, size: 58, color: AppTheme.blue),
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
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                cvTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
          return compact
              ? Column(children: [photo, const SizedBox(height: 14), text])
              : Row(
                  children: [
                    photo,
                    const SizedBox(width: 22),
                    Expanded(child: text),
                  ],
                );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon});
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 22, bottom: 10),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.violet.withValues(alpha: 0.11),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.violet, size: 20),
        ),
        const SizedBox(width: 10),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
      ],
    ),
  );
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE8ECF3)),
      boxShadow: [
        BoxShadow(
          color: AppTheme.navy.withValues(alpha: 0.035),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: child,
  );
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.title, required this.items});
  final String title;
  final List<String> items;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 10),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
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
                  Expanded(
                    child: Text(item, style: const TextStyle(height: 1.42)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.category, required this.items});
  final String category;
  final List<String> items;
  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: AppTheme.navy,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: items
              .map(
                (item) => Chip(
                  visualDensity: VisualDensity.compact,
                  side: BorderSide.none,
                  backgroundColor: AppTheme.violet.withValues(alpha: 0.09),
                  label: Text(
                    item,
                    style: const TextStyle(fontSize: 12, color: AppTheme.blue),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    ),
  );
}

class _InterestChip extends StatelessWidget {
  const _InterestChip({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      color: const Color(0xFFF5F3FC),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: AppTheme.violet),
        const SizedBox(width: 7),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.blue,
          ),
        ),
      ],
    ),
  );
}
