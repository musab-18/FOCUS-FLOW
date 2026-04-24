import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusflow/widgets/progress_ring.dart';
import 'package:focusflow/widgets/priority_badge.dart';
import 'package:focusflow/models/task_model.dart';

void main() {
  group('Core UI Component Tests', () {
    testWidgets('ProgressRing displays label and correct progress', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressRing(
              progress: 0.5,
              label: '50%',
              sublabel: 'done',
            ),
          ),
        ),
      );

      expect(find.text('50%'), findsOneWidget);
      expect(find.text('done'), findsOneWidget);
      
      // Look for CustomPaint specifically within the ProgressRing
      expect(find.descendant(
        of: find.byType(ProgressRing), 
        matching: find.byType(CustomPaint)
      ), findsOneWidget);
    });

    testWidgets('PriorityBadge shows correct text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriorityBadge(priority: TaskPriority.high),
          ),
        ),
      );

      expect(find.text('High'), findsOneWidget);
    });
  });
}
