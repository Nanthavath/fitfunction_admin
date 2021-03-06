import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'addTrainer_page.dart';

// ignore: must_be_immutable
class TrainerPage extends StatefulWidget {
  String gymKey;
  String name;
  TrainerPage(this.gymKey,this.name);

  @override
  _TrainerPageState createState() => _TrainerPageState(gymKey,name);
}

class _TrainerPageState extends State<TrainerPage> {
  String gymID;
  String name;
  _TrainerPageState(this.gymID,this.name);
  String searchkey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(name),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddtrainerPage(),
          ))
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder(
          future:
              FirebaseFirestore.instance.collection('Gyms').doc(gymID).get(),
          builder: (context, snapshotkey) {
            if (!snapshotkey.hasData)
              return Container(
                child: Text('loading ngo2'),
              );
            print(gymID);
            return Column(
              children: [
                Container(

                    // height: imageUrl == null ? 300 : null,
                    child: snapshotkey.data.data()['profileImg'] == null
                        ? Container()
                        : Container(
                            color: Colors.grey[300],
                            height: 200,
                            child: Image.network(
                              snapshotkey.data.data()['profileImg'],
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                            ),
                          )),
                Container(
                  //padding: EdgeInsets.only(left: 25),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Trainer')
                              .where('gymID', isEqualTo: "$gymID")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Text(
                                  'Trainer amount: 0',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold),
                                ),
                              );

                            return Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                'Trainer amount:  ${snapshot.data.documents.length.toString()}',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                            onChanged: (value) {
                              searchkey = value;
                              if (value.trim().isEmpty) {
                                searchkey = null;
                              }
                              print(searchkey);
                              setState(() {});
                            },
                            autofocus: true,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 12.0, bottom: 12.0, top: 0.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                hintText: "Search",
                                fillColor: Colors.white,
                                hintStyle: TextStyle(color: Colors.black))),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400],
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: searchkey == null
                      ? FirebaseFirestore.instance
                          .collection('Trainer')
                          .where('gymID', isEqualTo: gymID)
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('Trainer')
                          .where('gymID', isEqualTo: gymID)
                          .where('name', isEqualTo: searchkey)
                          .snapshots(),
                  builder: (context, snapshotList) {
                    if (!snapshotList.hasData) return Container();
                    return SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshotList.data.documents.length,
                        itemBuilder: (context, index) {
                          print(snapshotList.data.documents.length.toString());
                          DocumentSnapshot snapshot2 =
                              snapshotList.data.documents[index];
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black54.withOpacity(0.2),
                                      spreadRadius: 0,
                                      blurRadius: 2,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              // boxShadow: [
                                              //   BoxShadow(
                                              //     color:
                                              //         Colors.black54.withOpacity(0.2),
                                              //     spreadRadius: 0,
                                              //     blurRadius: 3,
                                              //     offset: Offset(2,
                                              //         3), // changes position of shadow
                                              //   ),
                                              // ],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40))),
                                          child: snapshot2.data()['profile'] ==
                                                  null
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                  width: 80,
                                                  height: 80,
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 30,
                                                    color: Colors.grey[400],
                                                  ),
                                                )
                                              : ClipOval(
                                                  child: Container(
                                                    width: 65,
                                                    height: 65,
                                                    child: Image.network(
                                                      snapshot2
                                                          .data()['profile'],
                                                      fit: BoxFit.contain,
                                                      loadingBuilder: (context,
                                                          child,
                                                          ImageChunkEvent
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
                                                        return Center(
                                                            child: Container(
                                                                child:
                                                                    CircularProgressIndicator()));
                                                      },
                                                    ),
                                                  ),
                                                )),
                                      SizedBox(width: 15),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            //width: 200,
                                            child: Text(
                                              snapshot2
                                                  .data()['name']
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 18.6,
                                                fontFamily: 'NotoSansBoldMulti',
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  PopupMenuButton(
                                      onSelected: (value) {
                                        if (value == 2) {
                                          Clipboard.setData(ClipboardData(
                                              text: snapshot2.id));
                                        }
                                        if (value == 3) {
                                          return showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'ທ່ານແນ່ໃຈແລ້ວບໍ່ທີ່ຈະລຶບຂໍ້ມູນ'),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        GestureDetector(
                                                          child: Text('Yes',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          onTap: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Trainer')
                                                                .doc(snapshot2
                                                                    .id)
                                                                .delete();
                                                            print(
                                                                'doing delete');
                                                            // user => noti(delete)
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        SizedBox(
                                                          height: 60,
                                                        ),
                                                        GestureDetector(
                                                          child: Text('No',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        }
                                      },
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 2,
                                              child: Text('Copy ID'),
                                            ),
                                            PopupMenuItem(
                                              value: 3,
                                              child: Text('Delete'),
                                            ),
                                          ])
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              ],
            );
          }),
    );
  }
}
