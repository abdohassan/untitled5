import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late GoogleMapController _googleMapController;

  LatLng center=LatLng(30.0719648,31.2608007);

  Set<Marker>markers={};
  void addMarker(LatLng latlng)async{
    List<Placemark> placemarks = await placemarkFromCoordinates(latlng.latitude, latlng.longitude);
    String x=placemarks[0].street!+placemarks[0].country!+placemarks[0].locality!;
    print(x);

    setState(() {
      markers.add(Marker(
          markerId:MarkerId(latlng.toString()),
          position: latlng,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: latlng.latitude.toString(),snippet:  latlng.longitude.toString())

      ));
    });
  }

  void onCameraMove(CameraPosition position)
  {
    center=position.target;
  }


  void onMapCreated(GoogleMapController controller)async
  {
    _googleMapController=controller;
    Position x=await _determinePosition() as Position;
    addMarker(LatLng(x.latitude,x.longitude));
    //////

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            GoogleMap(
                trafficEnabled: true,
                onTap: (LatLng latLng) {
                  addMarker(latLng);
                },
                mapType: MapType.normal,
                 markers: markers,
                 onCameraMove: onCameraMove,
                onMapCreated:onMapCreated ,
                initialCameraPosition: CameraPosition(
                    target: center,
                    zoom: 20

                )),

          ],
        ),
      ),


    );
  }
}
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

