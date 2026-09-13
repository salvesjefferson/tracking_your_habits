import 'package:flutter/material.dart';

import '../models/habit.dart';

class HabitCheckCard extends StatelessWidget {
  const HabitCheckCard({
    super.key,
    required this.habit,
    required this.isCompleted,
    required this.onChanged,
  });

  final Habit habit;
  final bool isCompleted;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Row(
          children: [
            // Espaço reservado para futuro ícone
            const SizedBox(
              width: 48,
              height: 48,
            ),

            const SizedBox(width: 8),

            // Nome e descrição do hábito
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),

                  if (habit.description.isNotEmpty) ...[
                    const SizedBox(height: 4),

                    Text(
                      habit.description,
                      style: TextStyle(
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Checkbox do lado direito
            Checkbox(
              value: isCompleted,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}