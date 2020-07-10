import 'dart:io';

import 'package:adminside/db/database.dart';
import 'package:adminside/models/categoriesData.dart';
import 'package:adminside/widgets/categories_details_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CategoryDetails extends StatefulWidget {
  final String category_name;
  final String category_description;
  final String imageUrl;
  final String category_id;

  const CategoryDetails({Key key, this.category_name,this.category_id, this.category_description, this.imageUrl}) : super(key: key);
  @override
  _CategoryDetailsState createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  File _image1;
  final picker = ImagePicker();
  bool uploading = false;
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image1 = File(pickedFile.path);

      print(_image1);
    });
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Categories>>.value(
          value:DataBaseService().categoriesById(widget.category_id),),

      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Category details'),
          elevation: 0.3,
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            child: CategoriesDetailsWidget(
              category_id: widget.category_id,
              category_name: widget.category_name,
              category_description: widget.category_description,
              imageUrl: widget.imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}
