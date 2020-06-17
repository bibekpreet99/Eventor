import 'package:eventor/screens/Welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventor/Authnetication/Authenticate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventor/constants.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  static const id = 'home_page';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    getEvents();
  }
  FirebaseUser user;
  String userid;
  Firestore _db = Firestore.instance; 
  void getEvents() async {
    final user1 = await loggedInUser();
    setState(() {
      user = user1;
    });
    if(user1!=null)
    {
      await for (var i in _db.collection('users').snapshots()){
        for(var data in i.documents)
        {
          if(data.data['email']==user.email)
          {
            setState((){
              userid = data.documentID;
            });
          }
        }
      }
    }
  }
  String email;
  String password;
  String newEventDesc;
  String newEventDate;
  String newEventTime;
  TextEditingController _date = TextEditingController();
  TextEditingController _time = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Add Event",
              style: TextStyle(
                fontSize: 20,
                color: Colors.red
              ),
            ),
            onPressed: (){
              showModalBottomSheet(
                isScrollControlled: true,
                context: context, 
                 shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                ),
                builder: (context){
                return SingleChildScrollView(
                  reverse: true,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                      bottom: MediaQuery.of(context).viewInsets.bottom
                    ),
                    child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Event Info"),
                              SizedBox(width: 10),
                              Icon(Icons.event)
                            ],
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            decoration: kTextFormFieldDecoration2.copyWith(
                              hintText: "What is the Event?"
                            ),
                            onChanged: (newVal){
                              setState(() {
                                newEventDesc = newVal;
                              });
                            },
                          ),
                          SizedBox(height: 20,),
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              showDatePicker(
                                context: context,  
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(), 
                                lastDate: DateTime(2022),
                              ).then((value){
                                setState(() {
                                  newEventDate = DateFormat("d-MM-y").format(value);
                                  _date.value = TextEditingValue(text: newEventDate);
                                });
                              });
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: kTextFormFieldDecoration2.copyWith(
                                  hintText: "Date",
                                  prefixIcon: Icon(
                                    Icons.calendar_today,
                                    color: Colors.red,
                                  )
                                ),
                                controller: _date,
                                keyboardType: TextInputType.datetime,
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          GestureDetector(
                            onTap: () {
                              showTimePicker(
                                context: context,  
                                initialTime: TimeOfDay.now()
                              ).then((value){
                                setState(() {
                                  newEventTime = value.format(context);
                                  _time.value = TextEditingValue(text: newEventTime);
                                });
                              });
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: kTextFormFieldDecoration2.copyWith(
                                  hintText: "Time",
                                  prefixIcon: Icon(
                                    Icons.access_time,
                                    color: Colors.red,
                                  )
                                ),
                                controller: _time,
                                keyboardType: TextInputType.datetime,
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          FlatButton(
                          onPressed: (){
                            List<Object> obj = [
                              {
                                "date": newEventDate,
                                "desc": newEventDesc,
                                "time": newEventTime
                              }
                            ];
                            Firestore.instance.collection("users").document(userid).updateData({
                              "myevents": FieldValue.arrayUnion(obj)
                            }).catchError((e)=>print(e));
                            setState(() {
                              newEventDate = "";
                              newEventDesc = "";
                              newEventTime = "";
                              _date.value = TextEditingValue(text: "");
                              _time.value = TextEditingValue(text: "");
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('Add Event', style: TextStyle(fontSize: 20),),
                          color: Colors.red,
                        ),
                        SizedBox(height: 10,),
                        ],
                      ),
                      ),
                );
              });
            }
          ),
         FlatButton(
            child: Text(
              "Log out",
              style: TextStyle(
                fontSize: 20,
                color: Colors.red
              ),
            ),
            onPressed: (){
              signOut();
              Navigator.pushReplacementNamed(context, Welcome.id);
            },
          )
        ],
      ),
      body: SafeArea(
          child: StreamBuilder(
            stream: _db.collection('users').snapshots(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                final docs = snapshot.data.documents;
                List<Slidable> events = [];
                for(var doc in docs){
                  if(doc.data['email']==user.email)
                  {
                    List myevents = doc.data['myevents'];
                    print(myevents);
                    if(myevents.isEmpty)
                    {
                      return Center(child: Text("No events yet"));
                    }
                    for(var i in myevents){
                      String date = i["date"];
                      String desc = i["desc"];
                      String time = i["time"];
                      events.add(
                        Slidable(
                          actionPane: SlidableBehindActionPane(),
                          actionExtentRatio: 0.25,
                          secondaryActions: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top:4, bottom: 4),
                              child: IconSlideAction(
                                caption: 'Delete',
                                color: Colors.blue,
                                icon: Icons.delete,
                                onTap: ()async{
                                  DocumentReference docRef = Firestore.instance.collection("users").document(userid);
                                  DocumentSnapshot snap = await docRef.get();
                                  List events = snap.data['myevents'];
                                  int count=0;
                                  for(var i in events){
                                    if(i['desc']=='$desc'){
                                      events.removeAt(count);
                                      break;
                                    }
                                    count = count +1;
                                  }
                                  docRef.updateData({
                                    "myevents": events
                                  });
                                },
                              ),
                            ),
                          ],
                          child: Card(
                            color: Colors.red,
                            child: ListTile(
                              title: Text("$desc"),
                              subtitle: Text("$date"),
                              trailing: Text("$time"),
                            ),
                      ),
                        ));
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: events,
                      ),
                    );
                  }
                }
              }
              else{
                return Container(
                  child: Center(
                    child: Text('No events yet'),
                  ),
                );
              }
            },
          )
      )
    );
  }
}