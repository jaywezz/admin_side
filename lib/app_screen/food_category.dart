import 'package:flutter/material.dart';

class FoodsCategory extends StatefulWidget {
  @override
  _FoodsCategoryState createState() => _FoodsCategoryState();
}

class _FoodsCategoryState extends State<FoodsCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF21BFBD),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:15.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                 IconButton(
                   icon: Icon(Icons.arrow_back_ios),
                   color: Colors.white,
                   onPressed: null,
                 ),
                Container(
                   width: 125,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.filter_list),
                        color: Colors.white,
                        onPressed: null,

                      ),
                      IconButton(
                        icon: Icon(Icons.menu),
                        color: Colors.white,
                        onPressed: null,

                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left:40.0),
            child: Row(
              children: <Widget>[
                Text('Healthy',
                style: TextStyle(
                  fontFamily: null,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0
                ),),
                SizedBox(width: 10,),
                Text('Food',
                  style: TextStyle(
                      fontFamily: null,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 25.0
                  ),),
              ],
            ),
          ),
          SizedBox(height: 30,),
          Container(
            height: MediaQuery.of(context).size.height -105.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: ListView(
              primary: false,
              padding: EdgeInsets.only(left: 25,right: 20),
              children: <Widget>[

              ],
            ),
          )
        ],
      ),
    );
  }
}
