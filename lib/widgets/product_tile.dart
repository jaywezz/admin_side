import 'package:adminside/models/productsData.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {

  final ProductsData productsData;
  ProductTile({this.productsData});
  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(

          title: Text(productsData.producsCategory),
          subtitle: Text(productsData.productDescription),
        ),
      ),
    );
  }
}


