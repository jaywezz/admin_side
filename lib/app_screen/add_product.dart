
import 'package:adminside/db/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:adminside/db/category.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../loading.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  DataBaseService _productService = DataBaseService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController =TextEditingController();
  TextEditingController quantityController =TextEditingController();
  TextEditingController priceController =TextEditingController();
  TextEditingController descriptionController =TextEditingController();
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory;
  bool loding = false;
  String imageError = '';
  List images  = [];
  File _image1;
  File _image2;
  File _image3;

  final picker = ImagePicker();


  @override
  void initState() {
    _getCategories();

    print(categoriesDropDown.length);
    //_currentCategory = categoriesDropDown[0].value;
  }

  List<DropdownMenuItem<String>> getCategoriesDropDown(){
    List<DropdownMenuItem<String>> items = List();
   for(int i = 0; i<categories.length; i++){
     items.insert(0, DropdownMenuItem(child: Text(categories[i].data['category']),
     value:categories[i].data['category'],
     ));

   }
   print(items.length);
   return items;

  }
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image1 = File(pickedFile.path);
      images.add(_image1);
      print(_image1);
    });
  }
  Future getImage1() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image2 = File(pickedFile.path);
      images.add(_image2);
      print(_image1);
    });
  }
  Future getImage2() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image3 = File(pickedFile.path);
      images.add(_image3);
      print(images);

    });
  }


  @override
  Widget build(BuildContext context) {
    return loding ? Loading() : Scaffold(
      appBar: AppBar(
        elevation: 0.2,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Icons.close, color: Colors.black,)),
        title: Text('Add product', style: TextStyle(color: Colors.black),)
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _image1 != null ?  Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 40, 14.0, 40),
                      child: Image.file(_image1, fit: BoxFit.contain),
                    ): OutlineButton(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.8), width: 1.0),
                      onPressed: (){
                        getImage();
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14.0, 40, 14.0, 40),
                        child: Icon(Icons.add, color: Colors.grey,),
                      ),

                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _image2 != null ?  Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 40, 14.0, 40),
                      child: Image.file(_image2,fit: BoxFit.contain),
                    ): OutlineButton(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.8), width: 1.0),
                      onPressed: (){
                        getImage1();
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14.0, 40, 14.0, 40),
                        child: Icon(Icons.add, color: Colors.grey,),
                      ),

                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _image3 != null ?  Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 40, 14.0, 40),
                      child: Image.file(_image3, fit: BoxFit.contain),
                    ): OutlineButton(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.8), width: 1.0),
                      onPressed: (){
                        getImage2();
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14.0, 40, 14.0, 40),
                        child: Icon(Icons.add, color: Colors.grey,),
                      ),

                    ),
                  ),
                ),


              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(imageError, style: TextStyle(color: Colors.red, fontSize: 12),),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('Enter a product name',textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 12,)),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: productNameController,
                decoration: InputDecoration(
                  hintText: "Add Product name"
                ),
                validator: (value){
                  if(value.isEmpty){
                    return 'Add a product name';
                  }else if(value.length > 30){
                    return "Product name cant be more than 15 letters";
                  }
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 6,
                decoration: InputDecoration(
                    hintText: "Description"
                ),
                validator: (value){
                  if(value.isEmpty){
                    return 'Add quantity';
                  }
                },
              ),
            ),



            Row(
                 children: <Widget>[
                   Text('Categories', style: TextStyle(fontSize:16 , color: Colors.black),),
                   SizedBox(width: 50,),
                   DropdownButton(

                    dropdownColor: Colors.grey,
                    value: _currentCategory,
                    items: categoriesDropDown,
                    onChanged: changeSelectedCategory,
              ),
                 ],
               ),
            SizedBox(
              height: 0,
            ),

                Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: quantityController,
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                        hintText: "Quantity"
                        ),
                        validator: (value){
                        if(value.isEmpty){
                            return 'Add quantity';
                        }
                        },
                    ),
                ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: priceController,
                keyboardType: TextInputType.numberWithOptions(),

                decoration: InputDecoration(
                    hintText: "Price in kenyan shillings"
                ),
                validator: (value){
                  if(value.isEmpty){
                    return 'Add quantity';
                  }
                },
              ),
            ),

            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('add product'),
              onPressed: () async {
                validatAndUpload();
              },
            )

          ],
        ),
      ),
    );
  }

   _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    print(data.length);
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropDown();
      _currentCategory = categories[0].data['category'];
    });
   }

  changeSelectedCategory(String selectedCategory) {
    print('dcdjkvjd');
    setState(() => _currentCategory = selectedCategory);
    print(_currentCategory);
  }

  void validatAndUpload() async {
     if(_formKey.currentState.validate()) {
       setState(() {
         loding =true;
       });
       if(_image1 != null && _image2 != null && _image3 != null){
         String imageUrl1;
         String imageUrl2;
         String imageUrl3;
         final FirebaseStorage storage = FirebaseStorage.instance;

         final String pictures1= "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
         StorageUploadTask task1 = storage.ref().child(pictures1).putFile(_image1);
         final String pictures2 = "2${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
         StorageUploadTask task2 = storage.ref().child(pictures2).putFile(_image2);
         final String pictures3= "3${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
         StorageUploadTask task3 = storage.ref().child(pictures3).putFile(_image3);

         StorageTaskSnapshot snapshot1 = await task1.onComplete.then((snapshot) => snapshot);
         StorageTaskSnapshot snapshot2 = await task2.onComplete.then((snapshot) => snapshot);

         task3.onComplete.then((snapshot3) async {
           imageUrl1 = await snapshot1.ref.getDownloadURL();
           imageUrl2 = await snapshot2.ref.getDownloadURL();
           imageUrl3 = await snapshot3.ref.getDownloadURL();
           List<String> imagesUrl = [imageUrl1, imageUrl2, imageUrl3];
           try{
             print("adding products to database....");
             await _productService.uploadProduct(productNameController.text, descriptionController.text,_currentCategory, int.parse(quantityController.text), double.parse(priceController.text), imagesUrl);

           }catch(e){
             print("we had an error");
             print(e.toString());
           }
           setState(() {
             loding = false;
           });
           Fluttertoast.showToast(msg: "Product added");
         });

       }else{
         Fluttertoast.showToast(msg: "Upload atleast 3images");
         imageError = 'Upload atleast 3 images';
       }
     }

  }
}



