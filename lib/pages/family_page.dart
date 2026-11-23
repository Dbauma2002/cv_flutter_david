import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/family_member.dart';
import '../services/api_exception.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  final _api = ApiService();
  List<FamilyMember> _members = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  @override
  void dispose() {
    _api.close();
    super.dispose();
  }

  Future<void> _loadMembers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final members = await _api.getFamille();
      if (!mounted) return;
      setState(() => _members = members);
    } on ApiException catch (error) {
      _setError(error.message);
    } on FormatException catch (error) {
      _setError('Données reçues invalides : ${error.message}');
    } on TimeoutException {
      _setError('Le serveur met trop de temps à répondre.');
    } on http.ClientException {
      _setError(
        'Impossible de joindre l’API. Vérifiez le serveur et Supabase.',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _setError(String message) {
    if (mounted) setState(() => _errorMessage = message);
  }

  Future<void> _openForm({FamilyMember? member}) async {
    final edited = await _showMemberForm(member);
    if (edited == null || !mounted) return;

    try {
      if (member == null) {
        await _api.addFamille(edited);
      } else {
        await _api.updateFamille(edited);
      }
      if (!mounted) return;
      _showMessage(member == null ? 'Membre ajouté.' : 'Membre modifié.');
      await _loadMembers();
    } on ApiException catch (error) {
      _showMessage(error.message);
    } on FormatException catch (error) {
      _showMessage('Données reçues invalides : ${error.message}');
    } on TimeoutException {
      _showMessage('Le serveur met trop de temps à répondre.');
    } on http.ClientException {
      _showMessage(
        'Impossible de joindre l’API. Vérifiez le serveur et Supabase.',
      );
    }
  }

  Future<void> _deleteMember(FamilyMember member) async {
    final id = member.id;
    if (id == null || id.isEmpty) {
      _showMessage('Impossible de supprimer ce membre sans identifiant.');
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ce membre ?'),
        content: Text('Cette action supprimera ${member.name}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _api.deleteFamille(id);
      if (!mounted) return;
      _showMessage('Membre supprimé.');
      await _loadMembers();
    } on ApiException catch (error) {
      _showMessage(error.message);
    } on TimeoutException {
      _showMessage('Le serveur met trop de temps à répondre.');
    } on http.ClientException {
      _showMessage(
        'Impossible de joindre l’API. Vérifiez le serveur et Supabase.',
      );
    }
  }

  Future<FamilyMember?> _showMemberForm(FamilyMember? member) async {
    final name = TextEditingController(text: member?.name ?? '');
    final relationship = TextEditingController(
      text: member?.relationship ?? '',
    );
    final profession = TextEditingController(text: member?.profession ?? '');
    final photoUrl = TextEditingController(text: member?.photoUrl ?? '');
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<FamilyMember>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          member == null ? 'Ajouter un membre' : 'Modifier le membre',
        ),
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _textField(name, 'Nom', 100),
                  _textField(relationship, 'Lien familial', 80),
                  _textField(profession, 'Profession', 120),
                  TextFormField(
                    controller: photoUrl,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      labelText: 'URL ou chemin de photo (facultatif)',
                    ),
                    validator: (value) {
                      final url = value?.trim() ?? '';
                      if (url.length > 2048) {
                        return 'Maximum 2048 caractères';
                      }
                      if (url.isNotEmpty && !url.startsWith('assets/')) {
                        final parsed = Uri.tryParse(url);
                        if (parsed == null ||
                            !parsed.hasScheme ||
                            parsed.host.isEmpty) {
                          return 'Saisissez une URL complète';
                        }
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              final enteredPhotoUrl = photoUrl.text.trim();
              Navigator.pop(
                dialogContext,
                FamilyMember(
                  id: member?.id,
                  name: name.text.trim(),
                  relationship: relationship.text.trim(),
                  profession: profession.text.trim(),
                  photoUrl: enteredPhotoUrl.isEmpty ? null : enteredPhotoUrl,
                ),
              );
            },
            child: Text(member == null ? 'Ajouter' : 'Enregistrer'),
          ),
        ],
      ),
    );

    name.dispose();
    relationship.dispose();
    profession.dispose();
    photoUrl.dispose();
    return result;
  }

  Widget _textField(
    TextEditingController controller,
    String label,
    int maxLength,
  ) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      maxLength: maxLength,
      decoration: InputDecoration(labelText: label, counterText: ''),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ce champ est obligatoire';
        }
        if (value.trim().length > maxLength) {
          return 'Maximum $maxLength caractères';
        }
        return null;
      },
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Ajouter'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 44, color: Colors.blueGrey),
              const SizedBox(height: 12),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _loadMembers,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }
    if (_members.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Aucun membre enregistré. Appuyez sur « Ajouter » pour commencer.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1000
            ? 3
            : constraints.maxWidth >= 620
            ? 2
            : 1;
        if (columns == 1) {
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: _members.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _memberCard(_members[index]),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.15,
          ),
          itemCount: _members.length,
          itemBuilder: (context, index) => _memberCard(_members[index]),
        );
      },
    );
  }

  Widget _memberCard(FamilyMember member) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _memberImage(member.photoUrl),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    member.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.navy,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    member.relationship,
                    style: const TextStyle(
                      color: AppTheme.violet,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    member.profession,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: 'Modifier',
                  onPressed: () => _openForm(member: member),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Supprimer',
                  onPressed: () => _deleteMember(member),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _memberImage(String? photoUrl) {
    if (photoUrl == null || photoUrl.isEmpty) {
      return const CircleAvatar(
        radius: 38,
        backgroundColor: Color(0xFFE9EAF2),
        child: Icon(Icons.person, size: 38, color: AppTheme.navy),
      );
    }

    if (photoUrl.startsWith('assets/')) {
      return CircleAvatar(
        radius: 38,
        backgroundColor: const Color(0xFFE9EAF2),
        child: ClipOval(
          child: Image.asset(
            photoUrl,
            width: 76,
            height: 76,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.person, size: 38, color: AppTheme.navy),
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: 38,
      backgroundColor: const Color(0xFFE9EAF2),
      child: ClipOval(
        child: Image.network(
          photoUrl,
          width: 76,
          height: 76,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.person, size: 38, color: AppTheme.navy),
        ),
      ),
    );
  }
}
