import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 1)
class Habit extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String frequency;

  @HiveField(4)
  final List<int> customDays;

  @HiveField(5)
  final String userId;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
final String iconName;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.frequency,
    this.customDays = const [],
    required this.userId,
    required this.createdAt,
    this.iconName = 'icon_habit',
  });
}