import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/../l10n/app_localizations.dart';
import '../habits/habits_view.dart';
import '../login/login_view.dart';
import '../../repositories/auth_repository.dart';
import '../../viewmodels/user_viewmodel.dart';
import '../calendar/calendar_view.dart';
import '../../viewmodels/checkin_viewmodel.dart';
import '../statistics/statistics_view.dart';
import '../../viewmodels/habit_viewmodel.dart';
import '../../viewmodels/theme_viewmodel.dart';
import '../../viewmodels/photo_viewmodel.dart';
import 'home_content_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        context.read<UserViewModel>().loadOrCreateUser(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
        );

        context.read<CheckInViewModel>().loadCheckIns(
          firebaseUser.uid,
        );

        context.read<HabitViewModel>().loadHabits(
          firebaseUser.uid,
        );

        context.read<PhotoViewModel>().loadPhoto(
          firebaseUser.uid,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ThemeViewModel>().themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              context.read<ThemeViewModel>().toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
            onPressed: () async {
              await context.read<AuthRepository>().logout();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginView(),
                ),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeContentView(),
          CalendarView(),
          HabitsView(),
          StatisticsView(),
        ],
      ),      
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            label: l10n.calendar,
          ),
          NavigationDestination(
            icon: const Icon(Icons.check_circle_outline),
            selectedIcon: const Icon(Icons.check_circle),
            label: l10n.habits,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: l10n.statistics,
          ),
        ],
      ),
    );
  }
}