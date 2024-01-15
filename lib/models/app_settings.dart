import 'package:isar/isar.dart';
part 'app_settings.g.dart';
@Collection()
class AppSetting {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment
DateTime? firstLaunchDate;
}