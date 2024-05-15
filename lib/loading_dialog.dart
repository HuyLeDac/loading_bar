import 'package:flutter/material.dart';
import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:io' show Platform, Directory;
import 'package:path/path.dart' as path;


// TODO: Create a typedef with the FFI type signature of the C function.
typedef PortOpenNative = Int64 Function();
// TODO: Create a typedef for the variable that you'll use when calling the C function.
typedef PortOpen = int Function();



class LoadingDialog extends StatefulWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  
  double _progressValue = 0.0;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Simulate loading data
  void _loadData() {
    setState(() {
      _isLoading = true;
      _progressValue = 0.0; // Reset progress value
    });

    const int totalSteps = 100;
    const int delayMilliseconds = 50; // Adjust the delay time as needed
    
    //simulate 
    for (int i = 0; i <= totalSteps; i++) {
      Future.delayed(Duration(milliseconds: i * delayMilliseconds), () {
        setState(() {
          _progressValue = i / totalSteps;
        });
      });
    }


    // TODO: Try to call the port_open() method from the dll
    // create variables that contain paths to DLL
    String objTestPath = 'C:/cnc_objects_test_dll/x64/Debug/test_server.dll'; //enter path
    var objTestDllPath = path.join(objTestPath);
    // Open dynamic library that contains C functions
    final dylibObjTestDll = ffi.DynamicLibrary.open(objTestDllPath); 
    // Look up the function pointer
    final portOpen = dylibObjTestDll.lookupFunction<PortOpenNative, PortOpen>('port_open');

    

    // Simulate loading completion
    Future.delayed(const Duration(milliseconds: (totalSteps + 1) * delayMilliseconds + 200), () {
      setState(() {
        _isLoading = false; // Set isLoading to false when loading is completed
      });
      Navigator.of(context).pop(); // Close dialog when loading is completed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LinearProgressIndicator(
              value: _progressValue,
              minHeight: 10,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Text('Loading...')
            else
              const Text('Loading complete'), // Show completion message when loading is complete
          ],
        ),
      ),
    );
  }
}
