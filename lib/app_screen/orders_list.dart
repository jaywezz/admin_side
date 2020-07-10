import 'package:adminside/app_screen/order_details.dart';
import 'package:adminside/models/ordersData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class OrdersList extends StatefulWidget {
  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<OrderData>>(context) ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        elevation: 0.3,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: ListView.builder(
              itemCount: orders.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index){
                if(orders.length == 0){
                  return Center(child: Text('No orders have been made'));
                }
                else
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
                                child: Icon(Icons.check, color: Colors.green,)
                              ),

                            ),
                            title: Text(
                              orders[index].order_id,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                            subtitle:  orders[index].paid ? Row(
                              children: <Widget>[
                               Icon(Icons.check_box, color: Colors.green, size: 20,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Paid', style: TextStyle(color: Colors.white)),
                                )
                              ] )
                                : Row(
                                  children: <Widget>[
                                  Icon(Icons.close, color: Colors.red, size: 20,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Awaiting payment', style: TextStyle(color: Colors.white)),
                                ),]),

                            trailing:
                            IconButton(icon: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 25.0),
                              onPressed: (){
                                   Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetails(
                                     order_id: orders[index].order_id,
                                     order_status: orders[index].status,
                                     paid: orders[index].paid,
                                   )));
                              },
                            ))


                    ),
                  );
                }
            ),
          )
        ],
      ),
    );
  }
}
