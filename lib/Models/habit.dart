class Habit {
  

   bool isDone;
   DateTime lastUpdated;

  Habit({required this.isDone, required this.lastUpdated});

  // Helper method to make updating easier
  Habit copyWith({
   
    bool? isDone,
    DateTime? lastUpdated,
  }) {
    return Habit(
      
      isDone: isDone ?? this.isDone,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }


  void setisdonetotrue() {
    isDone = true;
  }
  void updatedate(){

    //should onyl contain the date

    final now = DateTime.now();
    lastUpdated = DateTime(now.year, now.month, now.day);
  }
}