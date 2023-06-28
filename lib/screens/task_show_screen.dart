import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

import '../providers/task_provider.dart';
import '../models/task_model.dart';

class TaskShowScreen extends StatefulWidget {
  const TaskShowScreen({Key? key}) : super(key: key);

  @override
  _TaskShowScreenState createState() => _TaskShowScreenState();
}

class _TaskShowScreenState extends State<TaskShowScreen> {
  TaskModel? task;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController effortHoursController = TextEditingController();
  LatLng _position = LatLng(0, 0);
  String? imageName = null;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  bool _validateName = false;
  bool _validateEffortHours = false;

  bool _isAccordionExpanded = false;
  File? image;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      task = ModalRoute.of(context)?.settings.arguments as TaskModel;
      nameController.text = task?.name ?? '';
      effortHoursController.text = task?.effortHours.toString() ?? '';
      if (task!.latitude == 0 && task!.longitude == 0) {
        _getCurrentLocation();
      } else {
        _addMarker(LatLng(task!.latitude, task!.longitude));
      }
      imageName = task!.imageName;
    });

    // Set initial value for SpinBox
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final double effortHours =
          double.tryParse(effortHoursController.text) ?? 0;
      setState(() {
        effortHoursController.text = effortHours.toString();
      });
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _addMarker(LatLng(position.latitude, position.longitude));
    } catch (error) {
      print(error);
    }
  }

  void _addMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
        ),
      );
      _position = position;
    });
  }

  void _save() {
    final String name = nameController.text;
    final String effort = effortHoursController.text;
    final int effortHours = double.tryParse(effort)?.toInt() ?? 0;

    setState(() {
      _validateName = name.isEmpty;
      _validateEffortHours = effort.isEmpty;
    });

    if (!_validateName && !_validateEffortHours) {
      Provider.of<TasksProvider>(context, listen: false).save(
        task!,
        name,
        effortHours,
        _position.latitude,
        _position.longitude,
          imageName!
      );
      Navigator.of(context).pop();
    }
  }

  String generateUUID() {
    var uuid = Uuid();
    return uuid.v4();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 200,
    );
    if (pickImage != null) {
      setState(() {
        image = File(pickImage.path);
      });
      final firebaseStorage = FirebaseStorage.instance;
      imageName = "tasks/${generateUUID()}.jpg";
      final reference = firebaseStorage.ref(imageName);
      final upload = reference.putFile(image!);
      upload.whenComplete(() => print("Upload realizado com sucesso."));
    }
  }

  Future<String> getImageURL(String imageName) async {
    final firebaseStorage = FirebaseStorage.instance;
    final reference = firebaseStorage.ref(imageName);
    final img = await reference.getDownloadURL();
    return img;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Tarefa'),
      ),
      body: SingleChildScrollView(
        child: Consumer<TasksProvider>(
          builder: (context, tasksProvider, _) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nome:',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextField(
                    controller: nameController,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      errorText: _validateName ? 'Name is required' : null,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Esforço (Hs):',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SpinBox(
                    value: double.tryParse(effortHoursController.text) ?? 0,
                    min: 0,
                    max: 100,
                    incrementIcon: Icon(Icons.add),
                    decrementIcon: Icon(Icons.remove),
                    textStyle: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      errorText: _validateEffortHours
                          ? 'Esforço (Hs) is required'
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        effortHoursController.text = value.toString();
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Data:',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy')
                        .format(task?.date ?? DateTime.now()),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 200.0, // Adjust the height as needed
                    child: GoogleMap(
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      markers: _markers,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(task?.latitude ?? _position.latitude,
                            task?.longitude ?? _position.longitude),
                        zoom: 2.0,
                      ),
                      onTap: (position) {
                        _addMarker(position);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Imagem da tarefa'),
                    trailing: IconButton(
                      icon: Icon(_isAccordionExpanded
                          ? Icons.expand_less
                          : Icons.expand_more),
                      onPressed: () {
                        setState(() {
                          _isAccordionExpanded = !_isAccordionExpanded;
                        });
                      },
                    ),
                  ),
                  AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: _isAccordionExpanded ? 400.0 : 0.0,
                      child: Center(
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: pickImage,
                              icon: const Icon(Icons.camera),
                            ),
                            if (image != null)
                              Image.file(
                                image!,
                                height: 300,
                              )
                            else if (task!.imageName != null)
                              FutureBuilder<String>(
                                future: getImageURL(task!.imageName),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (snapshot.hasData) {
                                    return Image.network(snapshot.data!, height: 300);
                                  } else {
                                    return const Text("Capture an image!");
                                  }
                                },
                              )
                            else
                              const Text("Capture a imagem!"),
                          ],
                        ),
                      )),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: _save,
                        child: Text('Salvar'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
