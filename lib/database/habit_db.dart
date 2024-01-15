import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reachgoal/models/app_settings.dart';
import 'package:reachgoal/models/habit.dart';
class HabitDb extends ChangeNotifier{
  // Future является ключевым классом для написания асинхронного кода https://metanit.com/dart/tutorial/7.2.php?ysclid=lr7i4h6lye958039997
  //определяем статическую переменную с отложенной инициализацией Isar
  // с помощью нее мы сможем управлять , взаимодействовать с базой данн��х
static late Isar isar;
// функция инициализации
static Future <void> initialize() async {
//иницилизируем базу данных , а именно наши модели привычки и настройки прилоджения 
final dir = await getApplicationDocumentsDirectory();
isar = await Isar.open(
  [HabitSchema,AppSettingSchema], 
  directory: dir.path);

}
//фукция сохранения первой загрузочной даты
Future<void> saveFirstLaunchDate() async{
// созраняем первую загрузочную дату , что бы от нее отталкиваться 
// 
  final existSettings  = await isar.appSettings.where().findFirst();
  if(existSettings == null){
    final  settings = AppSetting()..firstLaunchDate = DateTime.now();
    await isar.writeTxn(() => isar.appSettings.put(settings));
  }
}
//получаем первую дату запуска 
Future<DateTime?> getFirstLaunchDate() async{
  final settings  = await isar.appSettings.where().findFirst();
  return settings?.firstLaunchDate;
}
// теперь реализуем crud , то есть  создаем функционал создания , изменения и удаления привычек 
final List<Habit> currentHabits = [];
  Future<void> addHabit(
      String habitName, String about, DateTime reachAt) async {
    final newHabit = Habit()
      ..name = habitName
      ..about = about
      ..createdAt = DateTime.now()
      ..reachAt = reachAt;

    await isar.writeTxn(() async {
      await isar.habits.put(newHabit);
    });

    readHabits();

    return;
  }
//обновление массива привычек после каждой операции что бы в  currentHabits были реально карент привычек

Future <void> readHabits() async {
  List<Habit> fetchedHabits = await isar.habits.where().findAll();
  currentHabits.clear();
  currentHabits.addAll(fetchedHabits);
  notifyListeners();
}
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          final today = DateTime.now();

          habit.completedDays.add(DateTime
          (today.year,
          today.month,
          today.day));
        }
        else{
          habit.completedDays.removeWhere((element) =>  
           element.year == DateTime.now().year &&
          element.month == DateTime.now().month &&
          element.day == DateTime.now().day 
          );
        }
        await isar.habits.put(habit);
      });
    }
    readHabits();
  }
Future<void> updateHabitName(int id , String newName) async{
  final habit = await isar.habits.get(id);
  if(habit!= null){
    await isar.writeTxn(() async {
      habit.name = newName;
      await isar.habits.put(habit);
    });
  }
  readHabits();
}
Future<void> deleteHabit(int id)  async{
  await isar.writeTxn(() async {
    await isar.habits.delete(id);
  });
  readHabits();
}
}