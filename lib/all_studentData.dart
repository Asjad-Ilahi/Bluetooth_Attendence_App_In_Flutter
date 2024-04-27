import 'package:final_bluetooth/box_student.dart';
import 'package:final_bluetooth/student_dataset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AllStudents extends StatefulWidget {
  const AllStudents({super.key});

  @override
  State<AllStudents> createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  final nameController = TextEditingController();
  final regController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        shadowColor: Colors.grey.shade800,
        backgroundColor: Colors.blue.shade400,
        title: const Text('Class'),
        centerTitle: true,
        leading: InkWell(
          onTap: (){
            Navigator.popAndPushNamed(context, '/home');
          },
          child: const Icon(Icons.home,size: 35,),
        ),
        actions: [
          IconButton(onPressed: _showSearchDialog, icon: const Icon(Icons.search_rounded))
        ],

      ),
      body: ValueListenableBuilder<Box<Student>>(
        valueListenable: StudentBoxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<Student>();
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 12,right: 12,top: 12),
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          removeStudent(context, data[index]);
                        },
                        icon: Icons.delete,
                        backgroundColor: Colors.red.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          editPopUP(
                            context,
                            data[index],
                            data[index].name.toString(),
                            data[index].regNo.toString(),
                            data[index].macAddress.toString(),
                          );
                        },
                        icon: Icons.edit_note_rounded,
                        backgroundColor: Colors.blue.shade300,
                        borderRadius: BorderRadius.circular(12),
                      )
                    ],
                  ),
                  child: Card(
                    child: ListTile(
                      tileColor: Colors.blue.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      leading: const CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.emoji_emotions_outlined),

                      ),
                      title: Text(data[index].name.toString()),
                      subtitle: Text(data[index].regNo.toString()),
                      trailing: InkWell(
                        onTap: () {},
                        child: const Icon(Icons.arrow_left_outlined),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popMessage();
        },
        elevation: 2,
        backgroundColor: Colors.blue.shade300,
        child: const Icon(Icons.add),
      ),
    );
  }

  void removeStudent(BuildContext context, Student student) async {
    await student.delete();
  }

  Future<void> editPopUP(BuildContext context, Student student, String name, String regNo, String macAddress) async {
    nameController.text = name;
    regController.text = regNo;
    addressController.text = macAddress;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Student'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'name..',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: regController,
                  decoration: const InputDecoration(
                    hintText: 'Reg No..',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    hintText: 'Mac address..',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                nameController.clear();
                regController.clear();
                addressController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade300,
                shadowColor: Colors.grey.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
              child: const Text('Cancel',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),

            ),
            const SizedBox(width: 70,),
            ElevatedButton(
              onPressed: () {
                if(_validateFields()!){
                student.name = nameController.text.toString();
                student.macAddress = addressController.text.toString();
                student.regNo = regController.text.toString();
                student.save();
                nameController.clear();
                addressController.clear();
                regController.clear();
                Navigator.pop(context);
                }


              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade300,
                shadowColor: Colors.grey.shade800,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                  )
              ),
              child: const Text('Edit',
                style: TextStyle(
                color: Colors.black,
              ),),
            ),


          ],
        );
      },
    );
  }

  bool? _validateFields() {
    String name = nameController.text.toString();
    // Check name validation
    if (nameController.text.isEmpty) {
      _showValidationError('Please enter a name');
      return false;
    } if (name.length < 2 ||
        name.length > 19) {
      _showValidationError('Name should be between 2 and 19 words');
      return false;
    } if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(nameController.text)) {
      _showValidationError('Name should contain only letters');
      return false;
    }

    // Check registration number validation
    RegExp regExpRegNo = RegExp(
      r'^[A-Za-z]{2}\d{2}-[A-Za-z]{3}-\d{3}$',
    );
    if (!regExpRegNo.hasMatch(regController.text)) {
      _showValidationError('Invalid Reg No format');
      return false;
    }

    // Check MAC address validation
    RegExp regExpMacAddress = RegExp(
      r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$',
    );
    if (!regExpMacAddress.hasMatch(addressController.text)) {
      _showValidationError('Invalid Mac Address format');
      return false;
    }

    return true;
  }

  Future<void> popMessage() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Student'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'name..',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: regController,
                  decoration: const InputDecoration(
                    hintText: 'Reg No..',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    hintText: 'Mac address..',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                nameController.clear();
                regController.clear();
                addressController.clear();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade300,
                shadowColor: Colors.grey.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 50),
            ElevatedButton(
              onPressed: () {
                  if(_validateFields()!) {
                    Navigator.pop(context);
                    final data = Student(
                      name: nameController.text,
                      regNo: regController.text,
                      macAddress: addressController.text,
                    );
                    final box = StudentBoxes.getData();
                    box.add(data);
                    data.save();
                    nameController.clear();
                    regController.clear();
                    addressController.clear();
                  }
                },
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade300,
                shadowColor: Colors.grey.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showValidationError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Validation Error'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade300,
                  shadowColor: Colors.grey.shade800,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                  )
              ),
              child: const Text('OK',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSearchDialog() {
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Enter name to search',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    shadowColor: Colors.grey.shade800,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    )
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _searchByName(searchController.text);
                },
                child: const Text('Search',
                  style: TextStyle(
                    color: Colors.black,
                  ),),
              ),
            ],
          ),
        );
      },
    );
  }

  void _searchByName(String name) {
    final box = StudentBoxes.getData();
    var data = box.values
        .where((student) => student.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
    if (data.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Search Results'),
            content: Container(
              height: 300,
              width: 300,// Set a fixed height for the container
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          shadowColor: Colors.grey.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 30,
                                child: Icon(Icons.emoji_emotions_outlined),
                              ),
                              const SizedBox(width: 10,),
                              Column(
                                children: [
                                  Text(data[index].name),
                                  Text(data[index].regNo),
                                ],
                              ),
                              const SizedBox(width: 30,),
                              InkWell(
                                onTap: (){editPopUP(context, data[index],
                                    data[index].name.toString(), data[index].regNo.toString(),
                                    data[index].macAddress.toString());},
                                child: const Icon(Icons.edit_note_outlined),
                              ),
                              const SizedBox(width: 10,),
                              InkWell(
                                onTap: (){removeStudent(context, data[index]);},
                                child: const Icon(Icons.delete),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    shadowColor: Colors.grey.shade800,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    )
                ),
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text('Done',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ]);
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('No Results'),
            content: const Text('No matching records found.'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    shadowColor: Colors.grey.shade800,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    )
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }




}
