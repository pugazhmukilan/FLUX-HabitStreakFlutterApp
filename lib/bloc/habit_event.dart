part of 'habit_bloc.dart';

@immutable
sealed class HabitEvent {}
final class AddHabit extends HabitEvent {
  final String habitName;

  AddHabit(this.habitName);
}

final class GetHabit extends HabitEvent {

}

final class DeleteHabit extends HabitEvent {
  final String habitName;

  DeleteHabit(this.habitName);
}

final class ToggleHabit extends HabitEvent {
  final String habitName;

  ToggleHabit(this.habitName);
}