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

![Connexion](docs/screenshots/connexion.png)

![Accueil](docs/screenshots/accueil.png)

![Famille](docs/screenshots/famille.png)

![Contact](docs/screenshots/contact.png)

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
