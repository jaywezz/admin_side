
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {
  final String user_name;
  final String address;
  final String phone_number;
  final String email;
  final String gender;
  final String date_entered;
  final String id_no;
  final String payment_method;
  final String user_id;
  final String city;

  const ProfilePage({Key key, this.user_name,this.phone_number, this.address, this.email, this.gender, this.date_entered, this.id_no, this.payment_method, this.user_id, this.city}) : super(key: key);


  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
   int total_orders = 0;
  @override
  Widget build(BuildContext context) {
    Firestore.instance.collection('orders').where('customer_id', isEqualTo: widget.user_id).getDocuments().then((snaps) {
    setState(() {
      total_orders = snaps.documents.length;
    });
    });
    return Scaffold(
      // backgroundColor: Colors.deepOrange,
      appBar: AppBar(
        title: Text(widget.user_name),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
            color: Colors.green
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CircleAvatar(
                      child: Icon(
                        Icons.call,
                        size: 30.0,
                      ),
                      minRadius: 30.0,
                      backgroundColor: Colors.red.shade600,
                    ),
                    CircleAvatar(
                      minRadius: 60,
                      backgroundColor: Colors.deepOrange.shade300,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/index.png'),
                        minRadius: 50,
                      ),
                    ),
                    CircleAvatar(
                      child: Icon(
                        Icons.message,
                        size: 30.0,
                      ),
                      minRadius: 30.0,
                      backgroundColor: Colors.red.shade600,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.user_name,
                  style: TextStyle(fontSize: 22.0, color: Colors.white),
                ),
                Text(
                 widget.email,
                  style: TextStyle(fontSize: 14.0, color: Colors.red.shade700),
                )
              ],
            ),
          ),
          Container(
            // height: 50,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.deepOrange.shade300,
                    child: ListTile(
                      title: Text(

                        total_orders.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      ),
                      subtitle: Text(
                        "Orders",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.red,
                    child: ListTile(
                      title: Text(
                        "0",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      ),
                      subtitle: Text(
                        "Returns",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              "Email",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              widget.email ?? 'Not provided',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            title: Text(
              "City",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              widget.city ?? 'Not provided',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Phone",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              widget.phone_number ?? 'Not provided',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Id_no",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
             widget.id_no ?? 'Not provided',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Payment method",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              widget.payment_method ?? 'Not provided',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
//          ListTile(
//            title: Text(
//              "Date entered",
//              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
//            ),
//            subtitle: Text(
//              widget.date_entered.toString() ?? 'Unable to get date',
//              style: TextStyle(fontSize: 18.0),
//            ),
//          ),
          Divider(),
        ],
      ),
    );
  }
}