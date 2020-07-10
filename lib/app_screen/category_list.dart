import 'package:adminside/app_screen/category_details.dart';
import 'package:adminside/models/categoriesData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    final category= Provider.of<List<Categories>>(context) ?? [];
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        title: Text('Categories'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: category.length,
                itemBuilder:(context, index){
                  if(category.length == 0){
                    return Text('No categories created',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),);
                  }
                  return  Card(
                    elevation: 8.0,
                    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: Container(
                        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                        child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            leading: Container(
                              padding: EdgeInsets.only(right: 12.0),
                              decoration: new BoxDecoration(
                                  border: new Border(
                                      right: new BorderSide(width: 1.0, color: Colors.white24))),
//                              child: Icon(Icons.person, color: Colors.white),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child:  Image.network(category[index].imageUrl ?? 'https://firebasestorage.googleapis.com/v0/b/online-shop-640ff.appspot.com/o/index.png?alt=media&token=5b8173c9-1318-4ff2-a4e3-81614d34f7c1',
                               height: 30,
                                )
                              ),

                            ),
                            title: Text(
                              category[index].categoryName,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),


                            trailing:
                            IconButton(icon: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 25.0),
                              onPressed: (){
                               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoryDetails(
                                 category_description: category[index].categoryDescription,
                                 category_id: category[index].category_id,
                                 category_name: category[index].categoryName,
                                 imageUrl: category[index].imageUrl ?? 'https://firebasestorage.googleapis.com/v0/b/online-shop-640ff.appspot.com/o/index.png?alt=media&token=5b8173c9-1318-4ff2-a4e3-81614d34f7c1',
                               )));
                              },
                            ))


                    ),
                  );
                }
            ),
          ),

        ],
      ),
    );

  }
}
