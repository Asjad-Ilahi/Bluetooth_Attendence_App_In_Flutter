import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
part 'student_dataset.g.dart';

@HiveType(typeId: 1)
class Student extends HiveObject{
  @HiveField(0)
  String name;

  @HiveField(1)
  String regNo;

  @HiveField(2)
  String macAddress;

  Student({required this.name, required this.regNo, required this.macAddress});
 }