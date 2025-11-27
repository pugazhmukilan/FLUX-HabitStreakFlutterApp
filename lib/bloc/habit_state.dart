part of 'habit_bloc.dart';

@immutable
sealed class HabitState {}

final class HabitInitial extends HabitState {}
final class HabitChanged extends HabitState {
  final Map<String,Habit> habits;

  HabitChanged(this.habits);
}

final class updateheatmap extends HabitState {
  final List<ContributionEntry> dataset;

  updateheatmap(this.dataset);
}

class HabitLoaded extends HabitState {
  final Map<String, Habit> habits;
  final List<ContributionEntry> heatmapEntries;

  HabitLoaded({required this.habits, required this.heatmapEntries});
}
