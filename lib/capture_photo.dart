import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:path/path.dart';
import 'package:riderapp/map_view.dart';
import 'package:riderapp/prepare_ride.dart';
import 'firebase_options.dart';
import 'main.dart';

// await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  bool isLoading = false;
  bool isEmptyResponse = true;
  bool hasResponded = false;
  bool isResponseForDestination = false;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  TextEditingController destinationController = TextEditingController();
  List responses = [];
  set responsesState(List responses) {
    setState(() {
      this.responses = responses;
      hasResponded = true;
      isEmptyResponse = responses.isEmpty;
    });
    Future.delayed(
      const Duration(milliseconds: 500),
      () => setState(() {
        isLoading = false;
      }),
    );
  }

  set isLoadingState(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  set isResponseForDestinationState(bool isResponseForDestination) {
    setState(() {
      this.isResponseForDestination = isResponseForDestination;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeLocationAndSave();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void initializeLocationAndSave() async {
    Location _location = Location();
    bool? _serviceEnabled;
    PermissionStatus? _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
    }

    // Get the current user location
    LocationData locationData = await _location.getLocation();
    print("heloooooooooooooooooo");
    print(locationData.latitude);
    LatLng currentLocation =
        LatLng(locationData.latitude!, locationData.longitude!);

    // Get the current user address
    String currentAddress =
        (await getParsedReverseGeocoding(currentLocation))['place'];

    sharedPreferences.setDouble('latitude', locationData.latitude!);
    sharedPreferences.setDouble('longitude', locationData.longitude!);
    sharedPreferences.setString('current-address', currentAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capture the Picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            if (!mounted) return;
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child: Image.file(File(imagePath)),
            // fit: MediaQuery.of(context).size.height!/2,
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PrepareRide()));
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return  Expanded(
                //       child: AlertDialog(
                //         title: const Text('Welcome'),
                //         actions: [
                //           const TextField(
                //             decoration: InputDecoration(
                //                 border: InputBorder.none,
                //                 labelText: 'Enter Destination',
                //                 hintText: 'Enter Your Destination'),
                //                 onChanged: _onChangeHandler,
                //           ),
                //           TextButton(
                //             onPressed: (){},
                //             child: const Text('Go'),
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                // );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(1, 0, 0, 0),
                  elevation: 12.0,
                  textStyle: const TextStyle(color: Colors.white)),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Start Ride',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
