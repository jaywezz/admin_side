import 'package:adminside/db/category.dart';
import 'package:adminside/db/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddSubCategory extends StatefulWidget {
  @override
  _AddSubCategoryState createState() => _AddSubCategoryState();
}

class _AddSubCategoryState extends State<AddSubCategory> {
  CategoryService _categoryService = CategoryService();
  DataBaseService _productService = DataBaseService();
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory;
  TextEditingController subCategoryController = TextEditingController();
  GlobalKey<FormState> _subCategoryFormKey = GlobalKey();


  @override
  void initState() {
    _getCategories();
//    _productService.getSubCategory('foods');
    

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

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.2,
          backgroundColor: Colors.white,
          leading: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.close, color: Colors.black,)),
          title: Text('Add a sub category', style: TextStyle(color: Colors.black),)
      ),
      body:  Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _subCategoryFormKey,
          child: Column(
            children: <Widget>[
              Text('Choose a category below to add sub category', style: TextStyle(fontSize:16 , color: Colors.black),),
              SizedBox(height: 40,),
              Row(
                children: <Widget>[
                  Text('Category', style: TextStyle(fontSize:16 , color: Colors.black),),
                  SizedBox(width: 50,),
                  DropdownButton(

                    dropdownColor: Colors.white,
                    value: _currentCategory,
                    items: categoriesDropDown,
                    onChanged: changeSelectedCategory,
                  ),
                ],
              ),
              TextFormField(
                controller: subCategoryController,
                decoration: InputDecoration(
                    hintText: "sub category name"
                ),
                validator: (value){
                  if(value.isEmpty){
                    return 'Cannot add an empty sub-category';
                  }
                },
              ),
              SizedBox(height: 40,),
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('Add Sub Category'),
                onPressed: () async {
                  if(_subCategoryFormKey.currentState.validate()){
                    if(subCategoryController != null){
                      print(subCategoryController.text);
                       await _productService.createSubCategory(_currentCategory,subCategoryController.text);
                      Fluttertoast.showToast(msg: 'Succesfully added sub category');
                    }
//              Navigator.pop(context);
            }
                },
              )
            ],
          ),
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
}
