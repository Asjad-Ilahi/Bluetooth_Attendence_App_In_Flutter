import 'package:final_bluetooth/student_dataset.dart';
import 'package:hive/hive.dart';

class StudentBoxes{
  static Box<Student> getData() => Hive.box<Student>('studentData');
}