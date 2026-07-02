import 'package:flutter_test/flutter_test.dart';

import 'package:caja_herramientas_app/main.dart';

void main() {
  testWidgets('La app inicia en la pantalla principal', (WidgetTester tester) async {
    await tester.pumpWidget(const ToolboxApp());

    expect(find.text('Caja de Herramientas'), findsOneWidget);
    expect(find.text('Una app, varias utilidades'), findsOneWidget);
  });
}
