// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reachgoal/components/Drawer_pers.dart';
import 'package:reachgoal/components/Habit_Tile.dart';
import 'package:reachgoal/components/Heat_Map.dart';
import 'package:reachgoal/database/habit_db.dart';
import 'package:reachgoal/models/habit.dart';
import 'package:reachgoal/utilities/completed_func.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState (){
    Provider.of<HabitDb>(context, listen: false).readHabits();
    super.initState();
  }
  final TextEditingController textControl  = TextEditingController();
    final TextEditingController textAbout= TextEditingController();
  TextEditingController datePickerController = TextEditingController();
void checkHabitCompleted (bool? value,Habit habit){
  if(value != null){
  context.read<HabitDb>().updateHabitCompletion(habit.id, value);
  }
  }
onTapFunction({required BuildContext context}) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
confirmText: "confirm",
    lastDate: DateTime(2043),
    firstDate: DateTime(2024),
    initialDate: DateTime.now(),
  );
  if (pickedDate == null) return;
  //datePickerController.text = Datef\\\('yyyy-MM-dd').format(pickedDate);
}
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Flex(
          direction: Axis.vertical,
          children: [
            TextField(
        autocorrect: true,
        controller: textControl,
        decoration: InputDecoration(
          hintText: 'Создай новую  полезную привычку',
        ),
      ),

          ],
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              String name = textControl.text;
          String about = textAbout.text;
           DateTime names = DateTime.now();
              context.read<HabitDb>().addHabit(name,about,names);
              Navigator.pop(context);
              textControl.clear();
            },
            child: const Text('Сохранить'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textControl.clear();
            },
            child: const Text('Удалить'),
          )
        ],
      ),
    );
  }
  void editHabitBox(Habit habit){

    textControl.text = habit.name;

    showDialog(context: context, 
    builder: (context)=>AlertDialog(
     content:(
      TextField(controller: textControl,)
     ),
actions:[
  MaterialButton(onPressed:() {
          String name = textControl.text;
          context.read<HabitDb>().updateHabitName(habit.id,name);
          Navigator.pop(context);
          textControl.clear();

        },
        child: const Text('Сохранить'),
        ),
      MaterialButton(onPressed:() {
          Navigator.pop(context);
          textControl.clear();

        },
        child: const Text('Удалить'),) 
]
    ),
  
    );


  }
 void deleteHabitBox(Habit habit){
  showDialog(context: context,
  builder: (context)=>AlertDialog(
    title: Text('Удалить ${habit.name}?'),
    content: Text('Это действие нельзя будет отменить'),
    actions: [
      MaterialButton(onPressed:() {
        context.read<HabitDb>().deleteHabit(habit.id);
        Navigator.pop(context);
      },
      child: const Text('Удалить'),
      ),
      MaterialButton(onPressed:() {
        Navigator.pop(context);
      },
      child: const Text('Отмена'),
      )
    ],
  ),
  );
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Дневничок'),
        elevation: 0,

        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const  DrawerPers(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child:  const Icon(Icons.add),
        ),
      body: ListView(
      children: [
        _buildHeatMp(),
        _buildHabitList(),  
      ],
    ),
        );
  }
Widget _buildHeatMp() {
  final habitDb = context.watch<HabitDb>();
  List<Habit> currentHabits = habitDb.currentHabits;

  return FutureBuilder<DateTime?>(
      future: habitDb.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HeatMapCal(
              startDate: snapshot.data!,
              datasets: prepateHeatMapList(currentHabits));
        } else {
          return Container( );
        }
      });
}
Widget _buildHabitList() {
  final habitDb = context.watch<HabitDb>();
  List<Habit> currentHabits = habitDb.currentHabits;

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: currentHabits.length,
    itemBuilder: (context, index) {
      final habit = currentHabits[index];
      bool isCompletedToday = isHabitCompleted(habit.completedDays);
      return HabitTile(
        text: habit.name, 
        isCompleted: isCompletedToday,
        onChanged: (value) => checkHabitCompleted(value, habit),
        editHabit: (context) => editHabitBox(habit),
        deleteHabit: (context) => deleteHabitBox(habit),
      );
    }
  );
}

}
