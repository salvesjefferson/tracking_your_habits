import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/checkin_viewmodel.dart';
import '../../viewmodels/habit_viewmodel.dart';

import '/../l10n/app_localizations.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statistics),
      ),
      body: Consumer2<CheckInViewModel, HabitViewModel>(
        builder: (
          context,
          checkInViewModel,
          habitViewModel,
          child,
        ) {
          final bestStreak = checkInViewModel.bestStreak;
          final currentMonth = DateTime.now();
          final overallProgress =
              checkInViewModel.getOverallMonthlyProgress(
            habitViewModel.habits,
            currentMonth,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    l10n.performance,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Progresso geral + porcentagem
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progresso geral',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              '${(overallProgress * 100).round()}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Barra de progresso geral
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: overallProgress,
                            minHeight: 10,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Melhor sequência
                        Row(
                          children: [
                      
                            const SizedBox(width: 8),

                            Text(
                              '${l10n.bestStreak}: '
                              '${l10n.days(bestStreak)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                if (habitViewModel.habits.isEmpty)
                  const Center(
                    child: Text(
                      'Nenhum hábito cadastrado.',
                    ),
                  ),

                ...habitViewModel.habits.map(
                  (habit) {
                    final expected =
                        checkInViewModel.getHabitExpectedForMonth(
                      habit,
                      currentMonth,
                    );

                    final completed =
                        checkInViewModel.getHabitCompletedForMonth(
                      habit,
                      currentMonth,
                    );

                    final progress =
                        checkInViewModel.getHabitMonthlyProgress(
                      habit,
                      currentMonth,
                    );

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    'assets/icons/${habit.iconName}.png',
                                    width: 36,
                                    height: 36,
                                    fit: BoxFit.cover,
                                    errorBuilder: (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {
                                      return Image.asset(
                                        'assets/icons/icon_habit.png',
                                        width: 36,
                                        height: 36,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: Text(
                                    habit.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),

                                Text(
                                  '$completed / $expected',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            _HabitProgressBar(
                              progress: progress,
                              divisions: expected,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

              ],
            ),
          );
        },
      ),
    );
  }
}

//WIDGET DE PROGRESS BAR, NÃO TÁ SEPARADO PQ SÓ É USADO AQUI

class _HabitProgressBar extends StatelessWidget {
  const _HabitProgressBar({
    required this.progress,
    required this.divisions,
  });

  final double progress;
  final int divisions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 10,
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                  ),
                ),
              ),

              if (divisions > 1)
                ...List.generate(
                  divisions - 1,
                  (index) {
                    final position =
                        constraints.maxWidth *
                        ((index + 1) / divisions);

                    return Positioned(
                      left: position - 1,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        color: Theme.of(context)
                            .colorScheme
                            .surface,
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}