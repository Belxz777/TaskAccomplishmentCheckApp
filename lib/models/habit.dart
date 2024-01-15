import 'package:isar/isar.dart';
part 'habit.g.dart';
@Collection()
class Habit {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  late String name;
  
 String? about;

  late DateTime createdAt ;
    late DateTime reachAt ;

List<DateTime> completedDays = [
];
}