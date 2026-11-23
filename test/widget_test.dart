// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:cv_flutter_david/main.dart';
import 'package:cv_flutter_david/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Affiche la page de connexion', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await ApiService.clearToken();
    await tester.pumpWidget(const CvApp());
    await tester.pumpAndSettle();

    expect(find.text('Bienvenue'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });
}
