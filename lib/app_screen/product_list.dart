import 'package:adminside/app_screen/add_product.dart';
import 'package:adminside/db/database.dart';
import 'package:adminside/models/categoriesData.dart';
import 'package:adminside/models/productsData.dart';
import 'package:adminside/widgets/drawer.dart';
import 'package:adminside/widgets/products_card_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  final String categoryToDisplay;

  const ProductList({this.categoryToDisplay});
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<ProductsData>>.value(
            value: DataBaseService().productsByCategory(widget.categoryToDisplay)),
        StreamProvider<List<Categories>>.value(
            value: DataBaseService().categories),


      ],
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
            elevation: 0.2,
            backgroundColor: Colors.redAccent,

            title: Text('Products List', style: TextStyle(color: Colors.white),)
        ),
        body: Products(),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            setState(() {

            });
            Navigator.push(context, MaterialPageRoute(builder: (_) =>AddProduct()));

          },
          tooltip: 'Add a product',
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),

    );
  }
}
