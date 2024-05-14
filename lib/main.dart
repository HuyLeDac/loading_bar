import 'package:flutter/material.dart';
import 'dart:ffi' as ffi;
import 'dart:io' show Platform, Directory;
import 'package:path/path.dart' as path;

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('HomeScreen'),
      ),

      body: Column(
        children: <Widget>[ 
          // Load button, add other buttons later 
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const LoadingDialog(); // Show loading dialog when button is pressed
                },
              );
            },
            child: const Text('Load CNC objects'),
          ),

          // Two columns, one for tree and one for table which should illustrate all objects
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Tree'), //Tree dummy, implement Tree with flutter_fancy_tree_view
              , // Table dummy
            ],
          )
        ]
      ),
    );
  }
}

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

    // TODO: Create a typedef with the FFI type signature of the C function.
     
    // TODO: Create a typedef for the variable that you'll use when calling the C function.


    // create variables that contain paths to DLL
    String serverPath = 'C:/cnc_objects_test_dll/x64/Debug/ob_test_dll.dll'; //enter path
    var testServerPath = path.join(serverPath);
    String objTestPath = 'C:/cnc_objects_test_dll/x64/Debug/test_server.dll'; //enter path
    var objTestDllPath = path.join(objTestPath);

    //Open dynamic library that contains C functions
    final dylibTestServer = ffi.DynamicLibrary.open(testServerPath);
    final dylibObjTestDll = ffi.DynamicLibrary.open(objTestDllPath); 

  
   



    //simulate 
    for (int i = 0; i <= totalSteps; i++) {
      Future.delayed(Duration(milliseconds: i * delayMilliseconds), () {
        setState(() {
          _progressValue = i / totalSteps;
        });
      });
    }

    // Simulate loading completion
    Future.delayed(const Duration(milliseconds: (totalSteps + 1) * delayMilliseconds), () {
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
