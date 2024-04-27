
import 'package:final_bluetooth/all_studentData.dart';
import 'package:final_bluetooth/present_student.dart';
import 'package:final_bluetooth/spinner_cube.dart';
import 'package:final_bluetooth/student_dataset.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'all_bluetoothScan.dart';
import 'home_page.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();


  await Hive.initFlutter(directory.path);
  Hive.registerAdapter(StudentAdapter());
  await Hive.openBox<Student>('studentData');

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context)=>const SpinnerOnStartup(duration: Duration(seconds: 4),child:MyHomePage()),
      '/home': (context)=>const MyHomePage(),
      '/second': (context)=>const AllStudents(),
      '/third':(context)=>const BluetoothDevices(),
      '/fourth': (context)=>const PresentStudents(),
    },
  ));
}


