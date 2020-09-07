import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddtrainerPage extends StatefulWidget {
  @override
  _AddtrainerPageState createState() => _AddtrainerPageState();
}

File fileExercises;
File pickedImage;
List<TextEditingController> controllList = [];
int skillIndex;
String trainergetgymID;
final imagePicker = ImagePicker();

class _AddtrainerPageState extends State<AddtrainerPage> {
  // List<WriteStepRecipe> textStepRecipe = [];
  List<DynamicWid> listDynamic = [];

  TextEditingController name = TextEditingController();
  TextEditingController about = TextEditingController();
  TextEditingController tel = TextEditingController();
  TextEditingController emil = TextEditingController();
  TextEditingController experience = TextEditingController();
  List<String> kill = [];

  bool loading = false;
  @override
  void initState() {
    super.initState();

    listDynamic = [];
    controllList = [];
    skillIndex = -1;
    setState(() {
      print(skillIndex.toString() + 'skillindex');
      print(controllList.length.toString() + 'controllList');
      print(listDynamic.length.toString() + 'listDynamic');
      controllList.add(TextEditingController());
      skillIndex = ++skillIndex;

      listDynamic.add(DynamicWid());
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
// Future<void> upLoadData() async {
//     final StorageReference storageReference =
//         FirebaseStorage.instance.ref().child('Exercises/${name.text}');
//     final StorageUploadTask uploadTask =
//         storageReference.putFile(fileExercises);
//     String url = await (await uploadTask.onComplete).ref.getDownloadURL();
//     print(url);
//     uploadToFireStore(url);
//   }

  // Future<void> uploadToFireStore(String url) async {
  //   await FirebaseFirestore.instance.collection('Exercises').add({
  //     'name': name.text,
  //     'description': description.text,
  //     'urlImage': url,
  //     'type': type.toList(),
  //   }).then(
  //     (value) => print('Upload to FireStore'),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new trainer'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              addTrainer().then(Navigator.of(context).pop());
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          InkWell(
            child: fileExercises == null
                ? Container(
                    color: Colors.grey,
                    height: (MediaQuery.of(context).size.width / 1.4),
                    child: Icon(
                      Icons.add,
                      color: Colors.orange,
                    ),
                  )
                : Container(
                    height: (MediaQuery.of(context).size.width / 1.4),
                    child: Image(
                      image: FileImage(fileExercises),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
            onTap: () {
              showDialog(
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
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: TextField(
              controller: name,
              decoration: InputDecoration(
                  prefix: Container(
                    child: SizedBox(width: 10),
                  ),
                  contentPadding:
                      EdgeInsets.only(left: 12.0, bottom: 12.0, top: 0.0),
                  // filled: true,
                  // fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  hintText: "Name"),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: TextField(
              controller: about,
              decoration: InputDecoration(
                  prefix: Container(
                    child: SizedBox(width: 10),
                  ),
                  contentPadding:
                      EdgeInsets.only(left: 12.0, bottom: 12.0, top: 0.0),
                  // filled: true,
                  // fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  hintText: "About"),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: TextField(
              controller: tel,
              decoration: InputDecoration(
                  prefix: Container(
                    child: SizedBox(width: 10),
                  ),
                  contentPadding:
                      EdgeInsets.only(left: 12.0, bottom: 12.0, top: 0.0),
                  // filled: true,
                  // fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  hintText: "Tel"),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: TextField(
              controller: emil,
              decoration: InputDecoration(
                  prefix: Container(
                    child: SizedBox(width: 10),
                  ),
                  contentPadding:
                      EdgeInsets.only(left: 12.0, bottom: 12.0, top: 0.0),
                  // filled: true,
                  // fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  hintText: "Email"),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: TextField(
              controller: experience,
              decoration: InputDecoration(
                  prefix: Container(
                    child: SizedBox(width: 10),
                  ),
                  contentPadding:
                      EdgeInsets.only(left: 12.0, bottom: 12.0, top: 0.0),
                  // filled: true,
                  // fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  hintText: "Experience"),
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text('Trainer skill')),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: listDynamic.length,
            itemBuilder: (context, index) {
              return listDynamic[index];
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                  onPressed: () => {
                        setState(() {
                          skillIndex = ++skillIndex;
                          controllList.add(TextEditingController());
                          listDynamic.add(DynamicWid());
                          print(skillIndex.toString() + 'skillindex');
                          print(
                              controllList.length.toString() + 'controllList');
                          print(listDynamic.length.toString() + 'listDynamic');
                        })
                      },
                  color: Colors.orange,
                  child: Text(
                    'Add more Skill',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                width: 20,
              ),
              RaisedButton(
                  onPressed: () => {
                        setState(() {
                          if (listDynamic.length > 1) {
                            skillIndex = skillIndex--;
                            listDynamic.removeLast();
                            controllList.removeLast();
                            print(skillIndex.toString() + 'skillindex');
                            print(controllList.length.toString() +
                                'controllList');
                            print(
                                listDynamic.length.toString() + 'listDynamic');
                          }
                        })
                      },
                  color: Colors.orange,
                  child: Text(
                    'Delete Skill',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          )
        ],
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

  addTrainer() async {
    String adname, adabout, adex, adtel, ademil;
    adname = name.text;
    adabout = about.text;
    adex = experience.text;
    adtel = tel.text;
    ademil = emil.text;
    print('adding');
    Random random = Random();
    int x = random.nextInt(9999999);
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Trainer$x');
    final StorageUploadTask uploadTask =
        storageReference.putFile(fileExercises);
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    FirebaseFirestore.instance.collection('Trainer').add({
      'name': adname,
      'about': adabout,
      'experience': adex,
      'phone': adtel,
      'email': ademil,
      'gymID': trainergetgymID,
      'profile': url,
      'skill': []
    }).then((value) => controllList.forEach((element) {
          FirebaseFirestore.instance
              .collection('Trainer')
              .doc(value.id)
              .update({
            'skill': FieldValue.arrayUnion([element.text]),
          });
        }));
  }
}

class DynamicWid extends StatefulWidget {
  @override
  _DynamicWidState createState() => _DynamicWidState();
}

class _DynamicWidState extends State<DynamicWid> {
  int i = skillIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      child: TextField(
        onChanged: (value) {
          controllList.forEach((element) {
            print(element.text);
          });
        },
        controller: controllList[i],
        decoration: InputDecoration(
            prefix: Container(
              child: SizedBox(width: 10),
            ),
            contentPadding: EdgeInsets.only(left: 12.0, bottom: 12.0, top: 0.0),
            // filled: true,
            // fillColor: Colors.white,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            hintText: " Skill ${i + 1}"),
      ),
    );
  }
}
