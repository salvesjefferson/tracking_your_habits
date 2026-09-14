import 'package:flutter/foundation.dart';

import '../models/checkin.dart';
import '../models/habit.dart';
import '../repositories/checkin_repository.dart';
import 'user_viewmodel.dart';

class CheckInViewModel extends ChangeNotifier {
  final CheckInRepository repository;
  final UserViewModel userViewModel;

  CheckInViewModel(
      this.repository,
      this.userViewModel,
      );

  List<CheckIn> _checkIns = [];

  List<CheckIn> get checkIns => List.unmodifiable(_checkIns);

  void loadCheckIns(String userId) {
    _checkIns = repository.getCheckIns(userId);

    notifyListeners();
  }

  bool isCheckedIn(
      String habitId,
      String userId,
      DateTime date,
      ) {
    return repository.getCheckIn(
      habitId,
      userId,
      date,
    ) !=
        null;
  }

  int _getExperience(Habit habit) {
    switch (habit.frequency) {
      case 'Diário':
        return 10;

      case 'Semanal':
        return 50;

      case 'Personalizado':
        return 10;

      default:
        return 10;
    }
  }

  Future<void> checkIn({
    required Habit habit,
    required String userId,
    required DateTime date,
  }) async {
    final today = DateTime.now();

    final currentDate = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final checkInDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    if (checkInDate.isAfter(currentDate)) {
      return;
    }

    final existingCheckIn = repository.getCheckIn(
      habit.id,
      userId,
      date,
    );

    if (existingCheckIn != null) {
      return;
    }

    final checkIn = CheckIn(
      id: '${habit.id}_${date.year}_${date.month}_${date.day}',
      habitId: habit.id,
      userId: userId,
      date: date,
    );

    await repository.addCheckIn(checkIn);

    final experience = _getExperience(habit);

    await userViewModel.addExperience(experience);

    _checkIns = repository.getCheckIns(userId);

    notifyListeners();
  }

  Future<void> removeCheckIn({
    required Habit habit,
    required String userId,
    required DateTime date,
  }) async {
    final existingCheckIn = repository.getCheckIn(
      habit.id,
      userId,
      date,
    );

    if (existingCheckIn == null) {
      return;
    }

    await repository.deleteCheckIn(existingCheckIn.id);

    final experience = _getExperience(habit);

    await userViewModel.removeExperience(experience);

    _checkIns = repository.getCheckIns(userId);

    notifyListeners();
  }

  int get bestStreak {
    if (_checkIns.isEmpty) {
      return 0;
    }

    final dates = _checkIns
        .map(
          (checkIn) => DateTime(
        checkIn.date.year,
        checkIn.date.month,
        checkIn.date.day,
      ),
    )
        .toSet()
        .toList();

    dates.sort();

    int best = 1;
    int current = 1;

    for (int i = 1; i < dates.length; i++) {
      final difference = dates[i].difference(dates[i - 1]).inDays;

      if (difference == 1) {
        current++;
      } else {
        current = 1;
      }

      if (current > best) {
        best = current;
      }
    }

    return best;
  }

  // MÉTODOS PARA CALCULAR A NOVA ESTATÍSTICA
  double getOverallMonthlyProgress(
    List<Habit> habits,
    DateTime month,
  ) {
    int totalExpected = 0;
    int totalCompleted = 0;

    for (final habit in habits) {
      totalExpected += getHabitExpectedForMonth(
        habit,
        month,
      );

      totalCompleted += getHabitCompletedForMonth(
        habit,
        month,
      );
    }

    if (totalExpected == 0) {
      return 0;
    }

    return (totalCompleted / totalExpected).clamp(
      0.0,
      1.0,
    );
  }

  bool _isHabitScheduledForDate(
    Habit habit,
    DateTime date,
  ) {
    switch (habit.frequency) {
      case 'Diário':
        return true;

      case 'Semanal':
      case 'Personalizado':
        return habit.customDays.contains(date.weekday);

      default:
        return false;
    }
  }

