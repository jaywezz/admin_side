import 'package:adminside/app_screen/user_profile.dart';
import 'package:adminside/models/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Userlist extends StatefulWidget {
  @override
  _UserlistState createState() => _UserlistState();
}

class _UserlistState extends State<Userlist> {
  @override
  Widget build(BuildContext context) {
    final user_data= Provider.of<List<UserData>>(context) ?? [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Registered Users'),
        elevation: 0.3,

      ),
      body:ListView(
          children: <Widget>[
            Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: user_data.length,
                  itemBuilder:(context, index){
                    if(user_data.length == 0){
                      return Text('No registered users',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),);
                    }
                    return  Card(
                      elevation: 8.0,
                      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                        child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            leading: Container(
                              padding: EdgeInsets.only(right: 12.0),
                              decoration: new BoxDecoration(
                                  border: new Border(
                                      right: new BorderSide(width: 1.0, color: Colors.white24))),
//                              child: Icon(Icons.person, color: Colors.white),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text(user_data[index].names[0] + user_data[index].names[1]),
                            ),

                            ),
                            title: Text(
                              user_data[index].names,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                            subtitle: Row(
                              children: <Widget>[
                                Icon(Icons.contact_phone, color: Colors.yellowAccent, size: 20,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(user_data[index].phone_number ?? 'Not provided', style: TextStyle(color: Colors.white)),
                                )
                              ],
                            ),
                            trailing:
                            IconButton(icon: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 25.0),
                              onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(
                                user_id: user_data[index].user_id,
                                user_name:  user_data[index].names,
                                id_no:  user_data[index].id_no,
                                payment_method:  user_data[index].payment_method,
//                                date_entered: user_data[index].date_entered,
                                address:  user_data[index].address,
                                phone_number: user_data[index].phone_number,
                                email:  user_data[index].email,
                                city:  user_data[index].city,
                                gender:  user_data[index].gender,
                              )));
                              },
                            ))


                      ),
                    );
                  }
              ),
            ),

          ],
        ),

    );
  }
}
