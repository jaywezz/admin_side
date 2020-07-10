import 'package:adminside/db/database.dart';
import 'package:adminside/models/categoriesData.dart';
import 'package:adminside/models/productsData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_screen/home.dart';
import 'models/ordersData.dart';
import 'models/userData.dart';


void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
          StreamProvider<List<UserData>>.value(
             value:DataBaseService().Allusers,),

        StreamProvider<List<Categories>>.value(
          value:DataBaseService().categories,),

        StreamProvider<List<ProductsData>>.value(
          value:DataBaseService().products,),
        StreamProvider<List<OrderData>>.value(
          value:DataBaseService().Allorders,)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.redAccent
        ),
        home: Admin(),
      ),
    );
  }
}

