import 'dart:io';

import 'package:fitfunction_admin/models/gymsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddGymPage extends StatefulWidget {
  @override
  _AddGymPageState createState() => _AddGymPageState();
}

GymModel gymModel = GymModel();

List countries = ['Fitness fully equipped', 'Boxing class', 'Shower room'];
String fromDay;
String toDay;
List<String> days = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
DateTime _dateTime;

File fileProfile;
File pickedImage;
final imagePicker = ImagePicker();
String selectDay;
String selectTimes;
String startTime;
String endTime;

TextEditingController optionText = TextEditingController();

class _AddGymPageState extends State<AddGymPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButton(),
                    InkWell(
                      child: Icon(Icons.done),
                      onTap: () {
                        uploadToDatabase();
                      },
                    ),
                  ],
                ),
              ),
              Container(
                child: imageProfile(),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    addPicture(),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Gym',
                      ),
                      onChanged: (value) => gymModel.name = value,
                    ),
                    optionGym(),
                    dayService(),
                    timeService(),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Tel'),
                      onChanged: (value) => gymModel.tel = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Promotion'),
                      onChanged: (value) => gymModel.promotion = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Location'),
                      onChanged: (value) => gymModel.location = value,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container timeService() {
    return Container(
      child: Row(
        children: [
          Text('Open'),
          Expanded(
            child: TextFormField(
              onChanged: (value) => startTime = value.trim(),
            ),
          ),
          Text('Closed'),
          Expanded(
              child: TextFormField(
            onChanged: (value) => endTime = value.trim(),
          )),
        ],
      ),
    );
  }

  Align dayService() {
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          fromDays(),
          Text('To'),
          toDays(),
        ],
      ),
    );
  }

  DropdownButton<String> toDays() {
    return DropdownButton(
      value: toDay,
      onChanged: (String value) {
        setState(() {
          toDay = value;
        });
      },
      items: days.map((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  DropdownButton<String> fromDays() {
    return DropdownButton(
      value: fromDay,
      onChanged: (String value) {
        setState(() {
          fromDay = value;
        });
      },
      items: days.map((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget optionGym() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          TextFormField(
            controller: optionText,
            decoration: InputDecoration(
              hintText: 'Option',
              prefixIcon: Icon(Icons.arrow_drop_down),
            ),
            onTap: () {
              _showMultiChoiceDialog(context);
            },
          )
        ],
      ),
    );
  }

  _showMultiChoiceDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) {
          final _multipleNotifier = Provider.of<MultipleNotifier>(context);
          return AlertDialog(
            title: Text('Select Option'),
            content: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: countries
                      .map((e) => CheckboxListTile(
                            title: Text(e),
                            onChanged: (value) {
                              value
                                  ? _multipleNotifier.addItem(e)
                                  : _multipleNotifier.removeItem(e);
                            },
                            value: _multipleNotifier.isHaveItem(e),
                          ))
                      .toList(),
                ),
              ),
            ),
            actions: [
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  print(_multipleNotifier._selectedItems);
                  gymModel.option = _multipleNotifier._selectedItems.toList();
                  optionText.text = _multipleNotifier._selectedItems
                      .toString()
                      .replaceAll('[', '')
                      .replaceAll(']', '');
                },
              ),
            ],
          );
        },
      );

  Row selectTime() {
    return Row(
      children: [
        Text('Open:'),
        Expanded(
          child: TextField(
            decoration: InputDecoration(),
          ),
        ),
        Text('Closed:'),
        Expanded(
          child: TextField(),
        ),
      ],
    );
  }

  Row addPicture() {
    return Row(
      children: [
        Container(
          height: 100,
          width: 100,
          color: Colors.grey.shade200,
          child: Icon(Icons.add),
        ),
      ],
    );
  }

  Widget imageProfile() {
    return InkWell(
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.shade200,
        child: fileProfile != null ? Image.file(fileProfile) : Icon(Icons.add),
      ),
      onTap: () {
        // ignore: unnecessary_statements
        showChoiceDialogCover();
      },
    );
  }

  Future<void> chooseImageProfile(ImageSource imageSource) async {
    try {
      pickedImage =
          File((await imagePicker.getImage(source: imageSource)).path);
      _imageCropper();
    } catch (ex) {
      print(ex.toString());
    }
  }

  Future<void> _imageCropper() async {
    File cropFile = await ImageCropper.cropImage(
      sourcePath: pickedImage.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              //CropAspectRatioPreset.square,
              //CropAspectRatioPreset.ratio3x2,

              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              //CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              //CropAspectRatioPreset.ratio5x3,
              //CropAspectRatioPreset.ratio5x4,
              //CropAspectRatioPreset.ratio7x5,
              //CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      ),
    );
    setState(() {
      fileProfile = cropFile;
    });
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

  Future<void> uploadToDatabase() async {
    selectDay = '$fromDay-$toDay';
    selectTimes = '$startTime-$endTime';
    gymModel.days = selectDay;
    gymModel.time = selectTimes;
    print(selectDay);
    gymModel.insertToFireStorage(fileProfile).then((value) {
      setState(() {
        fileProfile.path.isEmpty;
        Navigator.pop(context);

      });
    });
  }
  @override
  void initState() {
    setState(() {
      fileProfile=null;
    });
    super.initState();
  }
}

//=============================================================================

class MultipleNotifier extends ChangeNotifier {
  List<String> _selectedItems;

  MultipleNotifier(this._selectedItems);

  List<String> get selectedItems => _selectedItems;

  bool isHaveItem(String value) => _selectedItems.contains(value);

  addItem(String value) {
    if (!isHaveItem(value)) {
      _selectedItems.add(value);
      notifyListeners();
    }
  }

  removeItem(String value) {
    if (isHaveItem(value)) {
      _selectedItems.remove(value);
      notifyListeners();
    }
  }

}
