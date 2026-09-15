


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rentstyle_app/main.dart';

void main() {
  testWidgets('RentStyle app builds', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: RentStyleApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
