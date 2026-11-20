# CV Flutter — David

Application mobile Flutter présentant le CV de Mushumo Bauma David, sa famille et ses coordonnées.

## Fonctionnalités

- Page de connexion avec identifiant et mot de passe masqué
- Validation des champs et authentification locale
- CV complet : profil, formation, expériences, compétences techniques et linguistiques
- Liste responsive des membres de la famille
- Coordonnées cliquables : appel, e-mail, adresse, LinkedIn et GitHub
- Navigation Material 3 avec onglets et bouton de déconnexion

## Technologies

- Flutter
- Dart
- Material 3
- url_launcher

## Identifiants de test

- Identifiant : `admin`
- Mot de passe : `1234`

## Lancement

```powershell
flutter pub get
flutter run
```

Pour lancer directement dans Chrome :

```powershell
flutter run -d chrome --disable-dds
```

## Captures d'écran

![Connexion](docs/screenshots/<img width="487" height="826" alt="login" src="https://github.com/user-attachments/assets/d902e5ea-7c80-4768-b32c-f07512f1d900" />
)

![Accueil](docs/screenshots/<img width="489" height="835" alt="cv" src="https://github.com/user-attachments/assets/dd48634a-5ea3-4918-b4e3-0f1b4fe5cb62" />
)

![Famille](docs/screenshots/<img width="477" height="823" alt="famille" src="https://github.com/user-attachments/assets/3d0c74f8-faed-41e8-8745-e482105a607e" />
)

![Contact](docs/screenshots/<img width="490" height="833" alt="contact" src="https://github.com/user-attachments/assets/4e4d1ad4-2b9d-49c2-a9ce-e01b8ce74cb4" />
)

## Personnalisation

Remplacer les fichiers temporaires suivants par les vraies photos :

- `assets/images/moi.jpg`
- `assets/images/pere.jpg`
- `assets/images/mere.jpg`
- `assets/images/frere.jpg`
- `assets/images/soeur.jpg`

Remplacer ensuite les quatre captures fictives ou absentes par les captures réelles dans `docs/screenshots/`.

## Publication GitHub

```powershell
git add .
git commit -m "Application CV Flutter"
git branch -M main
git remote add origin https://github.com/davidr-bauma/cv_flutter_david.git
git push -u origin main
```
