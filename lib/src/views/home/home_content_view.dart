import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../viewmodels/checkin_viewmodel.dart';
import '../../viewmodels/habit_viewmodel.dart';
import '../../viewmodels/photo_viewmodel.dart';
import '../../viewmodels/user_viewmodel.dart';
import '../../viewmodels/checkin_viewmodel.dart';
import '../../widgets/habit_check_card.dart';

class HomeContentView extends StatelessWidget {
  const HomeContentView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final localizations = MaterialLocalizations.of(context);

    final weekDay =
        localizations.formatFullDate(now).split(',').first;

    final formattedWeekDay =
        weekDay[0].toUpperCase() + weekDay.substring(1);

    final date = localizations.formatMediumDate(now);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DIA ATUAL
          Center(
            child: Column(
              children: [
                Text(
                  formattedWeekDay,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // PERFIL
          Consumer<UserViewModel>(
            builder: (context, userViewModel, child) {
              final user = userViewModel.user;

              if (user == null) {
                return const SizedBox();
              }

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // FOTO DO PERFIL
                          Consumer<PhotoViewModel>(
                            builder: (context, photoViewModel, child) {
                              return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return SafeArea(
                                        child: Wrap(
                                          children: [
                                            ListTile(
                                              leading: const Icon(
                                                Icons.camera_alt,
                                              ),
                                              title: Text(l10n.takePhoto),
                                              onTap: () {
                                                Navigator.pop(context);

                                                photoViewModel.takePhoto(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid,
                                                );
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                Icons.photo_library,
                                              ),
                                              title: Text(
                                                l10n.chooseFromGallery,
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);

                                                photoViewModel.pickPhoto(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid,
                                                );
                                              },
                                            ),
                                            if (photoViewModel.photoPath != null)
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.delete,
                                                ),
                                                title: Text(
                                                  l10n.removePhoto,
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context);

                                                  photoViewModel.removePhoto(
                                                    FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid,
                                                  );
                                                },
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },

                                child: CircleAvatar(
                                  radius: 42,
                                  backgroundImage:
                                      photoViewModel.photoPath != null
                                          ? FileImage(
                                              File(
                                                photoViewModel.photoPath!,
                                              ),
                                            )
                                          : null,
                                  child: photoViewModel.photoPath == null
                                      ? const Icon(
                                          Icons.person,
                                          size: 42,
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),

                          const SizedBox(width: 16),

                          // INFORMAÇÕES DO USUÁRIO
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  l10n.level(user.level),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge,
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  '${user.experience} XP / '
                                  '${userViewModel.requiredExperience} XP',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      const Divider(),

                      const SizedBox(height: 8),

                      // MELHOR SEQUÊNCIA
                      Consumer<CheckInViewModel>(
                        builder: (
                          context,
                          checkInViewModel,
                          child,
                        ) {
                          return Row(
                            children: [
                              const Icon(
                                Icons.local_fire_department,
                              ),

                              const SizedBox(width: 8),

                              Text(
                                '${l10n.bestStreak}: '
                                '${l10n.days(checkInViewModel.bestStreak)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // HÁBITOS DE HOJE
          Text(
            l10n.todayHabits,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Consumer<HabitViewModel>(
            builder: (context, habitViewModel, child) {
              final habits = habitViewModel.todayHabits;

              if (habits.isEmpty) {
                return Text(
                  l10n.noHabitsToday,
                );
              }

            return Consumer<CheckInViewModel>(
              builder: (context, checkInViewModel, child) {
                final firebaseUser = FirebaseAuth.instance.currentUser;

                if (firebaseUser == null) {
                  return const SizedBox();
                }

                final today = DateTime.now();

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];

                    final isCompleted = checkInViewModel.isCheckedIn(
                      habit.id,
                      firebaseUser.uid,
                      today,
                    );

                    return HabitCheckCard(
                      habit: habit,
                      isCompleted: isCompleted,
                      onChanged: (value) async {
                        if (value == true) {
                          await checkInViewModel.checkIn(
                            habit: habit,
                            userId: firebaseUser.uid,
                            date: today,
                          );
                        } else {
                          await checkInViewModel.removeCheckIn(
                            habit: habit,
                            userId: firebaseUser.uid,
                            date: today,
                          );
                        }
                      },
                    );
                  },
                );
              },
            );
            },
          ),
        ],
      ),
    );
  }
}