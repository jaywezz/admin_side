

import 'package:adminside/db/category.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController categoryController = TextEditingController();
  TextEditingController categoryDescriptionController = TextEditingController();
  GlobalKey<FormState> categoryFormKey = GlobalKey();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a category'),
        elevation: 0.3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: categoryFormKey,
          child: ListView(
            children: <Widget>[
              Container(
                height: 200,
                child: InkWell(
                  onTap: (){
                    getImage();
                  },
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
              ),
              TextFormField(
                controller: categoryController,
                validator: (value){
                  if(value.isEmpty){
                    return 'Cannot add an empty category';
                  }
                },
                decoration: InputDecoration(
                    hintText: "add category"
                ),
              ),
              TextFormField(
                controller: categoryDescriptionController,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 6,
                validator: (value){
                  if(value.isEmpty){
                    return 'Provide a category description';
                  }
                },
                decoration: InputDecoration(
                    hintText: "category descrption"
                ),
              ),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: FlatButton(

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
                  ): Text('Add category') ,
                  onPressed: () async {
                    if(categoryFormKey.currentState.validate()){
                      if(categoryController != null){

                        print(categoryController.text);
                        if(_image1 != null){
                          setState(() {
                            uploading = true;
                          });
                          String imageUrl;
                          final FirebaseStorage storage = FirebaseStorage.instance;
                          final String pictures1= "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
                          StorageUploadTask upload_task = storage.ref().child(pictures1).putFile(_image1);
                          upload_task.onComplete.then((value) async {
                            imageUrl = await value.ref.getDownloadURL();
                            await CategoryService().createCategory(categoryController.text, categoryDescriptionController.text, imageUrl);

                            setState(() {
                              uploading = false;

                            });
                            Fluttertoast.showToast(msg: 'category added');
                            categoryDescriptionController.clear();
                            categoryController.clear();
                          });


                        }
                      }
//              Navigator.pop(context);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
