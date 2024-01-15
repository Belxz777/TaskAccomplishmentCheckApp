import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String text; 
final bool isCompleted;
final  void Function(bool?)? onChanged;
final void Function(BuildContext)? editHabit;
final void Function(BuildContext)? deleteHabit;
  const HabitTile({
  super.key,
  required this.text,
  required this.isCompleted,
  required this.onChanged,
  required this.editHabit,
  required this.deleteHabit,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 25),
    child:Slidable(  
      endActionPane: ActionPane(
      motion: const StretchMotion() , 
      children: [
SlidableAction(
onPressed: editHabit,backgroundColor: Colors.blue,
icon: Icons.settings,
borderRadius: BorderRadius.circular(10)),
SlidableAction(
  onPressed: deleteHabit,backgroundColor: Colors.red,
icon: Icons.delete,
borderRadius: BorderRadius.circular(10))
      ],),
     child:Container(
      decoration:BoxDecoration(
   borderRadius: BorderRadius.circular(10),
        color: isCompleted ? Colors.green : Theme.of(context).colorScheme.secondary,
      ) ,
    child: ListTile(
      title: Text(text,style: TextStyle(color: isCompleted ? Colors.white : Theme.of(context).colorScheme.inversePrimary),),
      leading: Checkbox(
        activeColor: Color.fromARGB(171, 3, 246, 141),
        value: isCompleted,
        onChanged:onChanged ,
      ),
    ),
    padding: EdgeInsets.all(12),
    )));
  }
}