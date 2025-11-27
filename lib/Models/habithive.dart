import 'package:hive/hive.dart';

part 'habithive.g.dart'; // This file will be generated

@HiveType(typeId: 0) // Unique ID for this class
class Habit extends HiveObject {
  @HiveField(0)
  late bool isDone;

  @HiveField(1)
  late DateTime lastUpdated;

  // Your existing methods are fine. Hive will use the default constructor.
  Habit({required this.isDone, required this.lastUpdated});

  void setisdonetotrue() {
    isDone = true;
  }

  void setisdonetofalse() {
    isDone = false;
  }

  void updatedate() {
    final now = DateTime.now();
    lastUpdated = DateTime(now.year, now.month, now.day);
  }
  
}