// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get enterEmail => 'Enter your email.';

  @override
  String get enterPassword => 'Enter your password.';

  @override
  String get invalidEmail => 'The email address is invalid.';

  @override
  String get userNotFound => 'User not found.';

  @override
  String get wrongPassword => 'Incorrect password.';

  @override
  String get invalidCredential => 'Incorrect email or password.';

  @override
  String get emailAlreadyInUse => 'This email is already registered.';

  @override
  String get weakPassword => 'The password is too weak.';

  @override
  String get networkRequestFailed => 'Check your internet connection.';

  @override
  String get tooManyRequests => 'Too many attempts. Please try again later.';

  @override
  String get authenticationError => 'An error occurred during authentication.';

  @override
  String get appTitle => 'Tracking Your Habits';

  @override
  String get loginSuccess => 'Login successful!';

  @override
  String get habits => 'Habits';

  @override
  String get noHabits => 'No habits registered.';

  @override
  String get newHabit => 'New habit';

  @override
  String get editHabit => 'Edit habit';

  @override
  String get name => 'Name';

  @override
  String get description => 'Description';

  @override
  String get frequency => 'Frequency';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get custom => 'Custom';

  @override
  String get customDays => 'Days of the week';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get saveHabit => 'Save habit';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get enterHabitName => 'Enter the habit name.';

  @override
  String get selectCustomDay => 'Select at least one day of the week.';

  @override
  String get deleteHabit => 'Delete habit';

  @override
  String deleteHabitConfirmation(String habitName) {
    return 'Do you want to delete the habit \"$habitName\"?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get passwordResetEmailSent => 'Password reset email sent.';

  @override
  String get confirm => 'Confirm';

  @override
  String get createAccount => 'Create an account';

  @override
  String get verifyEmail => 'Verify your email';

  @override
  String get verificationEmailDescription => 'We sent a verification link to your email. Confirm your email to finish creating your account.';

  @override
  String get alreadyVerified => 'I have verified my email';

  @override
  String get resendVerificationEmail => 'Send email again';

  @override
  String get emailNotVerified => 'Your email has not been verified yet.';

  @override
  String get verificationEmailSent => 'Verification email sent.';

  @override
  String get logout => 'Sign out';

  @override
  String level(Object level) {
    return 'Level $level';
  }

  @override
  String get bestStreak => '🔥 Best streak';

  @override
  String days(Object count) {
    return '$count day(s)';
  }

  @override
  String get calendar => 'Calendar';

  @override
  String get statistics => 'Statistics';

  @override
  String get performance => 'Performance';

  @override
  String successRate(Object rate) {
    return 'Success rate: $rate%';
  }

  @override
  String get undoCompletion => 'Undo completion';

  @override
  String get markAsCompleted => 'Mark as completed';

  @override
  String get weekday => 'Day of the week';

  @override
  String get selectWeekday => 'Select a day of the week.';

  @override
  String get noHabitsForDay => 'No habits scheduled for this day.';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get enterName => 'Enter your name.';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters.';

  @override
  String get confirmPasswordError => 'Confirm the password.';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get alreadyHaveAccount => 'I already have an account.';

  @override
  String get accountCreationError => 'Error creating the account.';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get home => 'Home';
}
