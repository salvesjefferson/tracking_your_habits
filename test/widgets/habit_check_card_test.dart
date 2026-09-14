import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tracking_your_habits/src/models/habit.dart';
import 'package:tracking_your_habits/src/widgets/habit_check_card.dart';

void main() {
  testWidgets(
    'deve exibir o nome e a descrição do hábito',
    (WidgetTester tester) async {
      // Arrange
      final habit = Habit(
        id: '1',
        name: 'Beber água',
        description: 'Beber 2 litros de água',
        frequency: 'Diário',
        userId: 'user1',
        createdAt: DateTime(2026, 9, 14),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HabitCheckCard(
              habit: habit,
              isCompleted: false,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Assert
      expect(
        find.text('Beber água'),
        findsOneWidget,
      );

      expect(
        find.text('Beber 2 litros de água'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'deve exibir o checkbox desmarcado',
    (WidgetTester tester) async {
      // Arrange
      final habit = Habit(
        id: '1',
        name: 'Beber água',
        description: 'Beber 2 litros de água',
        frequency: 'Diário',
        userId: 'user1',
        createdAt: DateTime(2026, 9, 14),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HabitCheckCard(
              habit: habit,
              isCompleted: false,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Assert
      final checkbox = tester.widget<Checkbox>(
        find.byType(Checkbox),
      );

      expect(checkbox.value, false);
    },
  );

  testWidgets(
    'deve chamar onChanged ao clicar no checkbox',
    (WidgetTester tester) async {
      // Arrange
      final habit = Habit(
        id: '1',
        name: 'Beber água',
        description: 'Beber 2 litros de água',
        frequency: 'Diário',
        userId: 'user1',
        createdAt: DateTime(2026, 9, 14),
      );

      bool? receivedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HabitCheckCard(
              habit: habit,
              isCompleted: false,
              onChanged: (value) {
                receivedValue = value;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Assert
      expect(receivedValue, true);
    },
  );

}