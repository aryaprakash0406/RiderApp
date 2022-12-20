import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:riderapp/location_model.dart';
import 'package:riderapp/map_box_service.dart';
import 'package:riderapp/shared_pref.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

// Only import if required functionality is not exposed by default

class AppConstants {
  static const String mapBoxAccessToken =
      'sk.eyJ1IjoiYXJ5YXByYWthc2gyMiIsImEiOiJjbGJrZGRqdXgxaTdoM3BwNGprczJ1dmgzIn0.3BZbit4Xk5EoRNuM0XYV7w';

  static const String mapBoxStyleId = 'clbjmym56007y14qmnjm1kpqp';
}

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late String currentAddress;
  late CameraPosition _initialCameraPosition;
  @override
  void initState() {
    start();
    LatLng currentLocation = getCurrentLatLngFromSharedPrefs();
    _initialCameraPosition = CameraPosition(target: currentLocation, zoom: 14);
    currentAddress = getCurrentAddressFromSharedPrefs();
    showDialogBox();
    super.initState();
  }

  String result = "dvjs";
  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = "00", digitMinutes = "00", digitHours = "00";
  Timer? timer;
  bool started = false;
  List laps = [];

  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  void reset() {
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;

      digitSeconds = "00";
      digitMinutes = "00";
      digitHours = "00";
      started = false;
    });
  }

  void addLaps() {
    String lap = "$digitHours:$digitMinutes:$digitSeconds";
    setState(() {
      laps.add(lap);
    });
  }

  void start() {
    started = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int localSeconds = seconds + 1;
      int localMinute = minutes;
      int localHours = hours;

      if (localSeconds > 59) {
        if (localMinute > 59) {
          localHours++;
          localMinute = 0;
        } else {
          localMinute++;
          localSeconds = 0;
        }
      }

      setState(() {
        seconds = localSeconds;
        minutes = localMinute;
        hours = localHours;
        digitSeconds = (seconds >= 10) ? "$seconds" : "$seconds";
        digitHours = (hours >= 10) ? "$hours" : "$hours";
        digitMinutes = (minutes >= 10) ? "$minutes" : "$minutes";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      MapboxMap(
        accessToken: AppConstants.mapBoxAccessToken,
        initialCameraPosition: _initialCameraPosition,
        myLocationEnabled: true,
      ),
      Positioned(
          bottom: 0,
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                  clipBehavior: Clip.antiAlias,
                  color: Colors.white,
                  child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Center(
                              child: Text(
                                "Ride In Progress",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 9, 9, 9),
                                    fontSize: 22),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Time",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 9, 9, 9),
                                          fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "$digitHours:$digitMinutes:$digitSeconds",
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 9, 9, 9),
                                          fontSize: 15),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      "Ride",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 9, 9, 9),
                                          fontSize: 22),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Distance",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 9, 9, 9),
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "KMS",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 9, 9, 9),
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Ride",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 9, 9, 9),
                                          fontSize: 22),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Avg Speed",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 9, 9, 9),
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Kmph",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 9, 9, 9),
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Ride",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 9, 9, 9),
                                          fontSize: 22),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: HorizontalSlidableButton(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  buttonWidth: 100.0,
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  buttonColor: Colors.black,
                                  dismissible: false,
                                  label: const Center(
                                      child: Text('Slide to Finish')),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        // Text('Left'),
                                        Text('Slide to Finish'),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        )
                                      ],
                                    ),
                                  ),
                                  onChanged: (position) {
                                    setState(() {
                                      if (position ==
                                          SlidableButtonPosition.end) {
                                        stop();
                                        // String timetaken="${laps[]}";
                                        // Navigator.push(context, MaterialPageRoute(builder: (context)=> const TakePictureScreen(camera: ,)
                                        // ));
                                      } else {
                                        result = 'Button is on the left';
                                      }
                                    });
                                  }),
                            )
                          ])))))
    ]));
  }
}

void showDialogBox() {
  

}



Future<Map> getParsedReverseGeocoding(LatLng latLng) async {
  // var response =
  //     json.decode(await getReverseGeocodingGivenLatLngUsingMapbox(latLng));
  // Map feature = response['features'][0];
  LocationModel locationModel =
      await getReverseGeocodingGivenLatLngUsingMapbox(latLng);
  Feature feature = locationModel.features![0];
  Map revGeocode = {
    'name': feature.text,
    'address': feature.placeName!.split('${feature.text}, ')[1],
    'place': feature.placeName,
    'location': latLng
  };
  return revGeocode;
}
