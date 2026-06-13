import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:app/main.dart';
import 'package:app/providers/ride_provider.dart';

void main() {
  testWidgets('App launches without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => RideProvider(),
        child: const CRNApp(),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