  int getHabitExpectedForMonth(
    Habit habit,
    DateTime month,
  ) {
    final firstDay = DateTime(
      month.year,
      month.month,
      1,
    );

    final lastDay = DateTime(
      month.year,
      month.month + 1,
      0,
    );

    final habitCreatedAt = DateTime(
      habit.createdAt.year,
      habit.createdAt.month,
      habit.createdAt.day,
    );

    int expected = 0;

    for (
      DateTime date = firstDay;
      !date.isAfter(lastDay);
      date = date.add(const Duration(days: 1))
    ) {
      // Não conta dias anteriores à criação do hábito.
      if (date.isBefore(habitCreatedAt)) {
        continue;
      }

      if (_isHabitScheduledForDate(habit, date)) {
        expected++;
      }
    }

    return expected;
  }

  int getHabitCompletedForMonth(
    Habit habit,
    DateTime month,
  ) {
    final firstDay = DateTime(
      month.year,
      month.month,
      1,
    );

    final lastDay = DateTime(
      month.year,
      month.month + 1,
      0,
    );

    final habitCreatedAt = DateTime(
      habit.createdAt.year,
      habit.createdAt.month,
      habit.createdAt.day,
    );

    return _checkIns
        .where((checkIn) {
          if (checkIn.habitId != habit.id) {
            return false;
          }

          final date = DateTime(
            checkIn.date.year,
            checkIn.date.month,
            checkIn.date.day,
          );

          if (date.isBefore(firstDay) ||
              date.isAfter(lastDay)) {
            return false;
          }

          if (date.isBefore(habitCreatedAt)) {
            return false;
          }

          return _isHabitScheduledForDate(
            habit,
            date,
          );
        })
        .map(
          (checkIn) => DateTime(
            checkIn.date.year,
            checkIn.date.month,
            checkIn.date.day,
          ),
        )
        .toSet()
        .length;
  }

  double getHabitMonthlyProgress(
    Habit habit,
    DateTime month,
  ) {
    final expected = getHabitExpectedForMonth(
      habit,
      month,
    );

    if (expected == 0) {
      return 0;
    }

    final completed = getHabitCompletedForMonth(
      habit,
      month,
    );

    return (completed / expected).clamp(
      0.0,
      1.0,
    );
  }

  double getSuccessRate(List<Habit> habits) {
    if (habits.isEmpty) {
      return 0;
    }

    int expected = 0;
    int completed = 0;

    final today = DateTime.now();
    final currentDate = DateTime(
      today.year,
      today.month,
      today.day,
    );

    for (final habit in habits) {
      final startDate = DateTime(
        habit.createdAt.year,
        habit.createdAt.month,
        habit.createdAt.day,
      );

      if (startDate.isAfter(currentDate)) {
        continue;
      }

      final habitCheckIns = _checkIns
          .where((checkIn) => checkIn.habitId == habit.id)
          .toList();

      switch (habit.frequency) {
        case 'Diário':
          final totalDays = currentDate
              .difference(startDate)
              .inDays +
              1;

          expected += totalDays;

          completed += habitCheckIns
              .map(
                (checkIn) => DateTime(
              checkIn.date.year,
              checkIn.date.month,
              checkIn.date.day,
            ),
          )
              .toSet()
              .where(
                (date) =>
            !date.isBefore(startDate) &&
                !date.isAfter(currentDate),
          )
              .length;

          break;

        case 'Semanal':
          final totalDays = currentDate
              .difference(startDate)
              .inDays +
              1;

          expected += ((totalDays - 1) ~/ 7) + 1;

          final weeks = <int>{};

          for (final checkIn in habitCheckIns) {
            final date = DateTime(
              checkIn.date.year,
              checkIn.date.month,
              checkIn.date.day,
            );

            if (date.isBefore(startDate) ||
                date.isAfter(currentDate)) {
              continue;
            }

            final week = date.difference(startDate).inDays ~/ 7;
            weeks.add(week);
          }

          completed += weeks.length;

          break;

        case 'Personalizado':
          for (
          DateTime date = startDate;
          !date.isAfter(currentDate);
          date = date.add(const Duration(days: 1))
          ) {
            if (habit.customDays.contains(date.weekday)) {
              expected++;
            }
          }

          completed += habitCheckIns
              .map(
                (checkIn) => DateTime(
              checkIn.date.year,
              checkIn.date.month,
              checkIn.date.day,
            ),
          )
              .toSet()
              .where(
                (date) =>
            !date.isBefore(startDate) &&
                !date.isAfter(currentDate) &&
                habit.customDays.contains(date.weekday),
          )
              .length;

          break;
      }
    }

    if (expected == 0) {
      return 0;
    }

    return completed / expected;
  }
}