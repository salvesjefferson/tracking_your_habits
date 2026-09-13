import 'package:flutter/foundation.dart';

import '../models/habit.dart';
import '../repositories/habit_repository.dart';

class HabitViewModel extends ChangeNotifier {
  final HabitRepository repository;

  HabitViewModel(this.repository);

  List<Habit> _habits = [];

  List<Habit> get habits => List.unmodifiable(_habits);

  List<Habit> getHabitsForDate(DateTime date) {
    return _habits.where((habit) {
      if (habit.frequency == 'Diário') {
        return true;
      }

      if (habit.frequency == 'Semanal') {
        return habit.customDays.contains(date.weekday);
      }

      if (habit.frequency == 'Personalizado') {
        return habit.customDays.contains(date.weekday);
      }

      return false;
    }).toList();
  }

  List<Habit> get todayHabits {
    return getHabitsForDate(DateTime.now());
  }

  void loadHabits(String userId) {
    _habits = repository.getHabits(userId);

    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    await repository.addHabit(habit);

    _habits = repository.getHabits(habit.userId);

    notifyListeners();
  }

  Future<void> updateHabit(Habit habit) async {
    await repository.updateHabit(habit);

    _habits = repository.getHabits(habit.userId);

    notifyListeners();
  }

  Future<void> deleteHabit(String id, String userId) async {
    await repository.deleteHabit(id);

    _habits = repository.getHabits(userId);

    notifyListeners();
  }
}