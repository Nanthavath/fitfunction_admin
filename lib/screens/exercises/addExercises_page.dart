import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitfunction_admin/widgets/circularProgress.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddExercises extends StatefulWidget {
  @override
  _AddExercisesState createState() => _AddExercisesState();
}

File fileExercises;
File pickedImage;
final imagePicker = ImagePicker();
TextEditingController name = TextEditingController();
TextEditingController description = TextEditingController();
List type = [];
bool loading = false;



class _AddExercisesState extends State<AddExercises> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddExcercises'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              if (name.text == '' || description.text == '') {
                showDialogs(context);
              } else {
                loading = true;
                setState(() {
                  upLoadData().then((value) {
                    name.text = '';
                    description.text = '';

                    loading = false;
                    Navigator.pop(context);
                  });
                });
              }
            },
          ),
        ],
      ),
      body: loading == false
          ? Container(
              child: ListView(
                children: [
                  InkWell(
                    child: fileExercises == null
                        ? Container(
                            color: Colors.grey,
                            height: 150,
                            child: Icon(
                              Icons.add,
                              color: Colors.orange,
                            ),
                          )
                        : Image(image: FileImage(fileExercises)),
                    onTap: () {
                      showChoiceDialogCover();
                    },
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: name,
                          decoration:
                              InputDecoration(hintText: 'Name exercises'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: description,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Description'),
                          onChanged: (value) => description,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : CircularProgress(
              title: 'Uploading...',
            ),
    );
  }

  Future<void> chooseImageProfile(ImageSource imageSource) async {
    try {
      pickedImage =
          File((await imagePicker.getImage(source: imageSource)).path);
      setState(() {
        fileExercises = pickedImage;
      });
    } catch (ex) {
      print(ex.toString());
    }
  }

  Future<void> showChoiceDialogCover() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('ເລືອກທີ່ມາຂອງຮູບພາບ'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('ເລືອຮູບພາບຈາກເຄື່ອງ'),
                    ),
                    onTap: () {
                      chooseImageProfile(ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  ),
//                  SizedBox(
//                    height: 15,
//                  ),
                  Divider(),
                  GestureDetector(
                    child: ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text('ຖ່າຍຮູບ'),
                    ),
                    onTap: () {
                      chooseImageProfile(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showDialogs(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Warning'),
            content: Text('Please fill data'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              )
            ],
          );
        });
  }

  Future<void> upLoadData() async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Exercises/${name.text}');
    final StorageUploadTask uploadTask =
        storageReference.putFile(fileExercises);
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(url);
    uploadToFireStore(url);
  }

  Future<void> uploadToFireStore(String url) async {
    await FirebaseFirestore.instance.collection('Exercises').add({
      'name': name.text,
      'description': description.text,
      'urlImage': url,
      'type': type.toList(),
    }).then(
      (value) => print('Upload to FireStore'),
    );
  }

 @override
  void initState() {
   setState(() {
     fileExercises=null;
   });
    super.initState();
  }
}
