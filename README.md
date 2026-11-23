# CV Flutter David — TP1 et TP2

## TP1 — Application Flutter

La première version présente le CV, la famille et les coordonnées de David.
Elle comprend une page de connexion simulée, ainsi qu’une navigation par
Drawer et BottomNavigationBar.

### Captures d’écran du TP1

![Connexion TP1](https://github.com/user-attachments/assets/d902e5ea-7c80-4768-b32c-f07512f1d900)

![CV TP1](https://github.com/user-attachments/assets/dd48634a-5ea3-4918-b4e3-0f1b4fe5cb62)

![Famille TP1](https://github.com/user-attachments/assets/3d0c74f8-faed-41e8-8745-e482105a607e)

![Contact TP1](https://github.com/user-attachments/assets/4e4d1ad4-2b9d-49c2-a9ce-e01b8ce74cb4)

## TP2 — API REST et authentification

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

