import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/Models/habithive.dart';
import 'package:track/bloc/habit_bloc.dart';
import 'package:track/bloc/theme_bloc.dart';
import 'package:track/theme/colors.dart';
import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:track/widgets/newhabitbutton.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    // Fetch the initial data when the widget is first created
    context.read<HabitBloc>().add(GetHabit());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset("assets/fluxlogo.png", height: 28),
        ),
        title: Text(
          "FLUX",
          style: TextStyle(
            fontFamily: "schibstedGrotesk",
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.greydark
                : AppColors.greylight,
          ),
        ),
        actions: [
          // THEME SWITCH (This is a separate Bloc, so it's fine here)
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return Switch(
                value: state is ThemeDark,
                inactiveThumbColor: AppColors.greydark,
                activeThumbColor: AppColors.greenprimary,
                splashRadius: 10,
                onChanged: (_) {
                  context.read<ThemeBloc>().add(ToggleTheme());
                },
              );
            },
          ),
          // HAMBURGER MENU ICON
          // IconButton(
          //   icon: const Icon(Icons.menu_rounded),
          //   color: Theme.of(context).brightness == Brightness.light
          //       ? AppColors.greydark
          //       : AppColors.greylight,
          //   onPressed: () {
          //     print("Menu clicked");
          //   },
          // ),
        ],
      ),
      // Use one BlocBuilder to control the entire body
      body: BlocBuilder<HabitBloc, HabitState>(
        builder: (context, state) {
          // Show a loading indicator while data is being fetched
          if (state is HabitInitial) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.greenprimary,
              ),
            );
          }

          // Once loaded, extract the data. Provide empty defaults for safety.
          final habits = (state is HabitLoaded) ? state.habits : <String, Habit>{};
          final heatmapEntries = (state is HabitLoaded) ? state.heatmapEntries : <ContributionEntry>[];
          final habitEntries = habits.entries.toList();

          // Build the main UI with the data from the state
          if(state  is HabitLoaded){
            return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. HEATMAP ---
              SingleChildScrollView(
                reverse: true,
                scrollDirection: Axis.horizontal,
                child: ContributionHeatmap(
                  minDate: DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day),
                  maxDate: DateTime.now(),
                  heatmapColor: HeatmapColor.green,
                  showMonthLabels: true,
                  showWeekdayLabels: false,
                  showCellDate: true,
                  cellSize: 24,
                  splittedMonthView: true,
                  startWeekday: DateTime.monday,
                  monthTextStyle: TextStyle(
                    fontFamily: "schibstedGrotesk",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.greylight
                        : AppColors.greydark,
                  ),
                  cellDateTextStyle: TextStyle(
                    fontFamily: "schibstedGrotesk",
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.green1
                        : AppColors.greydark,
                  ),
                  entries: heatmapEntries, // Use data from the state
                  onCellTap: (date, value) {
                    print("Tapped $date → $value");
                  },
                ),
              ),
              SizedBox(height: 16),

              // --- 2. HABITS HEADER ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your Habits 🔥",
                      style: TextStyle(
                        fontFamily: "schibstedGrotesk",
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    NewHabitButton(
                      Context: context,
                      onTap: () {
                        showtextbox(
                          context: context,
                          onAdd: (newHabit) {
                            context.read<HabitBloc>().add(AddHabit(newHabit));
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),

              // --- 3. HABITS LIST ---
              Expanded(
                child: habitEntries.isEmpty
                    ? Center(child: Text("No Habits Found. Add a new one!"))
                    : ListView.builder(
                        itemCount: habitEntries.length,
                        itemBuilder: (context, index) {
                          final habitEntry = habitEntries[index];
                          final habitName = habitEntry.key;
                          final habitData = habitEntry.value as Habit;
                          final isDone = habitData.isDone;

                          return ListTile(
                            enabled: !isDone,
                            title: Text(
                              habitName,
                              style: TextStyle(
                                fontFamily: "schibstedGrotesk",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                                color: isDone ? Colors.grey : null,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                isDone
                                    ? Text('🔥', style: TextStyle(fontSize: 24))
                                    : Icon(Icons.check_box_outline_blank),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () {
                                    context.read<HabitBloc>().add(DeleteHabit(habitName));
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              context.read<HabitBloc>().add(ToggleHabit(habitName));
                            },
                          );
                        },
                      ),
              ),
            ],
          );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. HEATMAP ---
              SingleChildScrollView(
                reverse: true,
                scrollDirection: Axis.horizontal,
                child: ContributionHeatmap(
                  minDate: DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day),
                  maxDate: DateTime.now(),
                  heatmapColor: HeatmapColor.green,
                  showMonthLabels: true,
                  showWeekdayLabels: false,
                  showCellDate: true,
                  cellSize: 24,
                  splittedMonthView: true,
                  startWeekday: DateTime.monday,
                  monthTextStyle: TextStyle(
                    fontFamily: "schibstedGrotesk",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.greylight
                        : AppColors.greydark,
                  ),
                  cellDateTextStyle: TextStyle(
                    fontFamily: "schibstedGrotesk",
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.green1
                        : AppColors.greydark,
                  ),
                  entries: heatmapEntries, // Use data from the state
                  onCellTap: (date, value) {
                    print("Tapped $date → $value");
                  },
                ),
              ),
              SizedBox(height: 16),

              // --- 2. HABITS HEADER ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your Habits 🔥",
                      style: TextStyle(
                        fontFamily: "schibstedGrotesk",
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    NewHabitButton(
                      Context: context,
                      onTap: () {
                        showtextbox(
                          context: context,
                          onAdd: (newHabit) {
                            context.read<HabitBloc>().add(AddHabit(newHabit));
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),

              // --- 3. HABITS LIST ---
              Expanded(
                child: habitEntries.isEmpty
                    ? Center(child: Text("No Habits Found. Add a new one!"))
                    : ListView.builder(
                        itemCount: habitEntries.length,
                        itemBuilder: (context, index) {
                          final habitEntry = habitEntries[index];
                          final habitName = habitEntry.key;
                          final habitData = habitEntry.value as Habit;
                          final isDone = habitData.isDone;

                          return ListTile(
                            enabled: !isDone,
                            title: Text(
                              habitName,
                              style: TextStyle(
                                fontFamily: "schibstedGrotesk",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                                color: isDone ? Colors.grey : null,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                isDone
                                    ? Text('🔥', style: TextStyle(fontSize: 24))
                                    : Icon(Icons.check_box_outline_blank),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () {
                                    context.read<HabitBloc>().add(DeleteHabit(habitName));
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              context.read<HabitBloc>().add(ToggleHabit(habitName));
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// This function remains unchanged as it is independent of the widget's state
void showtextbox({
  required BuildContext context,
  required Function(String) onAdd,
}) {
  final TextEditingController controller = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Habit',
              style: TextStyle(
                fontFamily: "schibstedGrotesk",
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              cursorColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.greylight
                  : AppColors.greydark,
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.greenprimary,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.greylight
                        : AppColors.greydark,
                  ),
                ),
                hintStyle: TextStyle(
                  fontFamily: "schibstedGrotesk",
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.greylight.withOpacity(0.5)
                      : AppColors.greydark.withOpacity(0.5),
                ),
                hintText: 'e.g., Read for 15 minutes',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.greylight
                          : AppColors.greydark,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      onAdd(controller.text);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}
