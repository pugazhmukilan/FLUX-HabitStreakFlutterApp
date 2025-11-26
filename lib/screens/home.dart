import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    context.read<HabitBloc>().add(GetHabit());
  }

  List<ContributionEntry> _generateTestData() {
    return [
      ContributionEntry(DateTime(2025, 4, 23), 5),
      ContributionEntry(DateTime(2025, 4, 24), 7),
      ContributionEntry(DateTime(2025, 4, 25), 6),
      ContributionEntry(DateTime(2025, 4, 29), 4),
      ContributionEntry(DateTime(2025, 5, 3), 5),
      ContributionEntry(DateTime(2025, 5, 5), 3),
      ContributionEntry(DateTime(2025, 6, 11), 9),
      ContributionEntry(DateTime(2025, 7, 28), 4),
    ];
  }

  // List<String> habits = [
  //   "Drink Water",
  //   "Exercise",
  //   "Read Books",
  //   "Meditate",
  //   "Sleep Early",
  //   "somthing",
  // ];

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
          // THEME SWITCH
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
          IconButton(
            icon: const Icon(Icons.menu_rounded),
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.greydark
                : AppColors.greylight,
            onPressed: () {
              print("Menu clicked");
            },
          ),
        ],
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            reverse: true,
            scrollDirection: Axis.horizontal,
            child: ContributionHeatmap(
              minDate: DateTime(
                DateTime.now().year - 1,
                DateTime.now().month,
                DateTime.now().day,
              ),
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
              entries: _generateTestData(),

              onCellTap: (date, value) {
                print("Tapped $date → $value");
              },
            ),
          ),
          SizedBox(height: 16),
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
                    print("pressed the new habit");
                    showtextbox(
                      context: context,
                      onAdd: (newHabit) {
                        // This adds the habit to your list and rebuilds the screen
                       context.read<HabitBloc>().add(AddHabit(newHabit));
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          Expanded(
            child: BlocBuilder<HabitBloc, HabitState>(
              builder: (context, state) {
                if (state is HabitInitial) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.greenprimary,
                    ),
                  );
                }
                if (state is HabitChanged) {
                  if (state.habits.isEmpty) {
                    return Center(child: Text("No Habits Found. Add a new one!"));
                  }
                  // Get a list of the map entries (key-value pairs)
                  final habitEntries = state.habits.entries.toList();

                  return ListView.builder(
                    itemCount: habitEntries.length,
                    itemBuilder: (context, index) {
                      final habitEntry = habitEntries[index];
                      final habitName = habitEntry.key;
                      // The value is now a Habit object, not a bool
                      final habitData = habitEntry.value;
                      final isDone = habitData.isDone;

                      return ListTile(
                        // Disable the tile if the habit is already marked as done
                        enabled: !isDone,
                        title: Text(
                          habitName,
                          style: TextStyle(
                            fontFamily: "schibstedGrotesk",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            // Add a strikethrough and change color if done
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: isDone
                                ? Colors.grey
                                : null,
                          ),
                        ),
                        // Change the trailing icon based on completion status
                        trailing: isDone
                            ? Text('🔥', style: TextStyle(fontSize: 24))
                            : Icon(Icons.check_box_outline_blank),
                        onTap: () {
                          // You can now toggle even if it's already done,
                          // to allow un-doing a mistake.
                          context.read<HabitBloc>().add(ToggleHabit(habitName));
                        },
                      );
                    },
                  );
                }
                return Center(child: Text("No Habits Found. Add a new one!"));
              },
            ),
          ),
        ],
      ),
    );
  }
}



void showtextbox({
  required BuildContext context,
  required Function(String) onAdd,
}) {
  final TextEditingController controller = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled:
        true, // Important: makes the sheet move with the keyboard
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      // This Padding adjusts for the keyboard
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
                focusColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.greylight
                    : AppColors.greydark,
                focusedBorder: OutlineInputBorder(
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.greylight
                        : AppColors.greydark,
                  ),
                ),
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
                      onAdd(controller.text); // Send the new habit back
                    }
                    Navigator.pop(context); // Close the bottom sheet
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
