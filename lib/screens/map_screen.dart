import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grievance_app/screens/add_grievance.dart';
import 'package:grievance_app/screens/info_window_card.dart';
import 'package:custom_info_window/custom_info_window.dart';

LatLng location1 = LatLng(12.871513, 77.581879);
LatLng location2 = LatLng(12.872800, 77.576832);
LatLng location3 = LatLng(12.872807, 77.576832);
LatLng location4 = LatLng(13.013136, 77.48918);

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  CameraPosition initialCameraPosition =
      CameraPosition(target: location4, zoom: 16, tilt: 11);
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _googleMapController;
  Set<Marker> _markers = {};
  Set<Marker> _userMarker = {};

  Map markerColors = {
    "Sanitation": BitmapDescriptor.hueAzure,
    "Infrastructure": BitmapDescriptor.hueGreen,
    "Security": BitmapDescriptor.hueRed,
    "Sewage": BitmapDescriptor.hueYellow,
    "Road query": BitmapDescriptor.hueMagenta
  };

  @override
  void initState() {
    super.initState();
    getMarkerData();
  }

  Marker initMarker(markerIdVal, snap) {
    final MarkerId markerId = MarkerId(markerIdVal);
    final color = markerColors[snap['category']];
    final LatLng location =
        LatLng(snap['location'].latitude, snap['location'].longitude);
    final Marker marker = Marker(
        markerId: markerId,
        position: location,
        icon: BitmapDescriptor.defaultMarkerWithHue(color),
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
              (infoWindowCard(
                  snap['name'],
                  snap['address'],
                  snap['category'],
                  snap['description'],
                  snap['image'],
                  snap['votes'].length,
                  snap['profileImage'])),
              location);
        });

    return marker;
  }

  void getMarkerData() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("grievances").get();
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs.toList()) {
        Marker marker = initMarker(doc['grievanceId'], doc);
        setState(() {
          _markers.add(marker);
        });
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    //_googleMapController = controller;
    _customInfoWindowController.googleMapController = controller;
    print("bla");
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId("id2"),
            position: location3,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                  (infoWindowCard(
                      "John Doe",
                      "JP Nagar 4th block",
                      "Sanitation",
                      "Garbage thrown on roads",
                      "https://www.deccanherald.com/sites/dh/files/styles/article_detail/public/article_images/2019/03/29/file74oh3bg5mvlw184xepj-1553801680.jpg?itok=dhDk3u4S",
                      10,
                      "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg")),
                  location3);
            }),
      );
    });
  }

  _handleTap(LatLng tappedLocation) {
    setState(() {
      _userMarker = {};
      _userMarker.add(
        Marker(
          markerId: MarkerId(tappedLocation.toString()),
          position: tappedLocation,
          infoWindow: InfoWindow(
              title: "Tap to add Grievance here",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            GrievanceForm(userLocation: tappedLocation))));
              }),
          draggable: true,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("View Grievances"),
          backgroundColor: Color.fromARGB(255, 21, 76, 121),
          actions: [
            IconButton(
                onPressed: () => _onButtonClicked(),
                icon: const Icon(
                  Icons.info_rounded,
                  color: Colors.white,
                ))
          ],
        ),
        body: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: _onMapCreated,
              markers: _markers.union(_userMarker),
              onTap: (position) {
                _customInfoWindowController.hideInfoWindow!();
              },
              onLongPress: _handleTap,
              onCameraMove: (position) {
                _customInfoWindowController.onCameraMove!();
              },
            ),
            CustomInfoWindow(
              controller: _customInfoWindowController,
              height: 300,
              width: 300,
              offset: 50,
            ),
          ],
        ));
  }

  void _onButtonClicked() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(top: 15),
            color: const Color(0xFF737373),
            height: 280,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(
                      Icons.room,
                      color: Colors.blue,
                    ),
                    title: Text('Sanitation'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.room,
                      color: Colors.purple,
                    ),
                    title: Text('Road query'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.room,
                      color: Colors.red,
                    ),
                    title: Text('Security'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.room,
                      color: Colors.yellow,
                    ),
                    title: Text('Sewage'),
                  )
                ],
              ),
            ),
          );
        });
  }
}
