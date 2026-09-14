// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get login => 'Entrar';

  @override
  String get enterEmail => 'Informe o e-mail.';

  @override
  String get enterPassword => 'Informe a senha.';

  @override
  String get invalidEmail => 'O e-mail informado é inválido.';

  @override
  String get userNotFound => 'Usuário não encontrado.';

  @override
  String get wrongPassword => 'Senha incorreta.';

  @override
  String get invalidCredential => 'E-mail ou senha incorretos.';

  @override
  String get emailAlreadyInUse => 'Este e-mail já está cadastrado.';

  @override
  String get weakPassword => 'A senha é muito fraca.';

  @override
  String get networkRequestFailed => 'Verifique sua conexão com a internet.';

  @override
  String get tooManyRequests => 'Muitas tentativas. Tente novamente mais tarde.';

  @override
  String get authenticationError => 'Ocorreu um erro durante a autenticação.';

  @override
  String get appTitle => 'Tracking Your Habits';

  @override
  String get loginSuccess => 'Login realizado com sucesso!';

  @override
  String get habits => 'Hábitos';

  @override
  String get noHabits => 'Nenhum hábito cadastrado.';

  @override
  String get newHabit => 'Novo hábito';

  @override
  String get editHabit => 'Editar hábito';

  @override
  String get name => 'Nome';

  @override
  String get description => 'Descrição';

  @override
  String get frequency => 'Frequência';

  @override
  String get daily => 'Diário';

  @override
  String get weekly => 'Semanal';

  @override
  String get custom => 'Personalizado';

  @override
  String get customDays => 'Dias da semana';

  @override
  String get monday => 'Segunda';

  @override
  String get tuesday => 'Terça';

  @override
  String get wednesday => 'Quarta';

  @override
  String get thursday => 'Quinta';

  @override
  String get friday => 'Sexta';

  @override
  String get saturday => 'Sábado';

  @override
  String get sunday => 'Domingo';

  @override
  String get saveHabit => 'Salvar hábito';

  @override
  String get saveChanges => 'Salvar alterações';

  @override
  String get enterHabitName => 'Informe o nome do hábito.';

  @override
  String get selectCustomDay => 'Selecione pelo menos um dia da semana.';

  @override
  String get deleteHabit => 'Excluir hábito';

  @override
  String deleteHabitConfirmation(String habitName) {
    return 'Deseja excluir o hábito \"$habitName\"?';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get forgotPassword => 'Esqueceu sua senha?';

  @override
  String get passwordResetEmailSent => 'E-mail de recuperação de senha enviado.';

  @override
  String get confirm => 'Confirmar';

  @override
  String get createAccount => 'Criar uma conta';

  @override
  String get verifyEmail => 'Verifique seu e-mail';

  @override
  String get verificationEmailDescription => 'Enviamos um link de confirmação para seu e-mail. Confirme seu e-mail para finalizar o cadastro.';

  @override
  String get alreadyVerified => 'Já confirmei meu e-mail';

  @override
  String get resendVerificationEmail => 'Enviar e-mail novamente';

  @override
  String get emailNotVerified => 'Seu e-mail ainda não foi confirmado.';

  @override
  String get verificationEmailSent => 'E-mail de confirmação enviado.';

  @override
  String get logout => 'Sair';

  @override
  String level(Object level) {
    return 'Nível $level';
  }

  @override
  String get bestStreak => '🔥 Melhor sequência';

  @override
  String days(Object count) {
    return '$count dia(s)';
  }

  @override
  String get calendar => 'Calendário';

  @override
  String get statistics => 'Estatísticas';

  @override
  String get performance => 'Desempenho';

  @override
  String successRate(Object rate) {
    return 'Taxa de sucesso: $rate%';
  }

  @override
  String get undoCompletion => 'Desfazer conclusão';

  @override
  String get markAsCompleted => 'Marcar como concluído';

  @override
  String get weekday => 'Dia da semana';

  @override
  String get selectWeekday => 'Selecione um dia da semana.';

  @override
  String get noHabitsForDay => 'Nenhum hábito previsto para este dia.';

  @override
  String get january => 'Janeiro';

  @override
  String get february => 'Fevereiro';

  @override
  String get march => 'Março';

  @override
  String get april => 'Abril';

  @override
  String get may => 'Maio';

  @override
  String get june => 'Junho';

  @override
  String get july => 'Julho';

  @override
  String get august => 'Agosto';

  @override
  String get september => 'Setembro';

  @override
  String get october => 'Outubro';

  @override
  String get november => 'Novembro';

  @override
  String get december => 'Dezembro';

  @override
  String get confirmPassword => 'Confirmar senha';

  @override
  String get enterName => 'Informe seu nome.';

  @override
  String get passwordMinLength => 'A senha deve ter pelo menos 6 caracteres.';

  @override
  String get confirmPasswordError => 'Confirme a senha.';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem.';

  @override
  String get alreadyHaveAccount => 'Já tenho uma conta.';

  @override
  String get accountCreationError => 'Erro ao criar a conta.';

  @override
  String get takePhoto => 'Tirar foto';

  @override
  String get chooseFromGallery => 'Escolher da galeria';

  @override
  String get removePhoto => 'Remover foto';

  @override
  String get home => 'Início';

  @override
  String get todayHabits => 'Hábitos de hoje';

  @override
  String get noHabitsToday => 'Nenhum hábito para hoje.';

  @override
  String experienceProgress(int current, int required) {
    return '$current XP / $required XP';
  }

  @override
  String get icon => 'Ícone';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Excluir';

  @override
  String get overallProgress => 'Progresso geral';

  @override
  String get noHabitsRegistered => 'Nenhum hábito cadastrado.';

  @override
  String get statisticsReport => 'Relatório de Estatísticas';

  @override
  String get generatedAt => 'Gerado em';

  @override
  String get completed => 'concluídos';

  @override
  String get exportPdf => 'Exportar PDF';

  @override
  String get levelLabel => 'Nível';

  @override
  String get experienceLabel => 'Experiência';

  @override
  String get pageLabel => 'Página';

  @override
  String reportPeriod(int month, int year) {
    return 'Período: $month/$year';
  }

  @override
  String habitCompletedCount(int completed, int expected) {
    return '$completed de $expected concluídos';
  }
}
