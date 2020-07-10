import 'package:adminside/models/orderDetailsData.dart';
import 'package:adminside/models/ordersData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailsWidget extends StatefulWidget {
  @override
  _OrderDetailsWidgetState createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    final order_data= Provider.of<List<OrderData>>(context) ?? [];
    final order_details_data= Provider.of<List<OrderDetailsData>>(context) ?? [];
    double total = 0;
    double vat = 3.5;
    double shippment_fee = 200.0;
    setState(() {
      order_details_data.forEach((item) {
        print( item.price);
        total = total + (item.price * item.quantity);
      });
    });

    print('this user has');
    print(order_data.length);
    return Column(
      children: <Widget>[
        ListTile(
            title: Text('Order Status: ${order_data[0].order_status}',style: TextStyle(

            ),)
        ),

        ListTile(

            title: order_data[0].paid ? Text('Payment: Paid', style: TextStyle(color: Colors.green),)
                : Text('Payment: Not Paid', style: TextStyle(
                color: Colors.red
            ),)
        ),

        Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent

              ),

              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: order_details_data.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.only(left:18.0, top:15, bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Text(order_details_data[index].quantity.toString()),
                          SizedBox(width: 20,),
                          Text(order_details_data[index].productName),
                          SizedBox(width: MediaQuery.of(context).size.width - 250,),
                          Text(order_details_data[index].price.toString()),
                        ],
                      ),
                    );
                  }
              ),

            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(' TOTAL:',style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                  Text("ksh. ${100 + total + vat}",style: TextStyle(
                      fontSize: 20
                  ),),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Includes shippment and VAT fees',style: TextStyle(
                  fontSize: 10
              ),),
            )
          ],
        ),
        Container(


        ),
      ],
    );
  }
}
