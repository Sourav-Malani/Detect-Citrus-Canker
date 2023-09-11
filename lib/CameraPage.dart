import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'constants.dart';
import 'package:gallery_saver/gallery_saver.dart';

class CameraPage extends StatefulWidget {
  final CameraDescription camera;

  const CameraPage({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () async {
              try {
                final pickedFile =
                    await ImagePicker().getImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  // Navigate to the preview page with the selected image
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          PreviewPage(imagePath: pickedFile.path),
                    ),
                  );
                }
              } catch (e) {
                print(e);
              }
            },
            child: Icon(Icons.photo_library, color: Constants.primaryColor),
          ),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: FloatingActionButton(
              backgroundColor: Constants.primaryColor,
              onPressed: () async {
                try {
                  await _initializeControllerFuture;

                  // Take the picture in a square aspect ratio
                  final XFile picture = await _controller.takePicture();

                  // Save the picture to the device storage
                  final directory = await getApplicationDocumentsDirectory();
                  final String filePath = '${directory.path}/picture.png';
                  final File file = File(filePath);
                  await file.writeAsBytes(await picture.readAsBytes());
                  await GallerySaver.saveImage(filePath);

                  // Navigate to the preview page with the saved picture
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PreviewPage(imagePath: filePath),
                    ),
                  );
                } catch (e) {
                  print(e);
                }
              },
              child: Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
    );
  }
}

class PreviewPage extends StatelessWidget {
  final String imagePath;

  const PreviewPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
      ),
      body: Center(
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
