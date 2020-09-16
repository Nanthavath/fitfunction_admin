import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitfunction_admin/gyms/gym_page.dart';
import 'package:fitfunction_admin/screens/exercises/exercises_page.dart';
import 'package:fitfunction_admin/screens/user_page.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

String currentUserID;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final formKey = GlobalKey<FormState>();
String _email;
String _password;
bool loading = false;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.orange),
        ),
      ),
      body: SingleChildScrollView(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                  decoration: BoxDecoration(),
                  alignment: Alignment.topCenter,
                  height: 80,
                  child: Text('Admin Application',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              color: Colors.orange,
                              child: Container(
                                margin: EdgeInsets.all(10),
                                height: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Gyms',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    FutureBuilder(
                                        future: FirebaseFirestore.instance
                                            .collection('Gyms')
                                            .get(),
                                        builder: (context, snapshotGymlength) {
                                          if (!snapshotGymlength.hasData)
                                            return Text(
                                              '0',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            );
                                          return Text(
                                            '${snapshotGymlength.data.documents.length.toString()}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Card(
                            color: Colors.black87,
                            child: Container(
                              height: 120,
                              child: FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('Trainer')
                                    .get(),
                                builder: (context, snapshotTrainer) {
                                  if (!snapshotTrainer.hasData) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Gyms',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          '0',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Trainers',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      Text(
                                        '${snapshotTrainer.data.documents.length.toString()}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ))
                        ],
                      ),
                      Card(
                        color: Colors.black87,
                        child: Container(
                          height: 200,
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
                                      FutureBuilder(
                                          future: FirebaseFirestore.instance
                                              .collection('Exercises')
                                              .get(),
                                          builder: (context, snapshotexLength) {
                                            if (!snapshotexLength.hasData)
                                              return Text(
                                                '-',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              );
                                            return Text(
                                              snapshotexLength
                                                  .data.documents.length
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.orange,
                        child: Container(
                          height: 200,
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(23),
                                child: Icon(
                                  Icons.person,
                                  size: 80,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Users',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 30,
                                      ),
                                      FutureBuilder(
                                          future: FirebaseFirestore.instance
                                              .collection('Users')
                                              .get(),
                                          builder: (context, snapshotuserLeng) {
                                            if (!snapshotuserLeng.hasData)
                                              return Text(
                                                '-',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              );
                                            return Text(
                                              snapshotuserLeng
                                                  .data.documents.length
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              // margin: EdgeInsets.only(top: 20),
              accountName: Text('Gest'),
              accountEmail: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  signInButton(),
                ],
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/fitfunction-e5947.appspot.com/o/profile%20.png?alt=media&token=9a6e3f28-c830-4add-bb3d-fca840d9fef7'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text(
                'Dashboard',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text(
                'User',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserPage(),
                ));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text(
                'Exercises',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ExercisesPage(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text(
                'Gym',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GymPage(),
                ));
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  RaisedButton signInButton() {
    return RaisedButton(
      child: Text('Sig In'),
      onPressed: () {
        Navigator.pop(context);
        showLoginDialog().show();
      },
    );
  }

  Alert showLoginDialog() {
    return Alert(
        context: context,
        title: "Sign In",
        content: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.account_circle),
                  labelText: 'Email',
                ),
                validator: (value) =>
                    value.isEmpty ? 'Invalid your Email' : null,
                onSaved: (value) => _email = value.trim(),
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
                validator: (value) =>
                    value.isEmpty ? 'Invalid your Password' : null,
                onSaved: (value) => _password = value,
              ),
            ],
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              final form = formKey.currentState;
              if (form.validate()) {
                form.save();
                signInWithEmail();
              }
            },
            child: Text(
              "Sign In",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]);
  }

  Future<void> signInWithEmail() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return await auth
        .signInWithEmailAndPassword(email: _email, password: _password)
        .then((value) {
      currentUserID = value.user.uid;
      print(currentUserID);
      setState(() {
        Navigator.pop(context);
      });
    });
  }
}
