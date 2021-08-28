import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  LatLng center=LatLng( 30.0719648,31.2608007);

  Set<Marker>markers={};
  void addMarker(LatLng latlng){
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


  void onMapCreated(GoogleMapController controller)
  {
    _googleMapController=controller;

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



