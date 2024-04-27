import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:final_bluetooth/student_dataset.dart';
import 'all_control.dart';
import 'box_student.dart';

class PresentStudents extends StatefulWidget {
  const PresentStudents({Key? key}) : super(key: key);

  @override
  State<PresentStudents> createState() => _PresentStudentsState();
}

class _PresentStudentsState extends State<PresentStudents> {
  late StudentManager studentManager;
  late StreamSubscription<List<ScanResult>>? scanSubscription;
  bool isAttendanceStarted = false;

  @override
  void initState() {
    super.initState();
    studentManager = StudentManager();
    // Start the scan when the widget initializes
    startScan();
  }

  @override
  void dispose() {
    // Dispose the scan subscription when the widget is disposed
    scanSubscription?.cancel();
    super.dispose();
  }

  // Function to start the scan
  void startScan() {
    setState(() {
      isAttendanceStarted = true;
    });

    // Clear existing matched students
    studentManager.clearMatchedStudents();

    // Start scanning for devices
    scanSubscription = FlutterBlue.instance.scanResults.listen((List<ScanResult> scanResults) {
      studentManager.matchScannedDevices(scanResults);
      setState(() {}); // Update UI after matching devices
    });

    // Stop scanning after 10 seconds
    Timer(const Duration(seconds: 10), () {
      scanSubscription?.cancel(); // Cancel the scan subscription
      setState(() {
        isAttendanceStarted = false;
      });
      if (studentManager.matchedStudents.isEmpty) {
        // Print 'No devices found' if no devices are matched
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('No Devices Found'),
            content: Text('EveryOne Is Absent. Lanat-un-Ghalihy.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  String generatePresentStudentsText() {
    String textData = '';
    for (var student in studentManager.matchedStudents) {
      textData += 'Name: ${student.name}, MAC Address: ${student.macAddress}\n';
    }
    return textData;
  }

  // Function to save text data to a file
  Future<void> saveTextToFile(String text) async {
    final directory = await getDownloadsDirectory(); // Get the Downloads directory
    final file = File('${directory!.path}/present_students.txt');
    await file.writeAsString(text);
  }

  void downloadPresentStudentsData() {
    String presentStudentsText = generatePresentStudentsText();
    saveTextToFile(presentStudentsText).then((_) async {
      final directory = await getDownloadsDirectory();
      final file = File('${directory!.path}/present_students.txt');
      final snackBar = SnackBar(
        content: Text('File saved to: ${file.path}'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue.shade400,
        elevation: 3,
        shadowColor: Colors.grey.shade800,
        leading: IconButton(
          icon: const Icon(Icons.home, size: 35),
          onPressed: () {
            // Navigate to home when home icon is pressed
            Navigator.popAndPushNamed(context, '/home');
          },
        ),
        title: const Text(
          'Attendance',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: studentManager.matchedStudents.isNotEmpty ? downloadPresentStudentsData : null,
          ),
        ],
      ),
      body: GetBuilder<Control>(
        init: Control(),
        builder: (Control controller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center, // Align children to the top
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isAttendanceStarted
                  ? Column(
                children: [
                  CircularProgressIndicator(),
                ],
              )
                  : Expanded(
                child: ListView.builder(
                  itemCount: studentManager.matchedStudents.length,
                  itemBuilder: (context, index) {
                    final student = studentManager.matchedStudents[index];
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(student.name),
                        subtitle: Text(student.regNo),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade300,
        onPressed: () {
          // Restart the scan when the button is pressed
          startScan();
        },
        child: const Icon(Icons.person_search),
      ),
    );
  }
}

class StudentManager {
  late List<Student> students;

  StudentManager() {
    students = StudentBoxes.getData().values.toList();
  }

  List<Student> matchedStudents = [];

  void matchScannedDevices(List<ScanResult> scanResults) {
    for (var scanResult in scanResults) {
      for (var student in students) {
        // Convert both MAC addresses to lowercase before comparison
        String storedMacAddressLower = student.macAddress.toLowerCase();
        String detectedMacAddressLower = scanResult.device.id.id.toLowerCase();

        if (storedMacAddressLower == detectedMacAddressLower) {
          matchedStudents.add(student);
        }
      }
    }
  }

  void clearMatchedStudents() {
    matchedStudents.clear();
  }
}
