import 'dart:io';

import 'package:adminside/models/productsData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductDetailsWidet extends StatefulWidget {
  @override
  _ProductDetailsWidetState createState() => _ProductDetailsWidetState();
}

class _ProductDetailsWidetState extends State<ProductDetailsWidet> {
  File _image1;
  final picker = ImagePicker();
  TextEditingController productName_controller = TextEditingController();
  TextEditingController productprice_controller = TextEditingController();
  TextEditingController productdescription_controller = TextEditingController();
  GlobalKey<FormState> _nameformKey = GlobalKey<FormState>();
  GlobalKey<FormState> _descriptionformKey = GlobalKey<FormState>();
  GlobalKey<FormState> _priceformKey = GlobalKey<FormState>();

  bool editing_name = false;
  bool editing_price = false;
  bool editing_description = false;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image1 = File(pickedFile.path);

      print(_image1);
    });
  }
  @override
  Widget build(BuildContext context) {
    bool uploading = false;
    final product = Provider.of<List<ProductsData>>(context) ?? [];
    if(product.length == 0){
      return Container(
        child: Center(child: Text('The product does not exist or has been deleted')),
      );
    }else{
      return ListView(
        children: <Widget>[

          Container(
            height: 200,
            child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.horizontal,
                itemCount: product[0].images.length ?? [],
                itemBuilder: (context, index){
                  return  Stack(
                    children: <Widget>[
                      Positioned(
                        right: 7,
                        bottom: 12,
                        child: IconButton(
                          onPressed: () async{
                            getImage().then((image) {
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
                                      this.setState(() {
                                        uploading =true;
                                      });
                                      print('deleting and updating ...');
                                      if(_image1 != null){

                                        String imageUrl;

                                        final FirebaseStorage storage = FirebaseStorage.instance;
                                        final String pictures1= "${index.toString()+DateTime.now().millisecondsSinceEpoch.toString()+product[0].productName}.jpg";
                                        StorageUploadTask upload_task = storage.ref().child(pictures1).putFile(_image1);
                                        upload_task.onComplete.then((value) async{
                                          imageUrl = await value.ref.getDownloadURL();

                                          print('new url ${imageUrl}');


                                          StorageReference photoRef = await FirebaseStorage.instance
                                              .ref()
                                              .getStorage()
                                              .getReferenceFromUrl(product[0].images[index]);

                                          try{

                                            photoRef.delete().then((value) async{
                                              final Query categories_list = Firestore.instance
                                                  .collection('products').where("id", isEqualTo: product[0].producsId);
                                              categories_list.getDocuments().then((snaps){
                                                print(snaps.documents.length);
                                                final String id_doc = snaps.documents[0].documentID;
                                                try{
                                                  if(index == 0){
                                                    List<String> imagesUrl = [imageUrl, product[0].images[1],product[0].images[2] ];
                                                    Firestore.instance.collection("products").document(id_doc).updateData({
                                                      "images": imagesUrl,
                                                    });
                                                  } else if(index == 1){
                                                    List<String> imagesUrl = [product[0].images[0],imageUrl,product[0].images[2] ];
                                                    Firestore.instance.collection("products").document(id_doc).updateData({
                                                      "images": imagesUrl,

                                                    });
                                                  }else if(index==2){
                                                    List<String> imagesUrl = [product[0].images[0],product[0].images[1], imageUrl, ];
                                                    Firestore.instance.collection("products").document(id_doc).updateData({
                                                      "images": imagesUrl,
                                                    });
                                                  }

                                                  Navigator.pop(context);
                                                  Fluttertoast.showToast(msg: 'Updated photo successfully', textColor: Colors.green);
                                                }catch(e){
                                                  print('err ${e.toString()}');
                                                }

                                              });
                                            });


                                            print('deleted');

                                          }catch(e){
                                            print('an error ocurred during deleting');


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
                          icon: Icon(Icons.edit, color: Colors.red,
                          ),),
                      ),
                      Container(
                        width: 150,
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: product[0].images[1] != null ?  Padding(
                            padding: const EdgeInsets.fromLTRB(4.0, 4, 4.0, 40),
                            child: Image.network(product[0].images[index], fit: BoxFit.cover),
                          ): OutlineButton(
                            borderSide: BorderSide(color: Colors.grey.withOpacity(0.8), width: 1.0),
                            onPressed: (){
//
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(14.0, 40, 14.0, 40),
                              child: Icon(Icons.add, color: Colors.grey,),
                            ),

                          ),
                        ),
                      ),
                    ],

                  );
                }
            ),
          ),
          Container(
            decoration: BoxDecoration(

            ),
            height: 220,
            padding: EdgeInsets.all(20),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                !editing_name ? Row(
                  children: <Widget>[
                    Text(product[0].productName, style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: 0,
                      fontSize: 18,
                    ),),
                    IconButton(
                      onPressed: (){
                        setState(() {
                          productName_controller.text = product[0].productName;
                          editing_name = true;
                        });
                      },
                      icon: Icon(Icons.edit, color: Colors.red,size: 17,), )
                  ],
                ) : Form(
                  key: _nameformKey,
                  child: Container(
                    width: 270,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: 200,
                          child: TextFormField(
                            controller: productName_controller,
                            decoration: InputDecoration(
                                hintText: "Product name"
                            ),
                            validator: (value){
                              if(value.isEmpty){
                                return ' product name';
                              }else if(value.length > 30){
                                return "Product name cant be more than 30 letters";
                              }
                            },
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            onPressed: (){
                              if(_nameformKey.currentState.validate()){
                                final Query categories_list = Firestore.instance
                                    .collection('products').where("id", isEqualTo: product[0].producsId);
                                categories_list.getDocuments().then((snaps){
                                  print(snaps.documents.length);
                                  final String id_doc = snaps.documents[0].documentID;
                                  Firestore.instance.collection("products").document(id_doc).updateData({
                                    "productName": productName_controller.text,

                                  });
                                });
                                setState(() {
                                  editing_name = false;
                                });
                              }

                            },
                            icon: Icon(Icons.check),tooltip: 'Update',color: Colors.green,),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Text("ksh.2,020", style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  letterSpacing: 1,
                  fontSize: 15,
                ),),
                SizedBox(height: 10,),
                !editing_price ? Row(
                  children: <Widget>[
                    Text(product[0].productPrice.toString(), style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: 0,
                      fontSize: 18,
                    ),),
                    IconButton(
                      onPressed: (){
                        setState(() {
                          productprice_controller.text = product[0].productPrice.toString();
                          editing_price = true;
                        });
                      },
                      icon: Icon(Icons.edit, color: Colors.red,size: 17,), )
                  ],
                ) : Form(
                  key: _priceformKey,
                  child: Container(
                    width: 270,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: 200,
                          child: TextFormField(
                              keyboardType: TextInputType.numberWithOptions(),
                              controller: productprice_controller,
                              decoration: InputDecoration(
                                  hintText: "Product name"
                              ),
                              validator: (value){
                                if(value.isEmpty){
                                  return "Price must be provided";
                                }
                              }

                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            onPressed: (){
                              if(_priceformKey.currentState.validate()){
                                final Query categories_list = Firestore.instance
                                    .collection('products').where("id", isEqualTo: product[0].producsId);
                                categories_list.getDocuments().then((snaps){
                                  print(snaps.documents.length);
                                  final String id_doc = snaps.documents[0].documentID;

                                  Firestore.instance.collection("products").document(id_doc).updateData({
                                    "price": double.parse(productprice_controller.text)

                                  });
                                });
                                setState(() {
                                  editing_price = false;
                                });
                              }

                            },
                            icon: Icon(Icons.check),tooltip: 'Update',color: Colors.green,),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(

                      height: 35,
                      width: 100,
                      padding: EdgeInsets.all(10),
                      decoration: ( BoxDecoration
                        (
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.green,

                      )
                      ),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("4.1", style: TextStyle(
                              color: Colors.white,
                              fontSize: 15
                          ),),
                          Icon(Icons.star, size: 20, color: Colors.white,)
                        ],
                      ),


                    ),
                    Text("(56)", style: TextStyle(
                        color: Colors.black,
                        fontSize: 15
                    ),),
                    Text("Reviews", style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                    ),),
                  ],
                ),
              ],
            ),

          ),

          SizedBox(height: 0,),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            padding: EdgeInsets.all(20),
            height: 220,

            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Text("Product Details", style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                  letterSpacing: 1,
                  fontSize: 18,
                ),),
                SizedBox(height: 20,),
                Text("1) MackBook Pro", style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black54,
                  letterSpacing: 1,
                  fontSize: 15,
                ),),
                SizedBox(height: 15,),
                Text("2) Ram 8Gb DDR4", style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black54,
                  letterSpacing: 1,
                  fontSize: 15,
                ),),
                SizedBox(height: 15,),
                Text("2) SSD 256 GB", style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black54,
                  letterSpacing: 1,
                  fontSize: 15,
                ),),
                SizedBox(height: 15,),

                Text("4) No Touch bar", style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black54,
                  letterSpacing: 1,
                  fontSize: 15,
                ),),
              ],
            ),

          ),
          SizedBox(height: 11,),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            height: 240,

            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      "Description",style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                    letterSpacing: 1,
                    fontSize: 20,)
                  ),
                  SizedBox(height: 20,),
                  !editing_description ? Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(product[0].productDescription, style: TextStyle(

                          color: Colors.black,
                          letterSpacing: 0,
                          fontSize: 18,
                        ),),
                      ),
                      IconButton(
                        onPressed: (){
                          setState(() {
                            productdescription_controller.text = product[0].productDescription;
                            editing_description = true;
                          });
                        },
                        icon: Icon(Icons.edit, color: Colors.red,size: 17,), )
                    ],
                  ) : Form(
                    key: _descriptionformKey,
                    child: Container(
                      width: 250,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: 200,
                            child: TextFormField(
                                keyboardType: TextInputType.numberWithOptions(),
                                controller: productdescription_controller,
                                maxLines: 5,
                                minLines: 5,
                                decoration: InputDecoration(
                                    hintText: "Product description"
                                ),
                                validator: (value){
                                  if(value.isEmpty){
                                    return "description must be provided";
                                  }
                                }

                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              onPressed: (){
                                if(_descriptionformKey.currentState.validate()){
                                  final Query categories_list = Firestore.instance
                                      .collection('products').where("id", isEqualTo: product[0].producsId);
                                  categories_list.getDocuments().then((snaps){
                                    print(snaps.documents.length);
                                    final String id_doc = snaps.documents[0].documentID;

                                    Firestore.instance.collection("products").document(id_doc).updateData({
                                      "description":productdescription_controller.text,

                                    });
                                  });
                                  setState(() {
                                    editing_description = false;
                                  });
                                }

                              },
                              icon: Icon(Icons.check),tooltip: 'Update',color: Colors.green,),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),

          SizedBox(height: 30,)
        ],

      );
    }

  }
}
