import 'package:adminside/models/productsData.dart';
import 'package:adminside/widgets/product_tile.dart';
import 'package:flutter/material.dart';
 import 'package:provider/provider.dart';

 
 class ProductListWidget extends StatefulWidget {
   @override
   _ProductListWidgetState createState() => _ProductListWidgetState();
 }
 
 class _ProductListWidgetState extends State<ProductListWidget> {
   @override
   Widget build(BuildContext context) {
     final products = Provider.of<List<ProductsData>>(context) ?? [];
          if(products.length == 0){
            return Center(child: Text('Oops!!,No items in this category'));
          }
         return ListView.builder(
           itemCount: products.length,
           itemBuilder: (context, index){


               return ProductTile(productsData: products[index],);
             }

         );
   }
 }
 