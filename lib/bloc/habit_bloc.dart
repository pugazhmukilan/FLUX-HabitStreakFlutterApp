import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:track/Models/habit.dart';

part 'habit_event.dart';
part 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  HabitBloc() : super(HabitInitial()) {
    Map<String,Habit> habits = {
    "Drink Water":new Habit( isDone: false, lastUpdated: DateTime.now()),
    };


    void refreshthehabits(){
      print("\n--- 🔄 Running Daily Habit Refresh 🔄 ---");
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      print("Today's Date (for comparison): $today\n");

      if (habits.isEmpty) {
        print("No habits to refresh.");
        print("--- ✅ Habit Refresh Complete ✅ ---\n");
        return;
      }

      habits.forEach((key,habit) {
        print("   - Checking habit: '$key' | Last Updated: ${habit.lastUpdated}");
        if(habit.lastUpdated.isBefore(today)){
          print("     ❗️ RESETTING '$key'. Last update was before today.");
          habit.setisdonetotrue();
          habit.updatedate();
          print("     ✨ '$key' is now: isDone=${habit.isDone}, lastUpdated=${habit.lastUpdated}\n");
        } else {
          print("     ✅ SKIPPING '$key'. Already updated today.\n");
        }
      });
      print("--- ✅ Habit Refresh Complete ✅ ---\n");
    }


    refreshthehabits();



    on<HabitEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<AddHabit>((event,emit){
      habits.putIfAbsent(event.habitName,() => new Habit( isDone: false, lastUpdated: DateTime.now()));
      emit(HabitChanged(Map.from(habits)));

    });

    on<GetHabit>((event,emit){
      emit(HabitChanged(habits));
    });


    on<DeleteHabit>((event,emit){
      habits.remove(event.habitName);
      emit(HabitChanged(habits));
    });


    on<ToggleHabit>((event,emit){
      
      if( habits[event.habitName]!= null){
         habits[event.habitName]?.setisdonetotrue();

      } 
      emit(HabitChanged(habits));
    });

  }
}
