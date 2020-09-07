import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitfunction_admin/gyms/addGym_page.dart';
import 'package:flutter/material.dart';

class GymPage extends StatefulWidget {
  @override
  _GymPageState createState() => _GymPageState();
}

class _GymPageState extends State<GymPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gym'),
        actions: [
          Icon(
            Icons.search,
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Gyms').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(
              semanticsLabel: 'Loading..',
            );
          }
          if (snapshot.data == null) {
            return Container();
          }
          return Container(
            margin: EdgeInsets.all(10),
            child: ListView(
              children: [
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              color: Colors.orange,
                              child: Container(
                                margin: EdgeInsets.all(10),
                                height: 80,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Gyms',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    Text(
                                      '${snapshot.data.documents.length.toString()}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Card(
                            color: Colors.black87,
                            child: Container(
                              height: 100,
                            ),
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
                addGymButton(),
                //searchButton(),
                Container(
                  child: Container(
                    child: Column(
                      children: List.generate(snapshot.data.documents.length,
                          (index) {
                        DocumentSnapshot snapGym =
                            snapshot.data.documents[index];
                        return Container(
                          child: Card(
                            child: Container(
                              child: ListTile(
                                leading: Image(
                                  image: NetworkImage(
                                      snapGym.data()['profileImg']),
                                ),
                                title: Text(snapGym.data()['name']),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  RaisedButton addGymButton() {
    return RaisedButton(
      color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            color: Colors.white,
          ),
          Text(
            'Add Gym',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddGymPage(),
        ));
      },
    );
  }

  Container searchButton() {
    return Container(
      height: 45,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(),
          ),
        ),
      ),
    );
  }
}
