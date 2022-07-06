// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grievance_app/services/firestore_methods.dart';
import 'package:grievance_app/utils/colors.dart';
import 'package:grievance_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class GrievanceForm extends StatefulWidget {
  final LatLng userLocation;
  GrievanceForm(
      {Key? key, this.userLocation = const LatLng(12.871513, 77.581879)})
      : super(key: key);
  @override
  State<GrievanceForm> createState() => _GrievanceFormState();
}

class _GrievanceFormState extends State<GrievanceForm> {
  CollectionReference grievance =
      FirebaseFirestore.instance.collection('grievances');
  File? image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _categoryController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  String name = "";
  String profileImage = "";
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _categoryController.dispose();
    _locationController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void getPinnedLocation() async {
    if (widget.userLocation != null) {
      dynamic address = await Geocoder.local.findAddressesFromCoordinates(
          Coordinates(
              widget.userLocation.latitude, widget.userLocation.longitude));
      _locationController.text = address.first.addressLine;
    }
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    getPinnedLocation();
  }

  void getUserDetails() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();

    setState(() {
      name = (snapshot.data() as Map<String, dynamic>)['name'];
      profileImage = (snapshot.data() as Map<String, dynamic>)['profileImage'];
    });
  }

  var _locationCord;
  var coordinates;
  var addresses;
  var addressLine;

  String chosenValue = "Sanitation";
  List listItems = <String>[
    'Sanitation',
    'Security',
    'Infrastructure',
    'Sewage',
    'Road Query'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: mobileThemeColor, title: Text('Grievance Form')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              isLoading
                  ? LinearProgressIndicator()
                  : Padding(
                      padding: EdgeInsets.only(top: 0),
                    ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? "Location cannot be empty" : null,
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location of complaint',
                  border: OutlineInputBorder(),
                  suffixIcon: Container(
                      child: IconButton(
                          icon: Icon(Icons.my_location),
                          onPressed: _getCurrentLocation)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                    labelText: 'Grievance Description',
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Select Category",
                  border: OutlineInputBorder(),
                ),
                isExpanded: true,
                hint: Text("Select Category"),
                value: chosenValue,
                onChanged: (newValue) {
                  setState(() {
                    chosenValue = newValue as String;
                  });
                },
                items: listItems
                    .map((item) => DropdownMenuItem(
                          child: Text(item),
                          value: item,
                        ))
                    .toList(),
              ),
              addImage(),
              image != null
                  ? Image.file(
                      image!,
                      height: 160,
                      width: 160,
                      fit: BoxFit.fill,
                    )
                  : SizedBox(
                      height: 5,
                    ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => submitHandler(
                      context, _auth.currentUser!.uid, name, profileImage),
                  child: Text("Submit"),
                  style: ElevatedButton.styleFrom(
                      primary: mobileThemeColor,
                      textStyle: TextStyle(fontSize: 15)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getCurrentLocation() async {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium,
            forceAndroidLocationManager: false)
        .then((Position position) async {
      coordinates = Coordinates(position.latitude, position.longitude);
      addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);

      //addresses = await placemarkFromCoordinates(position.latitude,position.longitude);
      print(position);
      print("Coordinates $coordinates");
      setState(() {
        _locationCord = position;
        addressLine = addresses.first.addressLine.substring(0,
            addresses.first.addressLine.indexOf(addresses.first.subLocality));
        _locationController.text = addressLine;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future submitHandler(BuildContext context, String uid, String name,
      String profileImage) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var imageUrl = await uploadImage(context);
      String res = "error";
      try {
        String res = await FireStoreMethods().uploadGrievance(
            uid,
            name,
            chosenValue,
            _descriptionController.text,
            imageUrl,
            _locationController.text,
            GeoPoint(12.871513, 77.581879),
            profileImage);
        if (res == "success") {
          setState(() {
            isLoading = false;
          });
          showSnackBar(context, "Grievance successfully uploaded");
        } else {
          setState(() {
            isLoading = false;
          });
          showSnackBar(context, res);
        }
      } catch (err) {
        res = err.toString();
      }
      setState(() {
        image = null;
        _locationController.text = "";
        _descriptionController.text = "";
        _categoryController.text = "Select";
      });
    }
  }

  Widget addImage() {
    return Container(
      child: TextButton.icon(
          icon: Icon(Icons.upload),
          label: Text("Upload Image"),
          onPressed: () => showModalBottomSheet(
              context: this.context, builder: (builder) => imageModal())),
    );
  }

  Future uploadImage(BuildContext context) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String fileName = basename(image!.path);
    final destination = 'grievanceImages/$fileName';
    // storageRef.ref().child(collectionName).child(uploadFileName)
    /*UploadTask task = FirebaseStorage.instance.ref(destination).putFile(image!);
    final snapshot = await task.whenComplete(() {});
    final ImageUrl = await snapshot.ref.getDownloadURL();*/

    Reference ref =
        storage.ref().child(destination).child(_auth.currentUser!.uid);

    String id = const Uuid().v1();
    ref = ref.child(id);

    UploadTask uploadTask = ref.putFile(image!);
    TaskSnapshot snapshot = await uploadTask;
    String ImageUrl = await snapshot.ref.getDownloadURL();

    return ImageUrl;
  }

  Widget imageModal() {
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(children: <Widget>[
        Text(
          "Choose an image",
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton.icon(
              onPressed: () {
                takePicture(ImageSource.camera);
              },
              label: Text("Camera"),
              icon: Icon(Icons.camera),
            ),
            TextButton.icon(
              onPressed: () {
                takePicture(ImageSource.gallery);
              },
              label: Text("Gallery"),
              icon: Icon(Icons.image),
            ),
          ],
        )
      ]),
    );
  }

  Future takePicture(ImageSource source) async {
    final image = await _picker.pickImage(source: source);
    if (image == null) {
      return;
    }
    final imageTemporary = File(image.path);
    setState(() {
      this.image = imageTemporary;
    });
  }
}
