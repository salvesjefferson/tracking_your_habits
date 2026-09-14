import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_your_habits/src/datasources/user_datasource.dart';
import 'package:tracking_your_habits/src/models/user.dart';
import 'package:tracking_your_habits/src/repositories/user_repository.dart';
import 'package:tracking_your_habits/src/viewmodels/user_viewmodel.dart';

class FakeUserDataSource implements UserDataSource {
  User? user;

  @override
  User? getUser(String id) {
    return user;
  }

  @override
  Future<void> saveUser(User user) async {
    this.user = user;
  }

  @override
  Future<void> updateUser(User user) async {
    this.user = user;
  }
}

void main() {
  test('deve exigir 100 XP no nível 1', () {
    // Arrange
    final dataSource = FakeUserDataSource();
    final repository = UserRepository(dataSource);
    final viewModel = UserViewModel(repository);

    // Act
    final requiredXp = viewModel.requiredExperience;

    // Assert
    expect(requiredXp, 100);
  });

  test('deve adicionar 50 XP e permanecer no nível 1', () async {
    // Arrange
    final dataSource = FakeUserDataSource();
    final repository = UserRepository(dataSource);
    final viewModel = UserViewModel(repository);

    final user = User(
      id: '1',
      name: 'Usuário Teste',
      email: 'teste@email.com',
    );

    await viewModel.saveUser(user);

    // Act
    await viewModel.addExperience(50);

    // Assert
    expect(viewModel.level, 1);
    expect(viewModel.experience, 50);
  });

  test('deve subir para o nível 2 ao atingir 100 XP', () async {
    // Arrange
    final dataSource = FakeUserDataSource();
    final repository = UserRepository(dataSource);
    final viewModel = UserViewModel(repository);

    final user = User(
      id: '1',
      name: 'Usuário Teste',
      email: 'teste@email.com',
    );

    await viewModel.saveUser(user);

    // Act
    await viewModel.addExperience(100);

    // Assert
    expect(viewModel.level, 2);
    expect(viewModel.experience, 0);
    expect(viewModel.requiredExperience, 150);
  });

  test('deve subir para o nível 2 e manter o XP restante', () async {
    // Arrange
    final dataSource = FakeUserDataSource();
    final repository = UserRepository(dataSource);
    final viewModel = UserViewModel(repository);

    final user = User(
      id: '1',
      name: 'Usuário Teste',
      email: 'teste@email.com',
    );

    await viewModel.saveUser(user);

    // Act
    await viewModel.addExperience(120);

    // Assert
    expect(viewModel.level, 2);
    expect(viewModel.experience, 20);
    expect(viewModel.requiredExperience, 150);
  });

}