import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyspark/main.dart'; // Updated to match your project name

void main() {
  testWidgets('StorySpark app launches', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StorySparkApp());

    // Verify that the app title is present.
    expect(find.text('StorySpark'), findsOneWidget);
  });
}