import 'dart:ffi';

import 'package:adminside/app_screen/add_product.dart';
import 'package:adminside/app_screen/category_list.dart';
import 'package:adminside/app_screen/home.dart';
import 'package:adminside/app_screen/orders_list.dart';
import 'package:adminside/app_screen/product_list.dart';
import 'package:adminside/db/database.dart';
import 'package:adminside/models/categoriesData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _subCategoryisVisible = false;
  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<List<Categories>>(context) ?? [];



    print('printing sub category');


    return Drawer(

          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ListView(
              children: <Widget>[


                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Admin()));
                  },
                  child: ListTile(
                    title: Text('DashBoard'),
                    leading: Icon(Icons.home,  color: Colors.red),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Categories', style: TextStyle(fontSize: 12),),
                ),
                Divider(),
                InkWell(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) =>ProductList(categoryToDisplay: null)));
                  },
                  child: ListTile(
                    title: Text('All Products'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: categories.length,
                        itemBuilder: (context, index){
                          return Column(
                            children: <Widget>[
                              InkWell(
                                onTap: (){

                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) =>ProductList(categoryToDisplay: categories[index].categoryName,)));
                                },
                                child: ListTile(
                                  title: Text(categories[index].categoryName),
                                  trailing: IconButton(
                                     icon: Icon(Icons.arrow_forward_ios,
                                    color: Colors.redAccent,),
                                    onPressed: (){}

                                   ),
                                ),
                              ),

                            ],
                          );
                        }
                    ),
                  ),
                ),
//
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OrdersList()));
                  },
                  child: ListTile(
                    title: Text("Pending Orders"),
                    leading: Icon(Icons.shopping_basket,  color: Colors.red),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CategoryList()));
                  },
                  child: ListTile(
                    title: Text("Categories"),
                    leading: Icon(Icons.dashboard,  color: Colors.red),
                  ),
                ),
//                InkWell(
//                  onTap: (){},
//                  child: ListTile(
//
//                    title: Text("Favourites"),
//                    leading: Icon(Icons.favorite, color: Colors.red,),
//                  ),
//                ),

                Divider(),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddProduct()));
                  },
                  child: ListTile(
                    title: Text("Add Product"),
                    leading: Icon(Icons.add,  color: Colors.blueAccent),
                  ),
                ),
//                InkWell(
//                  onTap: (){},
//                  child: ListTile(
//                    title: Text("About"),
//                    leading: Icon(Icons.help,  color: Colors.deepOrangeAccent),
//                  ),
//                ),
                Divider(),
                InkWell(
                  onTap: () async{


                  },
                  child: ListTile(
                    title: Text("Log Out"),
                    leading: Icon(Icons.person_outline,  color: Colors.deepOrangeAccent),
                  ),
                ),



              ],
            ),
          ),
        );

  }


}
