import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:tracking_your_habits/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'deve fazer login, criar um hábito e exibi-lo na lista',
    (WidgetTester tester) async {
      // carrega os dados de login de usuário teste criado e com email confirmado.
      const testEmail = 'salves.jefferson@gmail.com';
      const testPassword = '123456';

      // 1. inicia o app
      await app.main();
      await tester.pumpAndSettle();

      // 2. se estiver na tela de login, faz login com os dados salvos
      final loginFields = find.byType(TextFormField);

      if (loginFields.evaluate().length == 2) {
        // e-mail
        await tester.enterText(
          loginFields.at(0),
          testEmail,
        );

        // senha
        await tester.enterText(
          loginFields.at(1),
          testPassword,
        );

        // confirma Login
        await tester.tap(
          find.byType(ElevatedButton).first,
        );

        await tester.pumpAndSettle();
      }

      // 3. verifica se chegou na homeview
      expect(
        find.byType(NavigationBar),
        findsOneWidget,
      );

      final destinations = find.byType(NavigationDestination);

      expect(
        destinations,
        findsNWidgets(4),
      );

      // 4. abre a aba hábitos
      await tester.tap(
        destinations.at(2),
      );

      await tester.pumpAndSettle();

      // 5. confirma se o botão + tá na tela
      expect(
        find.byType(FloatingActionButton),
        findsOneWidget,
      );

      // abre criação de hábito
      await tester.tap(
        find.byType(FloatingActionButton),
      );

      await tester.pumpAndSettle();

      // 6. procura os campos do formulário
      final habitFields = find.byType(TextFormField);

      expect(
        habitFields,
        findsNWidgets(2),
      );

      // nome
      await tester.enterText(
        habitFields.at(0),
        'Hábito Teste',
      );

      // descrição
      await tester.enterText(
        habitFields.at(1),
        'Criado pelo teste de integração',
      );

      // 7. salva
      await tester.tap(
        find.byType(ElevatedButton),
      );

      await tester.pumpAndSettle();

      // 8. verifica se o hábito apareceu
      expect(
        find.text('Hábito Teste'),
        findsOneWidget,
      );

      expect(
        find.text('Criado pelo teste de integração'),
        findsOneWidget,
      );

      // 9. localiza o hábito criado
      final habitText = find.text('Hábito Teste');

      expect(
        habitText,
        findsOneWidget,
      );

      // 10. procura o botão de excluir
      final deleteButtons = find.byIcon(Icons.delete);

      expect(
        deleteButtons,
        findsWidgets,
      );

      // como o hábito foi criado por último, usa o último botão de excluir
      await tester.tap(
        deleteButtons.last,
      );

      await tester.pumpAndSettle();

      // 11. confirma exclusão no diálogo
      expect(
        find.byType(AlertDialog),
        findsOneWidget,
      );

      // confirma usando o botão disponível na tela
      final dialogButtons = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextButton),
      );

      expect(
        dialogButtons,
        findsWidgets,
      );

      // confirma se o último botão é o de confirmar exclusão
      await tester.tap(
        dialogButtons.last,
      );

      await tester.pumpAndSettle();

      // 12. confirma see o hábito foi removido
      expect(
        find.text('Hábito Teste'),
        findsNothing,
      );

    },
  );
}