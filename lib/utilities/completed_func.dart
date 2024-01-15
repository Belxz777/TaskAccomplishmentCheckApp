import 'package:reachgoal/models/habit.dart';

bool isHabitCompleted(List<DateTime> completedDays){
  final today = DateTime.now();
  return completedDays.any((element) => 
    element.day == today.day &&
    element.month == today.month &&
    element.year == today.year
    );
}
Map<DateTime, int> prepateHeatMapList(List<Habit> habits){
  Map<DateTime, int> dataset   = {};
  for(var habit in habits){
    for(var date in habit.completedDays){
      final normDate = DateTime(date.year,date.month,date.day);
  if(dataset.containsKey(normDate)){
    dataset[normDate] =dataset[normDate]! +1;
  }
  else{
    dataset[normDate] = 1;
  }

  }
      }
  return dataset;
}