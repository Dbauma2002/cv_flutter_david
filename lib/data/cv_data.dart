/// Informations du CV utilisées par la page d'accueil.
const String cvName = 'Mushumo Bauma David';
const String cvTitle = 'Étudiant en Licence 3 Réseaux et Télécommunications, à l\'ISIG Goma';
const String cvProfile = 'Étudiant rigoureux et curieux, passionné par les réseaux, la connexion internet dans les quartiers de Goma et le développement mobile.';

const Map<String, String> formations = {
  '2023 – aujourd’hui': 'Licence 3 Réseaux et Télécommunications, ISIG Goma',
  '2022 – 2024': 'Licence 1 et 2 en informatique, ISIG Goma',
  '2022': 'Diplôme d\'État, section Mathématique-Physique, Institut scientifique de Goma',
};

const Map<String, List<String>> experiences = {
  'Stage de technicien réseau (2 mois, 2025), opérateur télécom': [
    'Configuration de routeurs et switch, câblage d\'un réseau local de 30 postes, suivi des pannes de connexion',
    'Supervision du réseau avec Zabbix et prise en compte des coupures d\'électricité (onduleurs, groupe électrogène)',
  ],
  'Job étudiant : technicien dans un cybercafé du centre-ville de Goma (2024)': [
    'Dépannage de postes, installation de logiciels, gestion du Wi-Fi et assistance aux clients',
  ],
};

const Map<String, List<String>> skills = {
  'Réseaux': ['Cisco (VLAN, NAT)', 'TCP/IP', 'Wi-Fi', 'VPN', 'Wireshark'],
  'Systèmes': ['Linux (Ubuntu, Debian)', 'Windows Server', 'Bash'],
  'Développement': ['Flutter / Dart', 'Python', 'HTML / CSS'],
  'Outils': ['Git / GitHub', 'Visual Studio Code', 'Packet Tracer'],
};

const Map<String, String> languages = {
  'Swahili': 'langue maternelle',
  'Français': 'courant (langue des études)',
  'Lingala': 'bon niveau',
  'Anglais': 'intermédiaire (B1)',
};
