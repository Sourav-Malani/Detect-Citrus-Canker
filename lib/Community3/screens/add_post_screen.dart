import 'dart:typed_data';
import 'dart:io';

import 'package:canker_detect/widget/plant_recogniser.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:canker_detect/Community3/providers/user_providers.dart';
import 'package:canker_detect/Community3/resources/firestore_method.dart';
import 'package:canker_detect/Community3/resources/user.dart';
import 'package:canker_detect/utils/colors.dart';
//import 'package:canker_detect/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      _isLoading = true;
    });
    String res = "Some error occurred";
    try {
      res = await FirestoreMethod().uploadPost(
          _descriptionController.text, _file!, uid, profImage, username);
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        clearImage();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Posted"),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }


  void clearImage(){
    setState(() {
      _file = null;
    });

  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Create a post"),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Take a photo"),
              onPressed: () async {
                Navigator.of(context).pop();
                final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() {
                    _file = File(image.path).readAsBytesSync();
                  });
                }
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Choose from gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    _file = File(image.path).readAsBytesSync();
                  });
                }
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Detect"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlantRecogniser()),
                );              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )

          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
      child: IconButton(
        icon: const Icon(Icons.upload),
        onPressed: () => _selectImage(context),
      ),
    )
        : Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: clearImage,
        ),
        title: const Text("Post to"),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () =>
                  postImage(user!.uid, user.username, user.photoUrl),
              child: const Text(
                "Post",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16),
              )),
        ],
      ),
      body: Column(children: [
        _isLoading ? const LinearProgressIndicator() : const Padding(padding: EdgeInsets.only(top:0)),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(user!.photoUrl),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: "Write a caption..",
                  border: InputBorder.none,
                ),
                maxLines: 8,
              ),
            ),
            SizedBox(
                width: 45,
                height: 45,
                child: AspectRatio(
                    aspectRatio: 487 / 451,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter)),
                    ))),
            const Divider()
          ],
        ),
      ]),
    );
  }
}