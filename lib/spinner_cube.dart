import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class SpinnerOnStartup extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const SpinnerOnStartup({required this.child, required this.duration});

  @override
  _SpinnerOnStartupState createState() => _SpinnerOnStartupState();
}

class _SpinnerOnStartupState extends State<SpinnerOnStartup> {
  bool _showSpinner = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.duration, () {
      setState(() {
        _showSpinner = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => widget.child,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showSpinner
        ? Scaffold(
            backgroundColor: Colors.white, // Change the background color as needed
            body: Container(
              color: Colors.blue.shade50,
              child: Center(
                child: SpinKitFadingCube(
                  color: Colors.blue, // Change the color as needed
                  size: 50.0, // Change the size as needed
                ),
              ),
            ),
          )
        : widget.child;
  }
}
