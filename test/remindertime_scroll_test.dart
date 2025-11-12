import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_application/Reminder/reminderTime.dart';

void main() {
  testWidgets('Remindertime includes a visible scroll indicator and scroll view', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Remindertime(
          selectedDate: DateTime.now(),
        ),
      ),
    );

    // Expect a Scrollbar and a SingleChildScrollView
    expect(find.byType(Scrollbar), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);

    // Try scrolling down
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();
  });
}