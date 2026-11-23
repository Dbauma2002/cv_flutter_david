class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.name,
    required this.relationship,
    required this.profession,
    this.photoUrl,
  });

  final String? id;
  final String name;
  final String relationship;
  final String profession;
  final String? photoUrl;

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    final id = idValue is String
        ? idValue
        : idValue is int
        ? idValue.toString()
        : null;
    if (id == null || id.isEmpty) {
      throw const FormatException('Identifiant de membre invalide.');
    }

    return FamilyMember(
      id: id,
      name: _requiredString(json, 'nom', fallback: 'name'),
      relationship: _requiredString(json, 'lien', fallback: 'relationship'),
      profession: _requiredString(json, 'profession'),
      photoUrl: json['photo_url'] as String?,
    );
  }

  Map<String, Object?> toJson() => {
    'nom': name,
    'lien': relationship,
    'profession': profession,
    'photo_url': photoUrl,
  };
}

String _requiredString(
  Map<String, dynamic> json,
  String key, {
  String? fallback,
}) {
  final value = json[key] ?? (fallback == null ? null : json[fallback]);
  if (value is! String) {
    throw FormatException('Le champ $key reçu est invalide.');
  }
  return value;
}
