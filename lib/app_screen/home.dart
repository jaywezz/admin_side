import 'package:adminside/app_screen/add_category.dart';
import 'package:adminside/app_screen/add_product.dart';
import 'package:adminside/app_screen/category_list.dart';
import 'package:adminside/app_screen/list_users.dart';
import 'package:adminside/app_screen/orders_list.dart';
import 'package:adminside/app_screen/product_list.dart';
import 'package:adminside/db/category.dart';
import 'package:adminside/db/database.dart';
import 'package:adminside/models/ordersData.dart';
import 'package:adminside/models/productsData.dart';
import 'package:adminside/models/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:adminside/models/categoriesData.dart';


import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'add_sub_category.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {



  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  CategoryService _categoryService = CategoryService();
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController subCategoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory;
  final snackBar = SnackBar(
      content:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.check, color: Colors.green,),
            title: Text("Successfuly added",style: TextStyle(),),
          ),

        ],
      )
  );

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.dashboard);
                      },
                      icon: Icon(
                        Icons.dashboard,
                        color: _selectedPage == Page.dashboard
                            ? active
                            : notActive,
                      ),
                      label: Text('Dashboard'))),
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.manage);
                      },
                      icon: Icon(
                        Icons.sort,
                        color:
                        _selectedPage == Page.manage ? active : notActive,
                      ),
                      label: Text('Manage'))),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: _loadScreen(context));
  }

  Widget _loadScreen(BuildContext context) {
    final user_data= Provider.of<List<UserData>>(context) ?? [];
    final category= Provider.of<List<Categories>>(context) ?? [];
    final products = Provider.of<List<ProductsData>>(context) ?? [];
    final orders = Provider.of<List<OrderData>>(context) ?? [];
    print("we have ${user_data.length} registered users");
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            ListTile(
              subtitle: FlatButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.attach_money,
                  size: 30.0,
                  color: Colors.green,
                ),
                label: Text('0.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.green)),
              ),
              title: Text(
                'Revenue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Userlist()));
                      },
                      child: Container(

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.lightBlue
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(Icons.person_outline, color: Colors.grey,),

                                  Text(
                                    'Users',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                                  )

                                ],
                              ),
                              Text(
                                user_data.length.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: active, fontSize: 30.0),
                              )
                            ],
                          ),
                        ),
//
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoryList()));
                      },
                      child: Container(

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[100]
                        ),
                         child: Padding(
                           padding: const EdgeInsets.all(18.0),
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: <Widget>[
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                 children: <Widget>[
                                    Icon(Icons.dashboard, color: Colors.grey,),

                                     Text(
                                          'Categories',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: active, fontSize: 15.0),
                                        )

                                 ],
                               ),
                               Text(
                                 category.length.toString(),
                                 textAlign: TextAlign.center,
                                 style: TextStyle(color: active, fontSize: 30.0),
                               )
                             ],
                           ),
                         ),
//
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductList()));

                      },
                      child: Container(

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[100]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(Icons.storage, color: Colors.grey,),

                                  Text(
                                    'Stock',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: active, fontSize: 15.0),
                                  )

                                ],
                              ),
                              Text(
                                products.length.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: active, fontSize: 30.0),
                              )
                            ],
                          ),
                        ),
//
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> OrdersList()));

                      },
                      child: Container(

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[100]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(Icons.person_outline, color: Colors.grey,),

                                  Text(
                                    'Orders',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: active, fontSize: 15.0),
                                  )

                                ],
                              ),
                              Text(
                                orders.length.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: active, fontSize: 30.0),
                              )
                            ],
                          ),
                        ),
//
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: null,
                      child:Container(

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[100]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(Icons.person_outline, color: Colors.grey,),

                                  Text(
                                    'Returns',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: active, fontSize: 15.0),
                                  )

                                ],
                              ),
                              Text(
                                '0',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: active, fontSize: 30.0),
                              )
                            ],
                          ),
                        ),
//
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: null,
                      child:Container(

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[100]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(Icons.person_outline, color: Colors.grey,),

                                  Text(
                                    'Pick up \nstations',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: active, fontSize: 15.0),
                                  )

                                ],
                              ),
                              Text(
                               '1',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: active, fontSize: 30.0),
                              )
                            ],
                          ),
                        ),
//
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add product"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) =>AddProduct()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.change_history),
              title: Text("Products list"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) =>ProductList()));

              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Add category"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) =>AddCategory()));
              },
            ),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Add a sub-category"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) =>AddSubCategory()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Category list"),
              onTap: () {},
            ),
            Divider(),
//            ListTile(
//              leading: Icon(Icons.add_circle_outline),
//              title: Text("Add brand"),
//              onTap: () {
//                _brandAlert();
//              },
//            ),
//            Divider(),
//            ListTile(
//              leading: Icon(Icons.library_books),
//              title: Text("brand list"),
//              onTap: () {},
//            ),
            Divider(),
          ],
        );
        break;
      default:
        return Container();
    }
  }


   //Adding a sub category form a an existing category
//  void _subCategoryAlert() {
//    var alert = new AlertDialog(
//
//      content: Form(
//        key: _categoryFormKey,
//        child: Column(
//
//          children: <Widget>[
//            Text('Choose a category to add subCategory', style: TextStyle(fontSize:16 , color: Colors.black),),
//            SizedBox(height: 40,),
//            DropdownButton(
//
//              dropdownColor: Colors.white,
//              value: _currentCategory,
//              items: categoriesDropDown,
//              onChanged: changeSelectedCategory,
//            ),
//            TextFormField(
//              controller: subCategoryController,
//              decoration: InputDecoration(
//                  hintText: "sub category name"
//              ),
//            ),
//          ],
//        ),
//      ),
//      actions: <Widget>[
//        FlatButton(onPressed: () async{
//          if(_categoryFormKey.currentState.validate()){
//            if(categoryController.text != null){
////              print(categoryController.text);
//              await _categoryService.createCategory(categoryController.text);
//              Fluttertoast.showToast(msg: 'category added');
//
//              Navigator.pop(context);
//            }
//
//          }
//
//
//
//        }, child: Text('ADD')),
//        FlatButton(onPressed: (){
//          Navigator.pop(context);
//        }, child: Text('CANCEL')),
//
//      ],
//    );
//
//    showDialog(context: context, builder: (_) => alert);
//  }
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
    setState(() {
      _currentCategory = selectedCategory;
    });
    print(_currentCategory);
  }



}
