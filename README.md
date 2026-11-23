# CV Flutter David — TP2

Application Flutter de présentation du CV, connectée à une API REST Flask.
L’API utilise PostgreSQL sur Supabase, bcrypt pour les mots de passe et des
jetons JWT pour protéger les opérations sur les membres de la famille.

## Architecture

```text
cv_flutter_david/
├── lib/
│   ├── main.dart
│   ├── services/
│   │   └── api_service.dart
│   ├── pages/
│   │   ├── login_page.dart
│   │   ├── main_navigation.dart
│   │   ├── family_page.dart
│   │   ├── home_page.dart
│   │   └── contact_page.dart
│   ├── models/
│   └── widgets/
├── backend/
│   ├── app.py
│   ├── config.py
│   ├── create_user.py
│   ├── requirements.txt
│   └── .env.example
├── database/
│   └── schema.sql
├── assets/
└── README.md
```

Le jeton est conservé dans `shared_preferences`. Les membres de la famille sont
isolés par compte. Le SQL crée aussi les modèles des quatre membres repris du
TP1; ils sont ajoutés au compte à son inscription. Les anciens mots de passe
Argon2 du backend TP1 sont vérifiés puis convertis en bcrypt au premier login.
Les clés UUID sont compatibles avec les tables déjà présentes dans Supabase.

## Configuration de Supabase

1. Dans Supabase, ouvre **SQL Editor**, copie tout le contenu de
   `database/schema.sql`, puis clique sur **Run**.
2. Crée `backend/.env` à partir de `backend/.env.example` et remplace les
   valeurs d’exemple :

   ```env
   DATABASE_URL=postgresql://postgres:VOTRE_MOT_DE_PASSE@aws-0-eu-central-1.pooler.supabase.com:6543/postgres?sslmode=require
   SECRET_KEY=une-cle-aleatoire-d-au-moins-32-caracteres
   ```

   Pour générer une clé, exécute `python -c "import secrets; print(secrets.token_urlsafe(48))"`.
   Ne partagez et ne publiez jamais `backend/.env`.

## Démarrage sous Windows

Depuis la racine du projet, dans un premier terminal :

```powershell
py -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r backend\requirements.txt
python -m backend.app
```

Équivalent demandé pour démarrer depuis le dossier backend :

```powershell
Set-Location backend
python app.py
```

L’API écoute sur `http://127.0.0.1:5000`. Vérifie la connexion à Supabase :

```powershell
curl.exe http://127.0.0.1:5000/api/health
```

Dans un second terminal, depuis la racine du projet :

```powershell
flutter pub get
flutter run -d chrome
```

L’application web utilise par défaut `http://127.0.0.1:5000/api`. Pour changer
l’adresse de l’API :

```powershell
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:5000/api
```

Si Flutter indique que les plugins nécessitent la prise en charge des liens
symboliques sous Windows, active le **Mode développeur** dans les paramètres
Windows, puis relance `flutter pub get`.

<<<<<<< HEAD
![Connexion](docs/screenshots/<img width="487" height="826" alt="login" src="https://github.com/user-attachments/assets/d902e5ea-7c80-4768-b32c-f07512f1d900" />
)

![Accueil](docs/screenshots/<img width="489" height="835" alt="cv" src="https://github.com/user-attachments/assets/dd48634a-5ea3-4918-b4e3-0f1b4fe5cb62" />
)

![Famille](docs/screenshots/<img width="477" height="823" alt="famille" src="https://github.com/user-attachments/assets/3d0c74f8-faed-41e8-8745-e482105a607e" />
)

![Contact](docs/screenshots/<img width="490" height="833" alt="contact" src="https://github.com/user-attachments/assets/4e4d1ad4-2b9d-49c2-a9ce-e01b8ce74cb4" />
)
=======
## Création ou réinitialisation d’un compte

Dans l’application, choisis **Créer un nouveau compte** avec une adresse valide
et un mot de passe de 8 à 72 octets. L’inscription connecte ensuite
automatiquement l’utilisateur.

Pour créer un compte ou réinitialiser localement son mot de passe depuis le
backend, utilise le script interactif :

```powershell
python backend\create_user.py
```

Le script demande le mot de passe sans l’afficher. Il met à jour le mot de passe
si l’adresse existe déjà.

## Endpoints

| Méthode | Route | Authentification | Description |
|---|---|---|---|
| `GET` | `/api/health` | Non | Vérifier l’API et PostgreSQL |
| `POST` | `/api/auth/register` | Non | Créer un compte |
| `POST` | `/api/auth/login` | Non | Recevoir un JWT valable 24 heures |
| `GET` | `/api/famille` | Bearer JWT | Lister les membres du compte |
| `POST` | `/api/famille` | Bearer JWT | Ajouter un membre |
| `PUT` | `/api/famille/<id>` | Bearer JWT | Modifier un membre |
| `DELETE` | `/api/famille/<id>` | Bearer JWT | Supprimer un membre |

Les requêtes famille utilisent les champs `nom`, `lien`, `profession` et
`photo_url`. Les routes protégées répondent `401` si le jeton manque et `403`
s’il est invalide.

## Tests

```powershell
python -m pytest backend\tests
flutter test
```

## Vidéo de démonstration

Lien YouTube : **[Ajouter ici le lien de la vidéo de démonstration](https://www.youtube.com/)**

## Captures d’écran

![Connexion](docs/screenshots/login.svg)

![CV](docs/screenshots/cv.svg)

![Famille](docs/screenshots/famille.svg)

![Contact](docs/screenshots/contact.svg)
>>>>>>> 08cfc44 ( tp2 ajouter)

## Personnalisation

Remplace les photos dans `assets/images/` et les captures de démonstration dans
`docs/screenshots/` par les versions finales.
