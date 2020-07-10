import 'package:adminside/db/database.dart';
import 'package:adminside/models/orderDetailsData.dart';
import 'package:adminside/models/ordersData.dart';
import 'package:adminside/widgets/order_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetails extends StatefulWidget {
  final String order_id;
  final String order_date;
  final bool paid;
  final String payment_date;
  final String required_date;
  final String ship_date;
  final String customer_id;
  final String order_status;

  const OrderDetails({Key key, this.order_id, this.order_date, this.paid, this.payment_date, this.required_date, this.ship_date, this.customer_id, this.order_status}) : super(key: key);



  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        StreamProvider<List<OrderData>>.value(
            value:DataBaseService().ordersByOID(widget.order_id)
        ),

        StreamProvider<List<OrderDetailsData>>.value(
            value:DataBaseService().ordersDetails(widget.order_id)
        ),

      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order details'),
          elevation: 0.3,
        ),
        body: ListView(
          children: <Widget>[
              OrderDetailsWidget()
          ],
        ),
      ),
    );
  }
}
