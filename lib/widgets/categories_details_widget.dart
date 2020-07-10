import 'dart:io';

import 'package:adminside/models/categoriesData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CategoriesDetailsWidget extends StatefulWidget {
  final String category_name;
  final String category_description;
  final String imageUrl;
  final String category_id;

  const CategoriesDetailsWidget({Key key, this.category_name, this.category_description, this.imageUrl, this.category_id}) : super(key: key);

  @override
  _CategoriesDetailsWidgetState createState() => _CategoriesDetailsWidgetState();
}

class _CategoriesDetailsWidgetState extends State<CategoriesDetailsWidget> {
  File _image1;
  final picker = ImagePicker();
  bool uploading = false;
  bool category_editing_enabled = false;
  bool category_description_editing_enabled = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String categoryName;
  String categoryDescription;


  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image1 = File(pickedFile.path);

      print(_image1);
    });
  }
  @override
  Widget build(BuildContext context) {
    final category= Provider.of<List<Categories>>(context) ?? [];
    return  ListView(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned(
              bottom: 4,
              right: 7,
              child: IconButton(icon: Icon(Icons.edit ,color: Colors.red,),
                onPressed: () async{
                  await getImage().then((image) {
                    var alert = new AlertDialog(
                      content: Container(
                        width: 50,
                        child: Image.file(_image1, width: 20,fit: BoxFit.contain,),
                      ),
                      actions: <Widget>[
                        FlatButton(

                          color: Colors.red,
                          textColor: Colors.white,
                          child: uploading ? Container(
                            height: 20,
                            color: Colors.transparent,
                            child: Center(
                              child: SpinKitRotatingCircle(
                                color: Colors.white,
                                size: 13.0,
                              ),
                            ),
                          ): Text(' Update photo') ,
                          onPressed: () async {
                            print('deleteing and updating ...');
                            if(_image1 != null){
                              setState(() {
                                uploading =true;
                              });
                              String imageUrl;
                              final FirebaseStorage storage = FirebaseStorage.instance;
                              final String pictures1= "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
                              StorageUploadTask upload_task = storage.ref().child(pictures1).putFile(_image1);
                              upload_task.onComplete.then((value) async{
                                imageUrl = await value.ref.getDownloadURL();
                                StorageReference photoRef = await FirebaseStorage.instance
                                    .ref()
                                    .getStorage()
                                    .getReferenceFromUrl(category[0].imageUrl);

                                try{

                                  photoRef.delete().then((value) async{
                                    final Query categories_list = Firestore.instance
                                        .collection('categories').where("category_id", isEqualTo: widget.category_id);
                                    categories_list.getDocuments().then((snaps){
                                      print(snaps.documents.length);
                                      final String id_doc = snaps.documents[0].documentID;
                                      Firestore.instance.collection("categories").document(id_doc).updateData({
                                        "image": imageUrl,

                                      });
                                    });
                                  });


                                  print('deleted');
                                  setState(() {
                                    uploading =false;
                                  });
                                }catch(e){
                                  print('an error ocurred during deleting');
                                  setState(() {
                                    uploading  = false;
                                  });
                                }

                              });
                            }
                            else Container(
                              child: Text('An unknown error occured, try again,',style: TextStyle(
                                  color: Colors.red
                              ),),
                            );
                          },
                        ),
                      ],
                    );
                    showDialog(context: context, builder: (_) => alert);
                  });

                },
              ),
            ),
            Center(
              child: Container(
                height: 100,
                width: 200,

                decoration: BoxDecoration(
                    color: Colors.transparent

                ),

                child: Image.network(category[0].imageUrl),
              ),
            ),


          ],
        ),
        SizedBox(height: 20,),
        !category_editing_enabled ? ListTile(
          trailing: IconButton(
            onPressed: (){


              setState(() {
                nameController.text = category[0].categoryName;
                category_editing_enabled = true;
              });
            },
            icon: Icon(Icons.edit, color: Colors.red,),),
          title: Text(

            category[0].categoryName,

            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 24.0),
          ),

        ) : Form(
            child:    Stack(

              children: <Widget>[
                Container(
                  width: 250,
                  child: TextFormField(
                    controller: nameController,
                    minLines: 2,
                    maxLines: 2,
                    validator: (name){
                      print('you have printed ${name}');
                      if(name.isEmpty){
                        return 'Cannot add an empty category';
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "add category"
                    ),
                  ),
                ),
                Positioned(
                  right: 30,
                  child: IconButton(
                    onPressed: (){
                      print('you have printed ${categoryName}');
                      final Query categories_list = Firestore.instance
                          .collection('categories').where("category_id", isEqualTo: widget.category_id);
                      categories_list.getDocuments().then((snaps){
                        print(snaps.documents.length);
                        final String id_doc = snaps.documents[0].documentID;
                        Firestore.instance.collection("categories").document(id_doc).updateData({
                          "category": nameController.text,

                        });
                      });
                      setState(() {
                        category_editing_enabled = false;
                      });
                    },
                    icon: Icon(Icons.check),tooltip: 'Update',color: Colors.green,),
                )
              ],
            ),

        ),

        !category_description_editing_enabled ? ListTile(
          trailing: IconButton(
            onPressed: (){
              setState(() {
                descriptionController.text = category[0].categoryDescription;
                category_description_editing_enabled = true;
              });
            },
            icon: Icon(Icons.edit, color: Colors.red,),),
          title: Text(

            category[0].categoryDescription,

            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 24.0),
          ),

        ) : Form(
          child:    Stack(
            children: <Widget>[
              Container(
                width: 250,
                child: TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 6,
                  validator: (value){
                    if(value.isEmpty){
                      return 'Cannot add an empty category description';
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "Category description"
                  ),
                ),
              ),
              Positioned(
                right: 30,
                child: IconButton(
                  onPressed: () {
                    print(categoryName);
                    final Query categories_list = Firestore.instance
                        .collection('categories').where("category_id", isEqualTo: widget.category_id);
                    categories_list.getDocuments().then((snaps){
                      print(snaps.documents.length);
                      final String id_doc = snaps.documents[0].documentID;
                      Firestore.instance.collection("categories").document(id_doc).updateData({
                        "description": descriptionController.text,

                      });
                    });
                    setState(() {
                      category_description_editing_enabled = false;
                    });
                  },
                  icon: Icon(Icons.check),tooltip: 'Update',color: Colors.green,),
              )
            ],
          ),

        ),
        SizedBox(height: 30,),
        FlatButton(

          color: Colors.red,
          textColor: Colors.white,
          child: uploading ? Container(
            height: 20,
            color: Colors.transparent,
            child: Center(
              child: SpinKitRotatingCircle(
                color: Colors.white,
                size: 13.0,
              ),
            ),
          ): Text('Delete Category') ,
          onPressed: () async {
            final Query categories_list = Firestore.instance
                .collection('categories').where("category_id", isEqualTo: widget.category_id);
            categories_list.getDocuments().then((snaps) async{
              print(snaps.documents.length);
              final String id_doc = snaps.documents[0].documentID;
              Navigator.pop(context);
              await Firestore.instance.collection("categories").document(id_doc).delete().then((value){
                Fluttertoast.showToast(msg: 'Deleted category and its sub categories', backgroundColor: Colors.redAccent);
              });
            });
          },
        ),
      ],
    );
  }
}

