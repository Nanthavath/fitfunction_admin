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
        title: Text('Dashboard',style: TextStyle(color: Colors.orange),),
      ),
      body: Center(
        child: ListView(
          children: [
            Container(
              height: 150,
              color: Colors.blueGrey,
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
