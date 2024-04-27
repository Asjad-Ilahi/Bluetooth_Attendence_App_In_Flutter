import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'all_control.dart';


class BluetoothDevices extends StatefulWidget {
  const BluetoothDevices({Key? key}) : super(key: key);

  @override
  State<BluetoothDevices> createState() => _BluetoothDevicesState();
}

class _BluetoothDevicesState extends State<BluetoothDevices> {
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        elevation: 3,
        shadowColor: Colors.grey.shade800,
        leading: IconButton(
          onPressed: () {
            Navigator.popAndPushNamed(context, '/home');
          },
          icon: const Icon(Icons.home, size: 35),
        ),
        centerTitle: true,
        title: const Text(
          'All Devices',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
        ),
      ),
      body: GetBuilder<Control>(
        init: Control(),
        builder: (control) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: StreamBuilder<List<ScanResult>>(
                  stream: control.scanResults,
                  builder: (context, snapshot) {
                    if (isScanning) {
                      return Center(
                        child: CircularProgressIndicator(), // Show spinner while scanning
                      );
                    } else if (snapshot.hasData) {
                      final devices = snapshot.data!;
                      if (devices.isEmpty) {
                        return Center(
                          child: Text('Start Scanning....'),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: devices.length,
                          itemBuilder: (context, index) {
                            final data = devices[index];
                            return Padding(
                              padding: EdgeInsets.only(top: 12, left: 12, right: 12),
                              child: Card(
                                elevation: 2,
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.bluetooth_audio),
                                  ),
                                  title: Text(data.device.name.toString()),
                                  subtitle: Text(data.device.id.toString()),
                                  trailing: Text(data.rssi.toString()),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    } else {
                      return Center(
                        child: Text('No device Found'),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      setState(() {
                        isScanning = true;
                      });
                      await control.scan();
                      setState(() {
                        isScanning = false;
                      });
                    },
                    backgroundColor: Colors.blue.shade300,
                    child: Icon(Icons.find_in_page_rounded),
                  ),
                  SizedBox(width: 15)
                ],
              ),
              const SizedBox(height: 20,)
            ],
          );
        },
      ),
    );
  }
}