import 'package:bloc/bloc.dart';
import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:track/Models/habithive.dart';

part 'habit_event.dart';
part 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  // Get references to the Hive boxes
  final Box<Habit> habitBox = Hive.box<Habit>('habits');
  final Box<int> heatmapBox = Hive.box<int>('heatmap');
  final Box settingsBox = Hive.box('settings');

  HabitBloc() : super(HabitInitial()) {
    // Run the daily refresh check when the BLoC is created
    _refreshthehabits();

    on<GetHabit>((event, emit) {
      // Load all data from Hive and emit the loaded state
      final habits = habitBox.toMap().cast<String, Habit>();
      final heatmapEntries = heatmapBox.toMap().entries.map((entry) {
        // Keys are stored as strings 'yyyy-MM-dd', parse them back to DateTime
        return ContributionEntry(DateTime.parse(entry.key), entry.value);
      }).toList();

      emit(HabitLoaded(habits: habits, heatmapEntries: heatmapEntries));
    });

    on<AddHabit>((event, emit) {
      final newHabit = Habit(isDone: false, lastUpdated: DateTime.now());
      habitBox.put(event.habitName, newHabit);
      add(GetHabit()); // Reload all data and update UI
    });

    on<DeleteHabit>((event, emit) {
      habitBox.delete(event.habitName);
      add(GetHabit()); // Reload all data and update UI
    });

    on<ToggleHabit>((event, emit) {
      final habit = habitBox.get(event.habitName);

      if (habit != null && !habit.isDone) {
        // 1. Update and save the habit object
        habit.setisdonetotrue();
        habit.updatedate();
        habit.save(); // Persist changes to the habit in the box

        // 2. Update the heatmap data for today
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final todayKey = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

        // Get current count for today, default to 0, then increment
        int completedToday = heatmapBox.get(todayKey, defaultValue: 0) ?? 0;
        completedToday++;
        heatmapBox.put(todayKey, completedToday);

        print("Habit '${event.habitName}' completed. Today's count: $completedToday");

        add(GetHabit()); // Reload all data and update UI
      } else {
        print("Habit '${event.habitName}' is null or was already completed.");
      }
    });
  }

  void _refreshthehabits() {
    print("\n--- 🔄 Running Daily Habit Refresh 🔄 ---");
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    print("Today's Date (for comparison): $today\n");

    // Reset all habits if the day has changed
    for (var key in habitBox.keys) {
      final habit = habitBox.get(key);
      if (habit != null && habit.lastUpdated.isBefore(today)) {
        print("     ❗️ RESETTING '$key'. Last update was before today.");
        habit.setisdonetofalse();
        habit.updatedate();
        habit.save(); // Save the reset state
        print("     ✨ '$key' is now: isDone=${habit.isDone}, lastUpdated=${habit.lastUpdated}\n");
      }
    }
    print("--- ✅ Habit Refresh Complete ✅ ---\n");
  }
}