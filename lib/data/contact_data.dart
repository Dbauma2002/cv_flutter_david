class ContactItem {
  const ContactItem({required this.label, required this.value, required this.uri, required this.icon});

  final String label;
  final String value;
  final String uri;
  final String icon;
}

const List<ContactItem> contactItems = [
  ContactItem(label: 'Téléphone', value: '+243 99 5 39 41 69', uri: 'tel:+243995394169', icon: 'phone'),
  ContactItem(label: 'E-mail', value: 'Davidbauma2000@email.com', uri: 'mailto:Davidbauma2000@email.com', icon: 'email'),
  ContactItem(label: 'Adresse', value: 'Avenue du Lac, quartier Himbi, Goma, Nord-Kivu, RDC', uri: 'https://www.google.com/maps/search/?api=1&query=Himbi%20Goma%20RDC', icon: 'location'),
  ContactItem(label: 'LinkedIn', value: 'linkedin.com/in/david-bauma', uri: 'https://www.linkedin.com/in/david-bauma', icon: 'linkedin'),
  ContactItem(label: 'GitHub', value: 'github.com/davidr-bauma/cv_flutter_david', uri: 'https://github.com/davidr-bauma/cv_flutter_david', icon: 'github'),
];
