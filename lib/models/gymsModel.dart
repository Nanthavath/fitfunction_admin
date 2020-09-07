import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class GymModel{
  String _name;
  String _days;
  String _time;
  String _tel;
  List _option;
  String _promotion;
  String _location;
  String _profileImg;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get days => _days;

  String get profileImg => _profileImg;

  set profileImg(String value) {
    _profileImg = value;
  }

  String get location => _location;

  set location(String value) {
    _location = value;
  }

  String get promotion => _promotion;

  set promotion(String value) {
    _promotion = value;
  }

  List get option => _option;

  set option(List value) {
    _option = value;
  }

  String get tel => _tel;

  set tel(String value) {
    _tel = value;
  }

  String get time => _time;

  set time(String value) {
    _time = value;
  }

  set days(String value) {
    _days = value;
  }

  Future<void>insertToFireStorage(File file)async{
    Random random = Random();
    int i = random.nextInt(100000);

    final StorageReference storageReference = FirebaseStorage.instance.ref().child('/Gyms/Profile/gymsprofile_$i');
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    profileImg=await (await uploadTask.onComplete).ref.getDownloadURL();
    print(profileImg);
    uploadToFireStore();
  }

  Future<void> uploadToFireStore() async{
    await FirebaseFirestore.instance.collection('Gyms').add({
      'name':name,
      'option':option.toList(),
      'day':days,
      'time':time,
      'tel':tel,
      'promotion':promotion,
      'location':location,
      'profileImg':profileImg,
    });
  }
}