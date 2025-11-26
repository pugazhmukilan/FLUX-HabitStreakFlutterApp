part of 'habit_bloc.dart';

@immutable
sealed class HabitState {}

final class HabitInitial extends HabitState {}
final class HabitChanged extends HabitState {
  final Map<String,Habit> habits;

  HabitChanged(this.habits);
}
