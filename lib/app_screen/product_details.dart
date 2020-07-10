import 'dart:io';

import 'package:adminside/db/database.dart';
import 'package:adminside/models/productsData.dart';
import 'package:adminside/widgets/product_details_widget.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';




class ProductDetailsTest extends StatefulWidget{
  final String product_name;
  final String product_id;
  final double product_price;
  final List product_picture;
  final String product_description;
  final String product_category;
  final int product_rating;

  const ProductDetailsTest({Key key, this.product_id, this.product_name, this.product_price, this.product_picture, this.product_description, this.product_category, this.product_rating}) : super(key: key);


  @override
  _ProductDetailsState createState() {
    try{return  _ProductDetailsState();} catch(e){print("printing error:..${e.toString()}");}

  }
}
class _ProductDetailsState extends State<ProductDetailsTest>{

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(content:
          Text('Yay! A SnackBar!'));
    return MultiProvider(
      providers: [
        StreamProvider<List<ProductsData>>.value(
          value:DataBaseService().productsById(widget.product_id),),
      ],
      child: Scaffold(
        appBar: AppBar(
            elevation: 0.1,
            backgroundColor: Colors.redAccent,
            leading: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.close, color: Colors.white,)),
            title: Text(widget.product_name, style: TextStyle(color: Colors.white),)
        ),

        body: ProductDetailsWidet(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final Query categories_list = Firestore.instance
                .collection('products').where("id", isEqualTo: widget.product_id);
            categories_list.getDocuments().then((snaps){
              print(snaps.documents.length);
              final String id_doc = snaps.documents[0].documentID;

              Firestore.instance.collection("products").document(id_doc).delete().then((value) {
                Fluttertoast.showToast(msg: 'Deleted product');

              });
            });
          },
          tooltip: 'Delete this product',
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.delete),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

//


}