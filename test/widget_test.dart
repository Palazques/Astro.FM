import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astro_fm_app/main.dart';

void main() {
  testWidgets('Home page shows title and explore button', (WidgetTester tester) async {
    await tester.pumpWidget(const AstroFmApp());
    expect(find.text('Astro.FM'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
  });
}
