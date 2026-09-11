import 'package:provider/provider.dart';
import 'package:tracking_your_habits/src/datasources/user_datasource.dart';
import 'package:tracking_your_habits/src/repositories/user_repository.dart';

import 'datasources/auth_datasource.dart';
import 'repositories/auth_repository.dart';
import 'viewmodels/login_viewmodel.dart';

import 'datasources/habit_datasource.dart';
import 'repositories/habit_repository.dart';
import 'viewmodels/habit_viewmodel.dart';

import 'viewmodels/user_viewmodel.dart';

import 'viewmodels/register_viewmodel.dart';

import 'datasources/checkin_datasource.dart';
import 'repositories/checkin_repository.dart';
import 'viewmodels/checkin_viewmodel.dart';

import 'repositories/theme_repository.dart';
import 'viewmodels/theme_viewmodel.dart';

import 'repositories/photo_repository.dart';
import 'viewmodels/photo_viewmodel.dart';

final appProviders = [
  Provider<AuthDataSource>(
    create: (_) => AuthDataSource(),
  ),

  Provider<AuthRepository>(
    create: (context) {
      return AuthRepository(
        context.read<AuthDataSource>(),
      );
    },
  ),

  ChangeNotifierProvider<LoginViewModel>(
    create: (context) {
      return LoginViewModel(
        context.read<AuthRepository>(),
      );
    },
  ),

  ChangeNotifierProvider<RegisterViewModel>(
    create: (context) {
      return RegisterViewModel(
        context.read<AuthRepository>(),
      );
    },
  ),

  Provider<HabitDataSource>(
    create: (_) => HabitDataSource(),
  ),

  Provider<HabitRepository>(
    create: (context) {
      return HabitRepository(
        context.read<HabitDataSource>(),
      );
    },
  ),

  ChangeNotifierProvider<HabitViewModel>(
    create: (context) {
      return HabitViewModel(
        context.read<HabitRepository>(),
      );
    },
  ),

  Provider<UserDataSource>(
    create: (_) => UserDataSource(),
  ),

  Provider<UserRepository>(
    create: (context) {
      return UserRepository(
        context.read<UserDataSource>(),
      );
    },
  ),

  ChangeNotifierProvider<UserViewModel>(
    create: (context) {
      return UserViewModel(
        context.read<UserRepository>(),
      );
    },
  ),

  Provider<CheckInDataSource>(
    create: (_) => CheckInDataSource(),
  ),

  Provider<CheckInRepository>(
    create: (context) {
      return CheckInRepository(
        context.read<CheckInDataSource>(),
      );
    },
  ),

  ChangeNotifierProvider<CheckInViewModel>(
    create: (context) {
      return CheckInViewModel(
        context.read<CheckInRepository>(),
        context.read<UserViewModel>(),
      );
    },
  ),

  Provider<ThemeRepository>(
    create: (_) => ThemeRepository(),
  ),

  ChangeNotifierProvider<ThemeViewModel>(
    create: (context) {
      final viewModel = ThemeViewModel(
        context.read<ThemeRepository>(),
      );

      viewModel.loadTheme();

      return viewModel;
    },
  ),

  Provider<PhotoRepository>(
    create: (_) => PhotoRepository(),
  ),

  ChangeNotifierProvider<PhotoViewModel>(
    create: (context) {
      return PhotoViewModel(
        context.read<PhotoRepository>(),
      );
    },
  ),
];