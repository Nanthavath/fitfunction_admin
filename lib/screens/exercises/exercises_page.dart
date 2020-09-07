import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitfunction_admin/screens/exercises/addExercises_page.dart';
import 'package:fitfunction_admin/widgets/circularProgress.dart';
import 'package:flutter/material.dart';

class ExercisesPage extends StatefulWidget {
  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

String url =
    'https://firebasestorage.googleapis.com/v0/b/fitfunction-e5947.appspot.com/o/logowell.png?alt=media&token=caa61db6-3f9a-4a80-afe4-dd32926b0922';
String nunbell =
    'https://firebasestorage.googleapis.com/v0/b/fitfunction-e5947.appspot.com/o/profile%20.png?alt=media&token=9a6e3f28-c830-4add-bb3d-fca840d9fef7';

class _ExercisesPageState extends State<ExercisesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Exercises').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgress(
              title: 'Loading...',
            );
          }
          return Container(
            margin: EdgeInsets.all(10),
            child: ListView(
              children: [
                Card(
                  color: Colors.black87,
                  child: Container(
                    height: 150,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          width: 100,
                          child: CachedNetworkImage(
                            imageUrl: url,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Exercises',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                CachedNetworkImage(
                                  height: 30,
                                  width: 30,
                                  imageUrl: nunbell,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  snapshot.data.documents.length.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.orange,
                  child: Text(
                    'Add Exercises',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddExercises(),
                    ));
                  },
                ),
                Container(
                  child: Column(
                    children:
                        List.generate(snapshot.data.documents.length, (index) {
                      DocumentSnapshot snapExercises =
                          snapshot.data.documents[index];
                      return Card(
                        child: Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 100,
                              child: Image(
                                image: NetworkImage(
                                  snapExercises.data()['urlImage'],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapExercises.data()['name'],
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Type')
                                  ],
                                ),
                              ),
                            ),
                            popUpMenu(snapExercises.id, context),
                          ],
                        )),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget popUpMenu(String id, BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 1) {
          deleteExercises(id).then((value) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Deleted...',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
            print('Deleted');
          });

        }
      },
      itemBuilder: (context) => [

        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: Colors.red,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Delete'),
            ],
          ),
        )
      ],
    );
  }



  Future<void> deleteExercises(String exerciseID) async {
    await FirebaseFirestore.instance
        .collection('Exercises')
        .doc(exerciseID)
        .delete();
  }
}
